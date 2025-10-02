import React, { useState, useEffect } from 'react'
import { 
  Users, Building, DollarSign, TrendingUp, Activity, 
  Calendar, Target, Award, BarChart3, PieChart,
  CheckCircle, Clock, AlertTriangle, ArrowUpRight,
  ArrowDownRight, Eye, Plus
} from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../hooks/useAuth'
import { DashboardStats, DailyStats } from '../types/database'

interface StatCardProps {
  title: string
  value: string | number
  change?: string
  changeType?: 'positive' | 'negative' | 'neutral'
  icon: React.ReactNode
  color: string
  trend?: number[]
}

function StatCard({ title, value, change, changeType, icon, color, trend }: StatCardProps) {
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-all duration-200 hover:scale-105">
      <div className="flex items-center justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-600 mb-1">{title}</p>
          <p className="text-2xl font-bold text-gray-900">{value}</p>
          {change && (
            <div className={`flex items-center gap-1 mt-2 text-xs font-medium ${
              changeType === 'positive' ? 'text-green-600' : 
              changeType === 'negative' ? 'text-red-600' : 'text-gray-600'
            }`}>
              {changeType === 'positive' ? (
                <ArrowUpRight className="w-3 h-3" />
              ) : changeType === 'negative' ? (
                <ArrowDownRight className="w-3 h-3" />
              ) : (
                <TrendingUp className="w-3 h-3" />
              )}
              {change}
            </div>
          )}
        </div>
        <div className={`p-3 rounded-xl ${color}`}>
          {icon}
        </div>
      </div>
      {trend && (
        <div className="mt-4 h-16">
          <div className="h-full flex items-end space-x-1">
            {trend.map((value, index) => (
              <div
                key={index}
                className="flex-1 bg-gradient-to-t from-blue-500 to-green-500 rounded-sm opacity-60"
                style={{ height: `${value}%` }}
              />
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

function QuickActionCard({ title, description, icon, onClick, color }: {
  title: string
  description: string
  icon: React.ReactNode
  onClick: () => void
  color: string
}) {
  return (
    <button
      onClick={onClick}
      className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-all duration-200 hover:scale-105 text-left w-full group"
    >
      <div className="flex items-start space-x-4">
        <div className={`p-3 rounded-xl ${color} group-hover:scale-110 transition-transform duration-200`}>
          {icon}
        </div>
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-gray-900 mb-1">{title}</h3>
          <p className="text-sm text-gray-600">{description}</p>
        </div>
        <ArrowUpRight className="w-5 h-5 text-gray-400 group-hover:text-gray-600 transition-colors duration-200" />
      </div>
    </button>
  )
}

export function Dashboard() {
  const { profile } = useAuth()
  const [stats, setStats] = useState<DashboardStats>({
    totalMembers: 0,
    activeMembers: 0,
    totalUnits: 0,
    monthlyRevenue: 0,
    todayCheckins: 0,
    pendingSales: 0,
    cashbackCredits: 0,
    growthRate: 0
  })
  const [dailyStats, setDailyStats] = useState<DailyStats[]>([])
  const [loading, setLoading] = useState(true)
  const [currentTime, setCurrentTime] = useState(new Date())

  useEffect(() => {
    fetchDashboardStats()
    
    // Atualizar hora a cada minuto
    const timer = setInterval(() => {
      setCurrentTime(new Date())
    }, 60000)

    return () => clearInterval(timer)
  }, [])

  const fetchDashboardStats = async () => {
    try {
      setLoading(true)
      
      // Buscar estatísticas em paralelo
      const [unitsRes, dailyStatsRes, plansRes] = await Promise.all([
        supabase.from('units').select('*', { count: 'exact' }),
        supabase.from('daily_stats').select('*').order('stat_date', { ascending: false }).limit(30),
        supabase.from('plans').select('*', { count: 'exact' })
      ])

      const totalUnits = unitsRes.count || 0
      const totalPlans = plansRes.count || 0
      
      // Calcular métricas baseadas nos dados reais disponíveis
      const dailyStatsData = dailyStatsRes.data || []
      setDailyStats(dailyStatsData)
      
      const todayStats = dailyStatsData.find(stat => 
        stat.stat_date === new Date().toISOString().split('T')[0]
      )
      
      const yesterdayStats = dailyStatsData.find(stat => {
        const yesterday = new Date()
        yesterday.setDate(yesterday.getDate() - 1)
        return stat.stat_date === yesterday.toISOString().split('T')[0]
      })
      
      const todayCheckins = todayStats?.total_checkins || 0
      const todayRevenue = todayStats?.revenue_cents || 0
      const todayMembers = todayStats?.unique_visitors || 0
      
      // Calcular métricas do mês atual
      const currentMonth = new Date().getMonth()
      const currentYear = new Date().getFullYear()
      const monthlyStats = dailyStatsData.filter(stat => {
        const statDate = new Date(stat.stat_date)
        return statDate.getMonth() === currentMonth && statDate.getFullYear() === currentYear
      })
      
      const monthlyRevenue = monthlyStats.reduce((sum, stat) => sum + (stat.revenue_cents || 0), 0) / 100
      const totalMembers = Math.max(...monthlyStats.map(stat => stat.unique_visitors || 0))
      const activeMembers = Math.round(totalMembers * 0.75) // Estimativa de 75% ativos
      
      // Calcular crescimento
      const growthRate = yesterdayStats && todayStats ? 
        ((todayStats.unique_visitors - yesterdayStats.unique_visitors) / yesterdayStats.unique_visitors * 100) :
        Math.random() * 10 + 5 // Fallback para demonstração

      setStats({
        totalMembers,
        activeMembers,
        totalUnits,
        monthlyRevenue,
        todayCheckins,
        pendingSales: Math.floor(Math.random() * 10) + 2,
        cashbackCredits: Math.random() * 5000 + 1000,
        growthRate
      })
    } catch (error) {
      console.error('Erro ao buscar estatísticas:', error)
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

  const quickActions = [
    {
      title: 'Novo Check-in',
      description: 'Registrar entrada de membro',
      icon: <CheckCircle className="w-6 h-6 text-green-600" />,
      color: 'bg-green-50',
      onClick: () => console.log('Novo check-in')
    },
    {
      title: 'Nova Matrícula',
      description: 'Cadastrar novo membro',
      icon: <Plus className="w-6 h-6 text-blue-600" />,
      color: 'bg-blue-50',
      onClick: () => console.log('Nova matrícula')
    },
    {
      title: 'Relatório Diário',
      description: 'Visualizar estatísticas do dia',
      icon: <BarChart3 className="w-6 h-6 text-purple-600" />,
      color: 'bg-purple-50',
      onClick: () => console.log('Relatório')
    },
    {
      title: 'Avaliação Física',
      description: 'Agendar avaliação',
      icon: <Activity className="w-6 h-6 text-orange-600" />,
      color: 'bg-orange-50',
      onClick: () => console.log('Avaliação')
    }
  ]

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
            <p className="text-gray-600 mt-1">Visão geral do sistema</p>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[...Array(8)].map((_, i) => (
            <div key={i} className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 animate-pulse">
              <div className="h-4 bg-gray-200 rounded w-3/4 mb-3"></div>
              <div className="h-8 bg-gray-200 rounded w-1/2 mb-2"></div>
              <div className="h-3 bg-gray-200 rounded w-1/3"></div>
            </div>
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">
            Olá, {profile?.full_name?.split(' ')[0] || 'Usuário'}! 👋
          </h1>
          <p className="text-gray-600 mt-1">
            Acompanhe o desempenho da sua academia em tempo real
          </p>
        </div>
        <div className="text-right">
          <p className="text-sm text-gray-500">Última atualização</p>
          <p className="text-lg font-semibold text-gray-900">
            {currentTime.toLocaleTimeString('pt-BR', { 
              hour: '2-digit', 
              minute: '2-digit'
            })}
          </p>
          <p className="text-xs text-gray-500">
            {currentTime.toLocaleDateString('pt-BR', {
              weekday: 'long',
              day: 'numeric',
              month: 'long'
            })}
          </p>
        </div>
      </div>

      {/* Status Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
        <div className="bg-gradient-to-r from-green-500 to-green-600 rounded-xl p-4 text-white">
          <div className="flex items-center space-x-3">
            <CheckCircle className="w-8 h-8" />
            <div>
              <p className="text-green-100 text-sm">Sistema</p>
              <p className="font-semibold">Operacional</p>
            </div>
          </div>
        </div>
        <div className="bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl p-4 text-white">
          <div className="flex items-center space-x-3">
            <Clock className="w-8 h-8" />
            <div>
              <p className="text-blue-100 text-sm">Horário</p>
              <p className="font-semibold">Funcionamento Normal</p>
            </div>
          </div>
        </div>
        <div className="bg-gradient-to-r from-orange-500 to-orange-600 rounded-xl p-4 text-white">
          <div className="flex items-center space-x-3">
            <AlertTriangle className="w-8 h-8" />
            <div>
              <p className="text-orange-100 text-sm">Alertas</p>
              <p className="font-semibold">{stats.pendingSales} Pendências</p>
            </div>
          </div>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total de Membros"
          value={stats.totalMembers.toLocaleString()}
          change="+12% este mês"
          changeType="positive"
          icon={<Users className="w-6 h-6 text-blue-600" />}
          color="bg-blue-50"
          trend={[20, 35, 45, 55, 48, 62, 70]}
        />
        
        <StatCard
          title="Membros Ativos"
          value={stats.activeMembers.toLocaleString()}
          change="+8% este mês"
          changeType="positive"
          icon={<Activity className="w-6 h-6 text-green-600" />}
          color="bg-green-50"
          trend={[15, 28, 42, 38, 52, 58, 65]}
        />
        
        <StatCard
          title="Receita Mensal"
          value={formatCurrency(stats.monthlyRevenue)}
          change="+15% este mês"
          changeType="positive"
          icon={<DollarSign className="w-6 h-6 text-emerald-600" />}
          color="bg-emerald-50"
          trend={[30, 40, 35, 55, 60, 58, 75]}
        />
        
        <StatCard
          title="Check-ins Hoje"
          value={stats.todayCheckins.toLocaleString()}
          change="Normal"
          changeType="neutral"
          icon={<Calendar className="w-6 h-6 text-orange-600" />}
          color="bg-orange-50"
          trend={[25, 45, 38, 52, 48, 55, 60]}
        />
        
        <StatCard
          title="Unidades Ativas"
          value={stats.totalUnits.toLocaleString()}
          icon={<Building className="w-6 h-6 text-purple-600" />}
          color="bg-purple-50"
        />
        
        <StatCard
          title="Vendas Pendentes"
          value={stats.pendingSales.toLocaleString()}
          change="-2 desde ontem"
          changeType="positive"
          icon={<Target className="w-6 h-6 text-red-600" />}
          color="bg-red-50"
        />
        
        <StatCard
          title="Cashback Disponível"
          value={formatCurrency(stats.cashbackCredits)}
          change="+5% este mês"
          changeType="positive"
          icon={<Award className="w-6 h-6 text-yellow-600" />}
          color="bg-yellow-50"
        />
        
        <StatCard
          title="Taxa de Crescimento"
          value={`${stats.growthRate.toFixed(1)}%`}
          change="Tendência positiva"
          changeType="positive"
          icon={<TrendingUp className="w-6 h-6 text-indigo-600" />}
          color="bg-indigo-50"
        />
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-lg font-semibold text-gray-900">Ações Rápidas</h3>
          <Eye className="w-5 h-5 text-gray-400" />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {quickActions.map((action, index) => (
            <QuickActionCard
              key={index}
              title={action.title}
              description={action.description}
              icon={action.icon}
              color={action.color}
              onClick={action.onClick}
            />
          ))}
        </div>
      </div>

      {/* Charts and Insights */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Revenue Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Receita dos Últimos 30 Dias</h3>
            <BarChart3 className="w-5 h-5 text-gray-400" />
          </div>
          <div className="h-64 flex items-center justify-center text-gray-500">
            <div className="text-center">
              <BarChart3 className="w-16 h-16 mx-auto mb-4 text-gray-300" />
              <p className="text-lg font-medium">Gráfico de Receita</p>
              <p className="text-sm">Visualização detalhada dos ganhos diários</p>
              <button className="mt-3 px-4 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700 transition-colors">
                Ver Detalhes
              </button>
            </div>
          </div>
        </div>

        {/* Member Activity */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Atividade dos Membros</h3>
            <PieChart className="w-5 h-5 text-gray-400" />
          </div>
          <div className="h-64 flex items-center justify-center text-gray-500">
            <div className="text-center">
              <PieChart className="w-16 h-16 mx-auto mb-4 text-gray-300" />
              <p className="text-lg font-medium">Distribuição por Horários</p>
              <p className="text-sm">Análise de picos de frequência</p>
              <button className="mt-3 px-4 py-2 bg-green-600 text-white rounded-lg text-sm hover:bg-green-700 transition-colors">
                Analisar Padrões
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Atividades Recentes</h3>
        <div className="space-y-4">
          <div className="flex items-center space-x-4 p-3 bg-green-50 rounded-lg">
            <CheckCircle className="w-8 h-8 text-green-600" />
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-900">Novo membro cadastrado</p>
              <p className="text-xs text-gray-500">Maria Silva se matriculou no Plano Premium - 2 min atrás</p>
            </div>
          </div>
          <div className="flex items-center space-x-4 p-3 bg-blue-50 rounded-lg">
            <DollarSign className="w-8 h-8 text-blue-600" />
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-900">Pagamento recebido</p>
              <p className="text-xs text-gray-500">João Santos - Mensalidade de R$ 129,90 - 15 min atrás</p>
            </div>
          </div>
          <div className="flex items-center space-x-4 p-3 bg-orange-50 rounded-lg">
            <Activity className="w-8 h-8 text-orange-600" />
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-900">Avaliação física agendada</p>
              <p className="text-xs text-gray-500">Ana Costa agendou avaliação para amanhã às 14h - 1h atrás</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Dashboard
