# ExpenseFlow Web Development Plan

**Web Developer:** Jim  
**Date:** July 31, 2025  
**Version:** 1.0

---

## Overview

This document outlines the comprehensive Next.js development implementation plan for ExpenseFlow's web dashboard, incorporating requirements from the PRD, system architecture, UI design specifications, and security requirements.

### Development Objectives
- **Performance**: <2 second page loads, server-side rendering
- **Responsive**: Desktop-first with mobile adaptations
- **Real-time**: WebSocket updates for live expense tracking
- **Security**: Role-based access, secure authentication
- **Analytics**: Rich data visualization and reporting

---

## Project Architecture

### Next.js 14 Project Structure
```
src/
├── app/                          # App Router (Next.js 14)
│   ├── (auth)/                   # Route groups
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/
│   │   ├── dashboard/
│   │   ├── expenses/
│   │   ├── analytics/
│   │   └── admin/
│   ├── api/                      # API routes
│   │   ├── auth/
│   │   ├── expenses/
│   │   └── analytics/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/                   # Reusable components
│   ├── ui/                       # shadcn/ui components
│   ├── forms/
│   ├── charts/
│   └── layout/
├── lib/                          # Utility functions
│   ├── auth.ts
│   ├── db.ts
│   ├── utils.ts
│   └── validations.ts
├── hooks/                        # Custom React hooks
├── store/                        # State management (Zustand)
├── types/                        # TypeScript definitions
└── middleware.ts                 # Next.js middleware
```

### Technology Stack
```json
{
  "framework": "Next.js 14 (App Router)",
  "language": "TypeScript",
  "styling": "Tailwind CSS + shadcn/ui",
  "state": "Zustand + TanStack Query",
  "database": "Prisma + PostgreSQL",
  "auth": "NextAuth.js v5",
  "charts": "Recharts + Chart.js",
  "forms": "React Hook Form + Zod",
  "testing": "Jest + React Testing Library + Playwright"
}
```

---

## Core Features Implementation

### 1. Authentication System

#### NextAuth.js Configuration
```typescript
// lib/auth.ts
import NextAuth from "next-auth"
import { PrismaAdapter } from "@auth/prisma-adapter"
import CredentialsProvider from "next-auth/providers/credentials"
import { prisma } from "@/lib/db"

export const { handlers, auth, signIn, signOut } = NextAuth({
  adapter: PrismaAdapter(prisma),
  session: { strategy: "jwt" },
  providers: [
    CredentialsProvider({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null
        
        const user = await prisma.user.findUnique({
          where: { email: credentials.email },
          select: {
            id: true,
            email: true,
            name: true,
            role: true,
            hashedPassword: true
          }
        })
        
        if (!user) return null
        
        const isValidPassword = await bcrypt.compare(
          credentials.password,
          user.hashedPassword
        )
        
        if (!isValidPassword) return null
        
        return {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role
        }
      }
    })
  ],
  pages: {
    signIn: "/login",
    error: "/login"
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role
      }
      return token
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!
        session.user.role = token.role as string
      }
      return session
    }
  }
})
```

#### Protected Route Middleware
```typescript
// middleware.ts
import { auth } from "@/lib/auth"
import { NextResponse } from "next/server"

export default auth((request) => {
  const { pathname } = request.nextUrl
  const isAuthenticated = !!request.auth
  
  // Public routes
  if (pathname.startsWith('/login') || pathname.startsWith('/register')) {
    if (isAuthenticated) {
      return NextResponse.redirect(new URL('/dashboard', request.url))
    }
    return NextResponse.next()
  }
  
  // Protected routes
  if (!isAuthenticated) {
    return NextResponse.redirect(new URL('/login', request.url))
  }
  
  // Role-based access control
  const userRole = request.auth?.user?.role
  
  if (pathname.startsWith('/admin') && userRole !== 'ADMIN') {
    return NextResponse.redirect(new URL('/dashboard', request.url))
  }
  
  return NextResponse.next()
})

export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico).*)"]
}
```

