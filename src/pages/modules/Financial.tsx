import React, { useState, useEffect } from 'react'
import { 
  DollarSign, TrendingUp, TrendingDown, CreditCard, 
  PieChart, BarChart3, Calendar, Download, Filter,
  Plus, ArrowUpRight, ArrowDownRight, RefreshCw,
  Wallet, Building, Receipt, Target
} from 'lucide-react'
import { supabase } from '../../lib/supabase'

export function Financial() {
  const [transactions, setTransactions] = useState<any[]>([])
  const [accounts, setAccounts] = useState<any[]>([])
  const [categories, setCategories] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('overview')
  const [selectedPeriod, setSelectedPeriod] = useState('month')

  useEffect(() => {
    fetchFinancialData()
  }, [])

  const fetchFinancialData = async () => {
    try {
      setLoading(true)
      const [transactionsRes, accountsRes, categoriesRes] = await Promise.all([
        supabase.from('financial_transactions').select('*').order('created_at', { ascending: false }),
        supabase.from('financial_accounts').select('*'),
        supabase.from('financial_categories').select('*')
      ])
      
      setTransactions(transactionsRes.data || [])
      setAccounts(accountsRes.data || [])
      setCategories(categoriesRes.data || [])
    } catch (error) {
      console.error('Erro ao carregar dados financeiros:', error)
    } finally {
      setLoading(false)
    }
  }

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value)
  }

  const tabs = [
    { id: 'overview', label: 'Visão Geral', icon: <BarChart3 className="w-4 h-4" /> },
    { id: 'accounts', label: 'Contas', icon: <Wallet className="w-4 h-4" /> },
    { id: 'categories', label: 'Categorias', icon: <PieChart className="w-4 h-4" /> },
    { id: 'transactions', label: 'Transações', icon: <Receipt className="w-4 h-4" /> },
    { id: 'reconciliation', label: 'Conciliação', icon: <RefreshCw className="w-4 h-4" /> },
    { id: 'reports', label: 'Relatórios', icon: <TrendingUp className="w-4 h-4" /> }
  ]

  const renderOverview = () => {
    const totalBalance = accounts.reduce((sum, acc) => sum + (acc.balance || 0), 0)
    const monthlyRevenue = 125000 // Simulado
    const monthlyExpenses = 87000 // Simulado
    const profit = monthlyRevenue - monthlyExpenses
    
    return (
      <div className="space-y-6">
        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Saldo Total</p>
                <p className="text-2xl font-bold text-gray-900">{formatCurrency(totalBalance)}</p>
                <p className="text-xs text-green-600 flex items-center mt-1">
                  <TrendingUp className="w-3 h-3 mr-1" />
                  +5.2% este mês
                </p>
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Receita Mensal</p>
                <p className="text-2xl font-bold text-gray-900">{formatCurrency(monthlyRevenue)}</p>
                <p className="text-xs text-green-600 flex items-center mt-1">
                  <ArrowUpRight className="w-3 h-3 mr-1" />
                  +12% vs mês anterior
                </p>
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-blue-600" />
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Despesas Mensais</p>
                <p className="text-2xl font-bold text-gray-900">{formatCurrency(monthlyExpenses)}</p>
                <p className="text-xs text-red-600 flex items-center mt-1">
                  <ArrowDownRight className="w-3 h-3 mr-1" />
                  +3% vs mês anterior
                </p>
              </div>
              <div className="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                <TrendingDown className="w-6 h-6 text-red-600" />
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Lucro Líquido</p>
                <p className="text-2xl font-bold text-gray-900">{formatCurrency(profit)}</p>
                <p className="text-xs text-green-600 flex items-center mt-1">
                  <Target className="w-3 h-3 mr-1" />
                  Margem: {((profit / monthlyRevenue) * 100).toFixed(1)}%
                </p>
              </div>
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Target className="w-6 h-6 text-purple-600" />
              </div>
            </div>
          </div>
        </div>
        
        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Fluxo de Caixa - 12 Meses</h3>
              <BarChart3 className="w-5 h-5 text-gray-400" />
            </div>
            <div className="h-64 flex items-center justify-center text-gray-500">
              <div className="text-center">
                <BarChart3 className="w-16 h-16 mx-auto mb-4 text-gray-300" />
                <p className="text-lg font-medium">Gráfico de Fluxo de Caixa</p>
                <p className="text-sm">Receitas vs Despesas ao longo do tempo</p>
                <button className="mt-3 px-4 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700 transition-colors">
                  Visualizar Dados
                </button>
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Despesas por Categoria</h3>
              <PieChart className="w-5 h-5 text-gray-400" />
            </div>
            <div className="h-64 flex items-center justify-center text-gray-500">
              <div className="text-center">
                <PieChart className="w-16 h-16 mx-auto mb-4 text-gray-300" />
                <p className="text-lg font-medium">Distribuição de Gastos</p>
                <p className="text-sm">Análise por categoria de despesa</p>
                <button className="mt-3 px-4 py-2 bg-green-600 text-white rounded-lg text-sm hover:bg-green-700 transition-colors">
                  Ver Breakdown
                </button>
              </div>
            </div>
          </div>
        </div>
        
        {/* Recent Transactions */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Transações Recentes</h3>
            <button className="text-sm text-blue-600 hover:text-blue-700 font-medium">
              Ver Todas
            </button>
          </div>
          <div className="space-y-3">
            {[1, 2, 3, 4, 5].map((_, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center space-x-3">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                    index % 2 === 0 ? 'bg-green-100' : 'bg-red-100'
                  }`}>
                    {index % 2 === 0 ? (
                      <ArrowUpRight className="w-4 h-4 text-green-600" />
                    ) : (
                      <ArrowDownRight className="w-4 h-4 text-red-600" />
                    )}
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">
                      {index % 2 === 0 ? 'Mensalidade Recebida' : 'Pagamento Fornecedor'}
                    </p>
                    <p className="text-sm text-gray-500">
                      {index % 2 === 0 ? 'João Silva - Plano Premium' : 'Equipamentos XYZ Ltda'}
                    </p>
                  </div>
                </div>
                <div className="text-right">
                  <p className={`font-medium ${
                    index % 2 === 0 ? 'text-green-600' : 'text-red-600'
                  }`}>
                    {index % 2 === 0 ? '+' : '-'}{formatCurrency(Math.random() * 500 + 100)}
                  </p>
                  <p className="text-xs text-gray-500">Hoje, 14:30</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    )
  }

  const renderAccounts = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Contas Financeiras</h3>
          <p className="text-sm text-gray-600">Gerencie contas bancárias e cartões</p>
        </div>
        <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4 mr-2" />
          Nova Conta
        </button>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {accounts.map((account) => (
          <div key={account.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-start justify-between mb-4">
              <div>
                <h4 className="text-lg font-semibold text-gray-900">{account.name}</h4>
                <p className="text-sm text-gray-500 capitalize">{account.type}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                {account.type === 'checking' ? (
                  <Building className="w-5 h-5 text-blue-600" />
                ) : account.type === 'credit_card' ? (
                  <CreditCard className="w-5 h-5 text-blue-600" />
                ) : (
                  <Wallet className="w-5 h-5 text-blue-600" />
                )}
              </div>
            </div>
            
            <div className="space-y-2 mb-4">
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Banco:</span>
                <span className="text-sm font-medium">{account.bank_name || 'Não informado'}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Conta:</span>
                <span className="text-sm font-medium">{account.account_number || 'Não informado'}</span>
              </div>
            </div>
            
            <div className="pt-4 border-t border-gray-200">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Saldo:</span>
                <span className={`text-lg font-bold ${
                  (account.balance || 0) >= 0 ? 'text-green-600' : 'text-red-600'
                }`}>
                  {formatCurrency(account.balance || 0)}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )

  const renderPlaceholder = (title: string, description: string, buttonText: string) => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <BarChart3 className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600 mb-6">{description}</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Plus className="w-4 h-4 mr-2" />
        {buttonText}
      </button>
    </div>
  )

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="h-8 bg-gray-200 rounded animate-pulse"></div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[...Array(4)].map((_, i) => (
            <div key={i} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 animate-pulse">
              <div className="h-6 bg-gray-200 rounded mb-4"></div>
              <div className="h-8 bg-gray-200 rounded mb-2"></div>
              <div className="h-4 bg-gray-200 rounded w-1/2"></div>
            </div>
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Módulo Financeiro</h1>
          <p className="text-gray-600 mt-1">Gestão financeira completa e relatórios</p>
        </div>
        <div className="flex items-center space-x-3">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="week">Esta Semana</option>
            <option value="month">Este Mês</option>
            <option value="quarter">Este Trimestre</option>
            <option value="year">Este Ano</option>
          </select>
          <button className="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
            <Download className="w-4 h-4 mr-2" />
            Exportar
          </button>
          <button className="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
            <Filter className="w-4 h-4 mr-2" />
            Filtros
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200">
        <div className="border-b border-gray-200">
          <nav className="flex space-x-8 px-6" aria-label="Tabs">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`py-4 px-1 border-b-2 font-medium text-sm whitespace-nowrap flex items-center space-x-2 transition-colors ${
                  activeTab === tab.id
                    ? 'border-blue-500 text-blue-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
              >
                {tab.icon}
                <span>{tab.label}</span>
              </button>
            ))}
          </nav>
        </div>
        
        <div className="p-6">
          {activeTab === 'overview' && renderOverview()}
          {activeTab === 'accounts' && renderAccounts()}
          {activeTab === 'categories' && renderPlaceholder('Categorias Financeiras', 'Organize receitas e despesas por categoria', 'Nova Categoria')}
          {activeTab === 'transactions' && renderPlaceholder('Histórico de Transações', 'Visualize todas as movimentações financeiras', 'Nova Transação')}
          {activeTab === 'reconciliation' && renderPlaceholder('Conciliação Bancária', 'Concilie extratos bancários com o sistema', 'Iniciar Conciliação')}
          {activeTab === 'reports' && renderPlaceholder('Relatórios Financeiros', 'DRE, Fluxo de Caixa e outros relatórios', 'Gerar Relatório')}
        </div>
      </div>
    </div>
  )
}

export default Financial
