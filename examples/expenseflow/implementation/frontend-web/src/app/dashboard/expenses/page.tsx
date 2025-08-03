'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import DashboardLayout from '@/components/layout/dashboard-layout'
import { expenseApi } from '@/lib/api'

interface Expense {
  id: number
  amount: number
  description: string
  status: string
  expense_date: string
  category: {
    name: string
  }
  created_at: string
}

export default function ExpensesPage() {
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<string>('all')
  const router = useRouter()

  useEffect(() => {
    const loadExpenses = async () => {
      try {
        const params = filter === 'all' ? {} : { status: filter }
        const data = await expenseApi.getExpenses(params)
        setExpenses(data)
      } catch (error) {
        console.error('Failed to load expenses:', error)
      } finally {
        setLoading(false)
      }
    }

    loadExpenses()
  }, [filter])

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

  const handleSubmitExpense = async (expenseId: number) => {
    try {
      await expenseApi.submitExpense(expenseId)
      // Reload expenses
      const params = filter === 'all' ? {} : { status: filter }
      const data = await expenseApi.getExpenses(params)
      setExpenses(data)
    } catch (error) {
      console.error('Failed to submit expense:', error)
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
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">My Expenses</h1>
            <p className="text-gray-600">Manage and track your expense submissions</p>
          </div>
          <Button onClick={() => router.push('/dashboard/expenses/new')}>
            <span className="mr-2">➕</span>
            New Expense
          </Button>
        </div>

        {/* Filters */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex space-x-2">
              {['all', 'draft', 'submitted', 'approved', 'rejected'].map((status) => (
                <Button
                  key={status}
                  variant={filter === status ? 'default' : 'outline'}
                  onClick={() => setFilter(status)}
                  className="capitalize"
                >
                  {status}
                </Button>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Expenses List */}
        <Card>
          <CardHeader>
            <CardTitle>Expenses</CardTitle>
            <CardDescription>
              {filter === 'all' ? 'All expenses' : `${filter} expenses`}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {expenses.length === 0 ? (
              <div className="text-center py-12">
                <p className="text-gray-500 mb-4">No expenses found</p>
                <Button onClick={() => router.push('/dashboard/expenses/new')}>
                  Create your first expense
                </Button>
              </div>
            ) : (
              <div className="space-y-4">
                {expenses.map((expense) => (
                  <div key={expense.id} className="border rounded-lg p-4 hover:bg-gray-50">
                    <div className="flex items-center justify-between">
                      <div className="flex-1">
                        <div className="flex items-center space-x-3">
                          <div>
                            <h3 className="font-medium text-gray-900">{expense.description}</h3>
                            <div className="flex items-center space-x-2 text-sm text-gray-500">
                              <span>{expense.category.name}</span>
                              <span>•</span>
                              <span>{new Date(expense.expense_date).toLocaleDateString()}</span>
                              <span>•</span>
                              <span>Created {new Date(expense.created_at).toLocaleDateString()}</span>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center space-x-4">
                        <span className="text-lg font-bold">${expense.amount.toFixed(2)}</span>
                        <span className={`px-3 py-1 rounded-full text-xs font-medium ${getStatusColor(expense.status)}`}>
                          {expense.status}
                        </span>
                        <div className="flex space-x-2">
                          {expense.status === 'draft' && (
                            <>
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => router.push(`/dashboard/expenses/${expense.id}/edit`)}
                              >
                                Edit
                              </Button>
                              <Button
                                size="sm"
                                onClick={() => handleSubmitExpense(expense.id)}
                              >
                                Submit
                              </Button>
                            </>
                          )}
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => router.push(`/dashboard/expenses/${expense.id}`)}
                          >
                            View
                          </Button>
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}