### 2. Database Integration with Prisma

#### Prisma Schema
```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id             String    @id @default(cuid())
  email          String    @unique
  name           String?
  hashedPassword String
  role           Role      @default(EMPLOYEE)
  departmentId   String?
  managerId      String?
  
  // Relations
  expenses       Expense[]
  approvals      Approval[]
  manager        User?     @relation("UserManager", fields: [managerId], references: [id])
  subordinates   User[]    @relation("UserManager")
  
  createdAt      DateTime  @default(now())
  updatedAt      DateTime  @updatedAt
  
  @@map("users")
}

model Expense {
  id            String      @id @default(cuid())
  title         String
  description   String?
  amount        Decimal     @db.Decimal(10, 2)
  currency      String      @default("USD")
  categoryId    String
  dateIncurred  DateTime
  status        ExpenseStatus @default(DRAFT)
  submissionDate DateTime?
  
  // Relations
  userId        String
  user          User        @relation(fields: [userId], references: [id])
  category      Category    @relation(fields: [categoryId], references: [id])
  receipts      Receipt[]
  approvals     Approval[]
  
  createdAt     DateTime    @default(now())
  updatedAt     DateTime    @updatedAt
  
  @@map("expenses")
}

model Receipt {
  id         String   @id @default(cuid())
  fileName   String
  fileUrl    String
  fileSize   Int
  mimeType   String
  ocrData    Json?
  
  // Relations
  expenseId  String
  expense    Expense  @relation(fields: [expenseId], references: [id], onDelete: Cascade)
  
  createdAt  DateTime @default(now())
  
  @@map("receipts")
}

enum Role {
  EMPLOYEE
  MANAGER
  FINANCE
  ADMIN
}

enum ExpenseStatus {
  DRAFT
  SUBMITTED
  APPROVED
  REJECTED
  PAID
}
```

#### Database Service Layer
```typescript
// lib/db.ts
import { PrismaClient } from '@prisma/client'

declare global {
  var prisma: PrismaClient | undefined
}

export const prisma = globalThis.prisma || new PrismaClient()

if (process.env.NODE_ENV !== 'production') {
  globalThis.prisma = prisma
}

// Expense service
export class ExpenseService {
  static async getExpensesByUser(userId: string, status?: ExpenseStatus) {
    return prisma.expense.findMany({
      where: {
        userId,
        ...(status && { status })
      },
      include: {
        category: true,
        receipts: true,
        approvals: {
          include: {
            approver: {
              select: { id: true, name: true, email: true }
            }
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    })
  }
  
  static async getPendingApprovalsForManager(managerId: string) {
    return prisma.expense.findMany({
      where: {
        status: ExpenseStatus.SUBMITTED,
        user: {
          managerId
        }
      },
      include: {
        user: {
          select: { id: true, name: true, email: true }
        },
        category: true,
        receipts: true
      },
      orderBy: { submissionDate: 'asc' }
    })
  }
  
  static async approveExpense(expenseId: string, approverId: string, comments?: string) {
    return prisma.$transaction([
      prisma.expense.update({
        where: { id: expenseId },
        data: { status: ExpenseStatus.APPROVED }
      }),
      prisma.approval.create({
        data: {
          expenseId,
          approverId,
          status: ApprovalStatus.APPROVED,
          comments
        }
      })
    ])
  }
}
```

### 3. State Management with Zustand

