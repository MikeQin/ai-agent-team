'use client'

import { useEffect, useState } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import DashboardLayout from '@/components/layout/dashboard-layout'
import { expenseApi } from '@/lib/api'
import { useRouter } from 'next/navigation'

interface Expense {
  id: number
  amount: number
  description: string
  status: string
  expense_date: string
  category: {
    name: string
  }
}

export default function DashboardPage() {
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState({
    total: 0,
    pending: 0,
    approved: 0,
    rejected: 0
  })
  const router = useRouter()

  useEffect(() => {
    const loadDashboardData = async () => {
      try {
        const expensesData = await expenseApi.getExpenses({ limit: 10 })
        setExpenses(expensesData)

        // Calculate stats
        const allExpenses = await expenseApi.getExpenses({ limit: 1000 })
        const stats = allExpenses.reduce((acc: any, expense: Expense) => {
          acc.total += expense.amount
          acc[expense.status] = (acc[expense.status] || 0) + 1
          return acc
        }, { total: 0, pending: 0, approved: 0, rejected: 0, draft: 0, submitted: 0 })
        
        setStats({
          total: stats.total,
          pending: (stats.pending || 0) + (stats.submitted || 0),
          approved: stats.approved || 0,
          rejected: stats.rejected || 0
        })
      } catch (error) {
        console.error('Failed to load dashboard data:', error)
      } finally {
        setLoading(false)
      }
    }

    loadDashboardData()
  }, [])

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'approved': return 'text-green-600 bg-green-100'
      case 'rejected': return 'text-red-600 bg-red-100'
      case 'submitted': return 'text-yellow-600 bg-yellow-100'
      case 'pending': return 'text-yellow-600 bg-yellow-100'
      case 'draft': return 'text-gray-600 bg-gray-100'
      default: return 'text-gray-600 bg-gray-100'
    }
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Welcome Section */}
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600">Overview of your expense management</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>Total Expenses</CardDescription>
              <CardTitle className="text-2xl">${stats.total.toFixed(2)}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>Pending Approval</CardDescription>
              <CardTitle className="text-2xl text-yellow-600">{stats.pending}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>Approved</CardDescription>
              <CardTitle className="text-2xl text-green-600">{stats.approved}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>Rejected</CardDescription>
              <CardTitle className="text-2xl text-red-600">{stats.rejected}</CardTitle>
            </CardHeader>
          </Card>
        </div>

        {/* Quick Actions */}
        <Card>
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
            <CardDescription>Common tasks to get you started</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Button 
                onClick={() => router.push('/dashboard/expenses/new')}
                className="h-24 flex flex-col items-center justify-center space-y-2"
              >
                <span className="text-2xl">➕</span>
                <span>New Expense</span>
              </Button>
              <Button 
                variant="outline"
                onClick={() => router.push('/dashboard/expenses')}
                className="h-24 flex flex-col items-center justify-center space-y-2"
              >
                <span className="text-2xl">📋</span>
                <span>View Expenses</span>
              </Button>
              <Button 
                variant="outline"
                onClick={() => router.push('/dashboard/approvals')}
                className="h-24 flex flex-col items-center justify-center space-y-2"
              >
                <span className="text-2xl">✅</span>
                <span>Approvals</span>
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Recent Expenses */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Expenses</CardTitle>
            <CardDescription>Your latest expense submissions</CardDescription>
          </CardHeader>
          <CardContent>
            {expenses.length === 0 ? (
              <p className="text-gray-500 text-center py-8">No expenses found. Create your first expense!</p>
            ) : (
              <div className="space-y-4">
                {expenses.map((expense) => (
                  <div key={expense.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50">
                    <div className="flex-1">
                      <div className="flex items-center space-x-3">
                        <div>
                          <p className="font-medium">{expense.description}</p>
                          <p className="text-sm text-gray-500">
                            {expense.category.name} • {new Date(expense.expense_date).toLocaleDateString()}
                          </p>
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center space-x-4">
                      <span className="font-bold">${expense.amount.toFixed(2)}</span>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(expense.status)}`}>
                        {expense.status}
                      </span>
                    </div>
                  </div>
                ))}
                <div className="text-center pt-4">
                  <Button variant="outline" onClick={() => router.push('/dashboard/expenses')}>
                    View All Expenses
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}