import React, { useState, useEffect } from 'react'
import { 
  User, Users, CreditCard, ShoppingBag, Activity,
  Plus, Search, Filter, Download, Eye, Edit, Phone,
  Mail, Calendar, MapPin, Star, TrendingUp,
  CheckCircle, Clock, AlertTriangle
} from 'lucide-react'
import { supabase } from '../../lib/supabase'

export function Members() {
  const [members, setMembers] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState('all')
  const [activeTab, setActiveTab] = useState('members')

  useEffect(() => {
    fetchMembers()
  }, [])

  const fetchMembers = async () => {
    try {
      setLoading(true)
      // Como a estrutura pode variar, vamos buscar de diferentes tabelas
      const { data: profilesData } = await supabase
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false })
      
      setMembers(profilesData || [])
    } catch (error) {
      console.error('Erro ao carregar membros:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredMembers = members.filter(member => {
    const matchesSearch = member.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         member.id?.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesStatus = statusFilter === 'all' || member.status === statusFilter
    return matchesSearch && matchesStatus
  })

  const tabs = [
    { id: 'members', label: 'Membros', icon: <Users className="w-4 h-4" /> },
    { id: 'subscriptions', label: 'Assinaturas', icon: <CreditCard className="w-4 h-4" /> },
    { id: 'payments', label: 'Pagamentos', icon: <ShoppingBag className="w-4 h-4" /> },
    { id: 'checkins', label: 'Check-ins', icon: <Activity className="w-4 h-4" /> }
  ]

  const renderMemberCard = (member: any) => (
    <div key={member.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
      <div className="flex items-start space-x-4">
        {/* Avatar */}
        <div className="w-16 h-16 bg-gradient-to-r from-blue-600 to-green-600 rounded-full flex items-center justify-center flex-shrink-0">
          <User className="w-8 h-8 text-white" />
        </div>
        
        {/* Info */}
        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between">
            <div>
              <h3 className="text-lg font-semibold text-gray-900 truncate">
                {member.full_name || 'Nome não informado'}
              </h3>
              <p className="text-sm text-gray-500">ID: {member.id.slice(0, 8)}...</p>
            </div>
            <span className={`px-2 py-1 rounded-full text-xs font-medium ${
              member.status === 'active' ? 'bg-green-100 text-green-800' :
              member.status === 'inactive' ? 'bg-red-100 text-red-800' :
              'bg-yellow-100 text-yellow-800'
            }`}>
              {member.status === 'active' ? 'Ativo' :
               member.status === 'inactive' ? 'Inativo' : 'Pendente'}
            </span>
          </div>
          
          <div className="mt-3 space-y-2">
            {member.phone && (
              <div className="flex items-center text-sm text-gray-600">
                <Phone className="w-4 h-4 mr-2 flex-shrink-0" />
                <span>{member.phone}</span>
              </div>
            )}
            
            <div className="flex items-center text-sm text-gray-600">
              <Calendar className="w-4 h-4 mr-2 flex-shrink-0" />
              <span>Membro desde {new Date(member.created_at).toLocaleDateString('pt-BR')}</span>
            </div>
            
            {member.role && (
              <div className="flex items-center text-sm text-gray-600">
                <Star className="w-4 h-4 mr-2 flex-shrink-0" />
                <span className="capitalize">
                  {member.role === 'admin' ? 'Administrador' :
                   member.role === 'manager' ? 'Gerente' :
                   member.role === 'employee' ? 'Funcionário' : 'Membro'}
                </span>
              </div>
            )}
          </div>
          
          {/* Actions */}
          <div className="flex items-center justify-between mt-4 pt-4 border-t border-gray-200">
            <div className="flex items-center space-x-2">
              <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50">
                <Eye className="w-4 h-4" />
              </button>
              <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50">
                <Edit className="w-4 h-4" />
              </button>
              <button className="p-2 text-gray-400 hover:text-green-600 transition-colors rounded-lg hover:bg-green-50">
                <Phone className="w-4 h-4" />
              </button>
            </div>
            <div className="text-xs text-gray-500">
              Última atividade: Hoje
            </div>
          </div>
        </div>
      </div>
    </div>
  )

  const renderSubscriptions = () => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <CreditCard className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">Gestão de Assinaturas</h3>
      <p className="text-gray-600 mb-6">Gerencie planos, renovações e upgrades dos membros</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Plus className="w-4 h-4 mr-2" />
        Nova Assinatura
      </button>
    </div>
  )

  const renderPayments = () => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <ShoppingBag className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">Histórico de Pagamentos</h3>
      <p className="text-gray-600 mb-6">Visualize transações, faturas e formas de pagamento</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Eye className="w-4 h-4 mr-2" />
        Ver Pagamentos
      </button>
    </div>
  )

  const renderCheckins = () => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <Activity className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">Check-ins dos Membros</h3>
      <p className="text-gray-600 mb-6">Acompanhe frequência e padrões de uso da academia</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Activity className="w-4 h-4 mr-2" />
        Ver Check-ins
      </button>
    </div>
  )

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="h-8 bg-gray-200 rounded animate-pulse"></div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[...Array(6)].map((_, i) => (
            <div key={i} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 animate-pulse">
              <div className="flex items-start space-x-4">
                <div className="w-16 h-16 bg-gray-200 rounded-full"></div>
                <div className="flex-1 space-y-2">
                  <div className="h-6 bg-gray-200 rounded"></div>
                  <div className="h-4 bg-gray-200 rounded w-3/4"></div>
                  <div className="h-4 bg-gray-200 rounded w-1/2"></div>
                </div>
              </div>
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
          <h1 className="text-3xl font-bold text-gray-900">Gestão de Membros</h1>
          <p className="text-gray-600 mt-1">Gerencie membros, assinaturas e atividades</p>
        </div>
        <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4 mr-2" />
          Novo Membro
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Total de Membros</p>
              <p className="text-2xl font-bold text-gray-900">{members.length}</p>
              <p className="text-xs text-green-600 flex items-center mt-1">
                <TrendingUp className="w-3 h-3 mr-1" />
                +12% este mês
              </p>
            </div>
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
              <Users className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Membros Ativos</p>
              <p className="text-2xl font-bold text-gray-900">
                {members.filter(m => m.status === 'active' || !m.status).length}
              </p>
              <p className="text-xs text-green-600 flex items-center mt-1">
                <CheckCircle className="w-3 h-3 mr-1" />
                95% de retenção
              </p>
            </div>
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
              <CheckCircle className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Check-ins Hoje</p>
              <p className="text-2xl font-bold text-gray-900">89</p>
              <p className="text-xs text-blue-600 flex items-center mt-1">
                <Activity className="w-3 h-3 mr-1" />
                Média diária
              </p>
            </div>
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
              <Activity className="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Mensalidades Pendentes</p>
              <p className="text-2xl font-bold text-gray-900">7</p>
              <p className="text-xs text-orange-600 flex items-center mt-1">
                <Clock className="w-3 h-3 mr-1" />
                Acompanhar
              </p>
            </div>
            <div className="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
              <AlertTriangle className="w-6 h-6 text-orange-600" />
            </div>
          </div>
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
          {activeTab === 'members' && (
            <div className="space-y-6">
              {/* Filters */}
              <div className="flex flex-col sm:flex-row gap-4">
                <div className="flex-1">
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                    <input
                      type="text"
                      placeholder="Buscar membros..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                  </div>
                </div>
                <div className="flex gap-2">
                  <select
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                    className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="all">Todos os Status</option>
                    <option value="active">Ativo</option>
                    <option value="inactive">Inativo</option>
                    <option value="suspended">Suspenso</option>
                  </select>
                  <button className="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
                    <Filter className="w-4 h-4 mr-2" />
                    Filtros
                  </button>
                  <button className="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
                    <Download className="w-4 h-4 mr-2" />
                    Exportar
                  </button>
                </div>
              </div>

              {/* Members Grid */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                {filteredMembers.length > 0 ? (
                  filteredMembers.map(renderMemberCard)
                ) : (
                  <div className="col-span-full text-center py-12">
                    <Users className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Nenhum membro encontrado</h3>
                    <p className="text-gray-600">Tente ajustar os filtros ou adicionar novos membros</p>
                  </div>
                )}
              </div>
            </div>
          )}
          {activeTab === 'subscriptions' && renderSubscriptions()}
          {activeTab === 'payments' && renderPayments()}
          {activeTab === 'checkins' && renderCheckins()}
        </div>
      </div>
    </div>
  )
}

export default Members