#### Global Store Configuration
```typescript
// store/index.ts
import { create } from 'zustand'
import { devtools } from 'zustand/middleware'

interface AppStore {
  // User state
  user: User | null
  setUser: (user: User | null) => void
  
  // UI state
  sidebarCollapsed: boolean
  toggleSidebar: () => void
  
  // Notifications
  notifications: Notification[]
  addNotification: (notification: Notification) => void
  removeNotification: (id: string) => void
}

export const useAppStore = create<AppStore>()(
  devtools((set, get) => ({
    // User state
    user: null,
    setUser: (user) => set({ user }),
    
    // UI state
    sidebarCollapsed: false,
    toggleSidebar: () => set((state) => ({ 
      sidebarCollapsed: !state.sidebarCollapsed 
    })),
    
    // Notifications
    notifications: [],
    addNotification: (notification) => set((state) => ({
      notifications: [...state.notifications, notification]
    })),
    removeNotification: (id) => set((state) => ({
      notifications: state.notifications.filter(n => n.id !== id)
    }))
  }))
)
```

#### TanStack Query Setup
```typescript
// lib/query-client.ts
import { QueryClient } from '@tanstack/react-query'

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 10,   // 10 minutes
      retry: (failureCount, error: any) => {
        if (error?.status === 401 || error?.status === 403) {
          return false
        }
        return failureCount < 3
      }
    }
  }
})

// Custom hooks
export function useExpenses(status?: ExpenseStatus) {
  return useQuery({
    queryKey: ['expenses', status],
    queryFn: () => api.expenses.getAll({ status }),
    staleTime: 1000 * 60 * 2 // 2 minutes
  })
}

export function usePendingApprovals() {
  return useQuery({
    queryKey: ['pending-approvals'],
    queryFn: () => api.expenses.getPendingApprovals(),
    refetchInterval: 30000 // Poll every 30 seconds
  })
}
```

### 4. Component Architecture

#### Manager Dashboard
```typescript
// app/(dashboard)/dashboard/page.tsx
import { Suspense } from 'react'
import { auth } from '@/lib/auth'
import { redirect } from 'next/navigation'
import { DashboardCards } from '@/components/dashboard/dashboard-cards'
import { PendingApprovals } from '@/components/dashboard/pending-approvals'
import { TeamAnalytics } from '@/components/dashboard/team-analytics'
import { RecentActivity } from '@/components/dashboard/recent-activity'

export default async function DashboardPage() {
  const session = await auth()
  
  if (!session) {
    redirect('/login')
  }
  
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
        <div className="text-sm text-muted-foreground">
          Welcome back, {session.user.name}
        </div>
      </div>
      
      <Suspense fallback={<DashboardCardsSkeleton />}>
        <DashboardCards />
      </Suspense>
      
      <div className="grid gap-6 md:grid-cols-2">
        <Suspense fallback={<PendingApprovalsSkeleton />}>
          <PendingApprovals />
        </Suspense>
        
        <Suspense fallback={<RecentActivitySkeleton />}>
          <RecentActivity />
        </Suspense>
      </div>
      
      <Suspense fallback={<TeamAnalyticsSkeleton />}>
        <TeamAnalytics />
      </Suspense>
    </div>
  )
}
```

#### Expense Approval Interface
```typescript
// components/expenses/approval-interface.tsx
'use client'

import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Textarea } from '@/components/ui/textarea'
import { ExpenseDetailModal } from './expense-detail-modal'

export function ApprovalInterface() {
  const [selectedExpense, setSelectedExpense] = useState<Expense | null>(null)
  const [bulkSelected, setBulkSelected] = useState<string[]>([])
  const queryClient = useQueryClient()
  
  const { data: pendingExpenses, isLoading } = useQuery({
    queryKey: ['pending-approvals'],
    queryFn: () => api.expenses.getPendingApprovals()
  })
  
  const approveMutation = useMutation({
    mutationFn: (data: { expenseId: string; comments?: string }) =>
      api.expenses.approve(data.expenseId, data.comments),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pending-approvals'] })
      toast.success('Expense approved successfully')
    }
  })
  
  const rejectMutation = useMutation({
    mutationFn: (data: { expenseId: string; reason: string }) =>
      api.expenses.reject(data.expenseId, data.reason),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pending-approvals'] })
      toast.success('Expense rejected')
    }
  })
  
  if (isLoading) {
    return <ApprovalInterfaceSkeleton />
  }
  
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Expense List */}
      <Card className="p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-semibold">Pending Approvals</h2>
          <Badge variant="secondary">
            {pendingExpenses?.length || 0} pending
          </Badge>
        </div>
        
        <div className="space-y-4">
          {pendingExpenses?.map((expense) => (
            <ExpenseCard
              key={expense.id}
              expense={expense}
              isSelected={bulkSelected.includes(expense.id)}
              onSelect={(id, selected) => {
                if (selected) {
                  setBulkSelected([...bulkSelected, id])
                } else {
                  setBulkSelected(bulkSelected.filter(x => x !== id))
                }
              }}
              onClick={() => setSelectedExpense(expense)}
            />
          ))}
        </div>
        
        {bulkSelected.length > 0 && (
          <div className="mt-4 p-4 bg-muted rounded-lg">
            <div className="flex items-center justify-between">
              <span>{bulkSelected.length} expenses selected</span>
              <div className="space-x-2">
                <Button size="sm" onClick={() => handleBulkApprove()}>
                  Bulk Approve
                </Button>
                <Button size="sm" variant="outline" onClick={() => setBulkSelected([])}>
                  Clear Selection
                </Button>
              </div>
            </div>
          </div>
        )}
      </Card>
      
      {/* Expense Details */}
      <Card className="p-6">
        {selectedExpense ? (
          <ExpenseDetails
            expense={selectedExpense}
            onApprove={(comments) => {
              approveMutation.mutate({
                expenseId: selectedExpense.id,
                comments
              })
            }}
            onReject={(reason) => {
              rejectMutation.mutate({
                expenseId: selectedExpense.id,
                reason
              })
            }}
          />
        ) : (
          <div className="flex items-center justify-center h-64 text-muted-foreground">
            Select an expense to view details
          </div>
        )}
      </Card>
    </div>
  )
}
```

### 5. Data Visualization

#### Analytics Dashboard
```typescript
// components/analytics/analytics-dashboard.tsx
'use client'

import { useQuery } from '@tanstack/react-query'
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar
} from 'recharts'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

export function AnalyticsDashboard() {
  const { data: analyticsData } = useQuery({
    queryKey: ['analytics'],
    queryFn: () => api.analytics.getDashboardData()
  })
  
  return (
    <div className="space-y-6">
      {/* Key Metrics */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <MetricCard
          title="Total Spend"
          value={formatCurrency(analyticsData?.totalSpend || 0)}
          change={analyticsData?.spendChange}
        />
        <MetricCard
          title="Avg Processing Time"
          value={`${analyticsData?.avgProcessingTime || 0} days`}
          change={analyticsData?.processingTimeChange}
        />
        <MetricCard
          title="Pending Approvals"
          value={analyticsData?.pendingCount || 0}
          urgent={analyticsData?.urgentCount}
        />
        <MetricCard
          title="Policy Compliance"
          value={`${analyticsData?.complianceRate || 0}%`}
          change={analyticsData?.complianceChange}
        />
      </div>
      
      {/* Charts */}
      <div className="grid gap-6 md:grid-cols-2">
        {/* Spending Trends */}
        <Card>
          <CardHeader>
            <CardTitle>Spending Trends</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={analyticsData?.spendingTrends}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis />
                <Tooltip formatter={(value) => formatCurrency(value as number)} />
                <Area
                  type="monotone"
                  dataKey="actual"
                  stackId="1"
                  stroke="#2563eb"
                  fill="#2563eb"
                  fillOpacity={0.6}
                />
                <Area
                  type="monotone"
                  dataKey="budget"
                  stackId="2"
                  stroke="#dc2626"
                  fill="#dc2626"
                  fillOpacity={0.3}
                />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
        
        {/* Category Breakdown */}
        <Card>
          <CardHeader>
            <CardTitle>Expense Categories</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={analyticsData?.categoryBreakdown}
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                >
                  {analyticsData?.categoryBreakdown?.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip formatter={(value) => formatCurrency(value as number)} />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
```

### 6. Real-time Updates

#### WebSocket Integration
```typescript
// lib/websocket.ts
import { useEffect, useRef } from 'react'
import { useQueryClient } from '@tanstack/react-query'

export function useWebSocket(url: string) {
  const ws = useRef<WebSocket | null>(null)
  const queryClient = useQueryClient()
  
  useEffect(() => {
    ws.current = new WebSocket(url)
    
    ws.current.onopen = () => {
      console.log('WebSocket connected')
    }
    
    ws.current.onmessage = (event) => {
      const data = JSON.parse(event.data)
      
      switch (data.type) {
        case 'EXPENSE_UPDATED':
          queryClient.invalidateQueries({ queryKey: ['expenses'] })
          queryClient.invalidateQueries({ queryKey: ['pending-approvals'] })
          break
          
        case 'NEW_EXPENSE_SUBMITTED':
          queryClient.invalidateQueries({ queryKey: ['pending-approvals'] })
          // Show notification
          toast.info(`New expense submitted by ${data.payload.userName}`)
          break
          
        case 'APPROVAL_STATUS_CHANGED':
          queryClient.invalidateQueries({ queryKey: ['expenses'] })
          break
      }
    }
    
    ws.current.onerror = (error) => {
      console.error('WebSocket error:', error)
    }
    
    return () => {
      ws.current?.close()
    }
  }, [url, queryClient])
  
  return ws.current
}
```

### 7. Form Handling

#### React Hook Form with Zod Validation
```typescript
// components/forms/expense-form.tsx
'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import * as z from 'zod'

const expenseSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  amount: z.number().positive('Amount must be positive'),
  categoryId: z.string().min(1, 'Category is required'),
  dateIncurred: z.date(),
  description: z.string().optional(),
  receipts: z.array(z.instanceof(File)).optional()
})

type ExpenseFormData = z.infer<typeof expenseSchema>

export function ExpenseForm() {
  const form = useForm<ExpenseFormData>({
    resolver: zodResolver(expenseSchema),
    defaultValues: {
      title: '',
      amount: 0,
      categoryId: '',
      dateIncurred: new Date(),
      description: ''
    }
  })
  
  const createExpenseMutation = useMutation({
    mutationFn: (data: ExpenseFormData) => api.expenses.create(data),
    onSuccess: () => {
      toast.success('Expense created successfully')
      form.reset()
    },
    onError: (error) => {
      toast.error('Failed to create expense')
    }
  })
  
  const onSubmit = (data: ExpenseFormData) => {
    createExpenseMutation.mutate(data)
  }
  
  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <FormField
          control={form.control}
          name="title"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Title</FormLabel>
              <FormControl>
                <Input placeholder="Enter expense title" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="amount"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Amount</FormLabel>
              <FormControl>
                <Input
                  type="number"
                  step="0.01"
                  placeholder="0.00"
                  {...field}
                  onChange={(e) => field.onChange(parseFloat(e.target.value))}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <Button
          type="submit"
          className="w-full"
          disabled={createExpenseMutation.isPending}
        >
          {createExpenseMutation.isPending ? 'Creating...' : 'Create Expense'}
        </Button>
      </form>
    </Form>
  )
}
```

---

## Performance Optimization

### 1. Server-Side Rendering
```typescript
// app/(dashboard)/expenses/page.tsx
import { auth } from '@/lib/auth'
import { ExpenseService } from '@/lib/db'
import { ExpenseList } from '@/components/expenses/expense-list'

export default async function ExpensesPage() {
  const session = await auth()
  
  // Pre-fetch data on server
  const initialExpenses = await ExpenseService.getExpensesByUser(session!.user.id)
  
  return (
    <div>
      <h1>Expenses</h1>
      <ExpenseList initialData={initialExpenses} />
    </div>
  )
}
```

### 2. Image Optimization
```typescript
// components/ui/optimized-image.tsx
import Image from 'next/image'
import { useState } from 'react'

interface OptimizedImageProps {
  src: string
  alt: string
  width: number
  height: number
}

export function OptimizedImage({ src, alt, width, height }: OptimizedImageProps) {
  const [isLoading, setIsLoading] = useState(true)
  
  return (
    <div className="relative overflow-hidden rounded-lg">
      {isLoading && (
        <div className="absolute inset-0 bg-muted animate-pulse" />
      )}
      <Image
        src={src}
        alt={alt}
        width={width}
        height={height}
        className={`transition-opacity duration-300 ${
          isLoading ? 'opacity-0' : 'opacity-100'
        }`}
        onLoad={() => setIsLoading(false)}
        priority={false}
        placeholder="blur"
        blurDataURL="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k="
      />
    </div>
  )
}
```

### 3. Code Splitting and Lazy Loading
```typescript
// Dynamic imports for heavy components
const AnalyticsDashboard = dynamic(
  () => import('@/components/analytics/analytics-dashboard'),
  {
    loading: () => <AnalyticsDashboardSkeleton />,
    ssr: false
  }
)

const ExpenseChart = dynamic(
  () => import('@/components/charts/expense-chart'),
  {
    loading: () => <div className="h-64 bg-muted animate-pulse rounded" />,
    ssr: false
  }
)
```

---

## Testing Strategy

### 1. Unit Testing with Jest
```typescript
// __tests__/components/expense-form.test.tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ExpenseForm } from '@/components/forms/expense-form'

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } }
  })
  
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}

describe('ExpenseForm', () => {
  it('should render form fields correctly', () => {
    render(<ExpenseForm />, { wrapper: createWrapper() })
    
    expect(screen.getByLabelText(/title/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/amount/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/category/i)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /create expense/i })).toBeInTheDocument()
  })
  
  it('should validate required fields', async () => {
    render(<ExpenseForm />, { wrapper: createWrapper() })
    
    fireEvent.click(screen.getByRole('button', { name: /create expense/i }))
    
    await waitFor(() => {
      expect(screen.getByText(/title is required/i)).toBeInTheDocument()
    })
  })
  
  it('should submit form with valid data', async () => {
    const mockCreateExpense = jest.fn().mockResolvedValue({})
    
    render(<ExpenseForm />, { wrapper: createWrapper() })
    
    fireEvent.change(screen.getByLabelText(/title/i), {
      target: { value: 'Business Lunch' }
    })
    fireEvent.change(screen.getByLabelText(/amount/i), {
      target: { value: '25.99' }
    })
    
    fireEvent.click(screen.getByRole('button', { name: /create expense/i }))
    
    await waitFor(() => {
      expect(mockCreateExpense).toHaveBeenCalledWith({
        title: 'Business Lunch',
        amount: 25.99,
        // ... other fields
      })
    })
  })
})
```

### 2. Integration Testing with Playwright
```typescript
// e2e/expense-approval.spec.ts
import { test, expect } from '@playwright/test'

test.describe('Expense Approval Workflow', () => {
  test.beforeEach(async ({ page }) => {
    // Login as manager
    await page.goto('/login')
    await page.fill('[data-testid="email"]', 'manager@company.com')
    await page.fill('[data-testid="password"]', 'password123')
    await page.click('[data-testid="login-button"]')
    
    await expect(page).toHaveURL('/dashboard')
  })
  
  test('should approve an expense', async ({ page }) => {
    // Navigate to pending approvals
    await page.click('[data-testid="pending-approvals-link"]')
    
    // Select first expense
    await page.click('[data-testid="expense-card"]:first-child')
    
    // Add approval comment
    await page.fill('[data-testid="approval-comment"]', 'Approved - within policy')
    
    // Click approve button
    await page.click('[data-testid="approve-button"]')
    
    // Verify success message
    await expect(page.locator('[data-testid="success-toast"]')).toBeVisible()
    
    // Verify expense is no longer in pending list
    await expect(page.locator('[data-testid="expense-card"]')).toHaveCount(0)
  })
  
  test('should reject an expense with reason', async ({ page }) => {
    await page.click('[data-testid="pending-approvals-link"]')
    await page.click('[data-testid="expense-card"]:first-child')
    
    // Click reject button
    await page.click('[data-testid="reject-button"]')
    
    // Fill rejection reason (required)
    await page.fill('[data-testid="rejection-reason"]', 'Missing itemized receipt')
    
    // Confirm rejection
    await page.click('[data-testid="confirm-reject"]')
    
    await expect(page.locator('[data-testid="success-toast"]')).toBeVisible()
  })
})
```

---

## Deployment Configuration

### 1. Next.js Configuration
```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['s3.amazonaws.com', 'storage.googleapis.com'],
    formats: ['image/webp', 'image/avif']
  },
  experimental: {
    serverComponentsExternalPackages: ['@prisma/client']
  },
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false
      }
    }
    return config
  },
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY
  },
  async redirects() {
    return [
      {
        source: '/',
        destination: '/dashboard',
        permanent: false
      }
    ]
  }
}

module.exports = nextConfig
```

### 2. Docker Configuration
```dockerfile
# Dockerfile
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN yarn build

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

---

## Implementation Timeline

### Phase 1: Core Infrastructure (Weeks 1-4)
- **Week 1**: Next.js 14 setup, TypeScript configuration, Tailwind CSS
- **Week 2**: Authentication system (NextAuth.js), middleware, protected routes
- **Week 3**: Database integration (Prisma), basic CRUD operations
- **Week 4**: State management (Zustand), TanStack Query setup

### Phase 2: Manager Features (Weeks 5-8)
- **Week 5**: Dashboard layout, navigation, basic UI components
- **Week 6**: Expense approval interface, bulk operations
- **Week 7**: Real-time updates (WebSocket), notifications
- **Week 8**: Analytics dashboard, data visualization

### Phase 3: Admin Features (Weeks 9-12)
- **Week 9**: User management interface, role-based access
- **Week 10**: Policy configuration, system settings
- **Week 11**: Advanced reporting, export functionality
- **Week 12**: Performance optimization, caching strategies

### Phase 4: Testing & Polish (Weeks 13-16)
- **Week 13**: Unit testing, component testing
- **Week 14**: Integration testing, E2E testing with Playwright
- **Week 15**: Performance testing, accessibility auditing
- **Week 16**: Production build, deployment preparation

---

## Success Metrics

### Performance Targets
- **Page Load Time**: <2 seconds for dashboard
- **Time to Interactive**: <3 seconds
- **First Contentful Paint**: <1.5 seconds
- **API Response Time**: <500ms for 95% of requests
- **Bundle Size**: <500KB initial bundle

### User Experience Metrics
- **Task Completion Rate**: >95% for approval workflows
- **Time to Approve**: <30 seconds average
- **Error Rate**: <1% of user interactions
- **Mobile Responsiveness**: 100% functionality on tablets

### Technical Metrics
- **Test Coverage**: >90% code coverage
- **Build Time**: <3 minutes for production build
- **TypeScript Coverage**: 100% type coverage
- **Accessibility Score**: >95% WCAG 2.1 AA compliance

---

## Conclusion

This comprehensive Next.js development plan provides a robust foundation for ExpenseFlow's web dashboard. The architecture emphasizes performance, security, and user experience while maintaining scalability and maintainability.

The combination of Next.js 14's App Router, TypeScript, and modern React patterns creates a powerful platform for complex business workflows. The integration with Prisma and PostgreSQL ensures data consistency and performance at scale.

By following this implementation plan, the development team will deliver a production-ready web application that meets all business requirements while providing an exceptional user experience for managers and administrators.

---

*This document serves as the complete implementation guide for ExpenseFlow's web dashboard, ensuring consistent development practices and successful project delivery.*