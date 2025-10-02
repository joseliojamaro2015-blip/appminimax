import React, { useState, useEffect } from 'react'
import { 
  User, 
  UserPlus, 
  Edit, 
  Search, 
  Filter,
  Phone,
  Mail,
  Badge,
  CheckCircle,
  XCircle,
  AlertCircle
} from 'lucide-react'
import { supabase } from '../../../lib/supabase'
import { Client } from '../../../types/database'

interface ClientsPageProps {}

const ClientsPage: React.FC<ClientsPageProps> = () => {
  const [clients, setClients] = useState<Client[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState<'all' | 'active' | 'inactive'>('all')
  const [error, setError] = useState<string | null>(null)

  // Função para buscar clientes do Supabase
  const fetchClients = async () => {
    try {
      setLoading(true)
      setError(null)
      
      const { data, error } = await supabase
        .from('clients')
        .select(`
          *,
          people!inner(
            full_name,
            email,
            phone,
            cpf_cnpj,
            birth_date,
            gender,
            address,
            city,
            state,
            postal_code,
            is_active
          )
        `)
        .order('created_at', { ascending: false })
      
      if (error) {
        console.error('Erro ao buscar clientes:', error)
        setError('Erro ao carregar clientes. Tente novamente.')
        return
      }
      
      // Transformar os dados para incluir informações da pessoa
      const clientsWithPersonData: Client[] = data?.map(client => ({
        ...client,
        full_name: client.people.full_name,
        email: client.people.email,
        phone: client.people.phone,
        cpf_cnpj: client.people.cpf_cnpj,
        birth_date: client.people.birth_date,
        gender: client.people.gender,
        address: client.people.address,
        city: client.people.city,
        state: client.people.state,
        postal_code: client.people.postal_code
      })) || []
      
      setClients(clientsWithPersonData)
    } catch (err) {
      console.error('Erro inesperado:', err)
      setError('Erro inesperado ao carregar clientes.')
    } finally {
      setLoading(false)
    }
  }

  // Carregar clientes ao montar o componente
  useEffect(() => {
    fetchClients()
  }, [])

  // Filtrar clientes baseado na busca e status
  const filteredClients = clients.filter(client => {
    const matchesSearch = 
      client.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      client.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      client.phone?.includes(searchTerm) ||
      client.membership_number?.includes(searchTerm)
    
    const matchesStatus = 
      statusFilter === 'all' || 
      (statusFilter === 'active' && client.is_active) ||
      (statusFilter === 'inactive' && !client.is_active)
    
    return matchesSearch && matchesStatus
  })

  // Função para renderizar o status
  const renderStatus = (isActive: boolean) => {
    if (isActive) {
      return (
        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <CheckCircle className="w-3 h-3 mr-1" />
          Ativo
        </span>
      )
    } else {
      return (
        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
          <XCircle className="w-3 h-3 mr-1" />
          Inativo
        </span>
      )
    }
  }

  // Função para renderizar o status do pagamento
  const renderPaymentStatus = (paymentStatus: string) => {
    const statusConfig = {
      'ativo': { color: 'bg-green-100 text-green-800', icon: CheckCircle, label: 'Em dia' },
      'pendente': { color: 'bg-yellow-100 text-yellow-800', icon: AlertCircle, label: 'Pendente' },
      'suspenso': { color: 'bg-red-100 text-red-800', icon: XCircle, label: 'Suspenso' }
    }
    
    const config = statusConfig[paymentStatus as keyof typeof statusConfig] || statusConfig['pendente']
    const IconComponent = config.icon
    
    return (
      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${config.color}`}>
        <IconComponent className="w-3 h-3 mr-1" />
        {config.label}
      </span>
    )
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        <span className="ml-2 text-gray-600">Carregando clientes...</span>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Cabeçalho */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <User className="h-8 w-8 text-blue-600" />
          <h1 className="text-2xl font-bold text-gray-900">Cadastro de Clientes</h1>
        </div>
        <button className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
          <UserPlus className="h-4 w-4 mr-2" />
          Adicionar Cliente
        </button>
      </div>

      {/* Filtros e Busca */}
      <div className="bg-white shadow rounded-lg p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {/* Campo de busca */}
          <div className="md:col-span-2">
            <label htmlFor="search" className="block text-sm font-medium text-gray-700 mb-1">
              Buscar cliente
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Search className="h-4 w-4 text-gray-400" />
              </div>
              <input
                type="text"
                id="search"
                className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Nome, email, telefone ou matrícula..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
          </div>
          
          {/* Filtro de status */}
          <div>
            <label htmlFor="status-filter" className="block text-sm font-medium text-gray-700 mb-1">
              Status
            </label>
            <div className="relative">
              <Filter className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <select
                id="status-filter"
                className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value as 'all' | 'active' | 'inactive')}
              >
                <option value="all">Todos</option>
                <option value="active">Ativos</option>
                <option value="inactive">Inativos</option>
              </select>
            </div>
          </div>
        </div>
        
        {/* Resultados da busca */}
        <div className="mt-4 text-sm text-gray-600">
          Exibindo {filteredClients.length} de {clients.length} clientes
        </div>
      </div>

      {/* Mensagem de erro */}
      {error && (
        <div className="bg-red-50 border border-red-200 rounded-md p-4">
          <div className="flex">
            <AlertCircle className="h-5 w-5 text-red-400" />
            <div className="ml-3">
              <h3 className="text-sm font-medium text-red-800">Erro</h3>
              <div className="mt-2 text-sm text-red-700">
                {error}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Tabela de Clientes */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nome
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Email
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Telefone
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Plano
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Pagamento
                </th>
                <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Ações
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredClients.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-6 py-12 text-center text-gray-500">
                    <User className="mx-auto h-12 w-12 text-gray-400" />
                    <h3 className="mt-2 text-sm font-medium text-gray-900">Nenhum cliente encontrado</h3>
                    <p className="mt-1 text-sm text-gray-500">
                      {searchTerm || statusFilter !== 'all'
                        ? 'Tente ajustar seus filtros de busca.'
                        : 'Comece adicionando um novo cliente.'}
                    </p>
                  </td>
                </tr>
              ) : (
                filteredClients.map((client) => (
                  <tr key={client.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="flex-shrink-0 h-10 w-10">
                          <div className="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                            <User className="h-5 w-5 text-blue-600" />
                          </div>
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">
                            {client.full_name}
                          </div>
                          <div className="text-sm text-gray-500">
                            Matrícula: {client.membership_number || 'N/A'}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center text-sm text-gray-900">
                        <Mail className="h-4 w-4 text-gray-400 mr-2" />
                        {client.email || 'N/A'}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center text-sm text-gray-900">
                        <Phone className="h-4 w-4 text-gray-400 mr-2" />
                        {client.phone || 'N/A'}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {renderStatus(client.is_active || false)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Badge className="h-4 w-4 text-gray-400 mr-2" />
                        <span className="text-sm text-gray-900">{client.plan_type || 'N/A'}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {renderPaymentStatus(client.payment_status || 'pendente')}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <button className="text-blue-600 hover:text-blue-900 inline-flex items-center">
                        <Edit className="h-4 w-4 mr-1" />
                        Editar
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Estatísticas */}
      {clients.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <User className="h-6 w-6 text-gray-400" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Total de Clientes
                    </dt>
                    <dd className="text-lg font-medium text-gray-900">
                      {clients.length}
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
          
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <CheckCircle className="h-6 w-6 text-green-400" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Clientes Ativos
                    </dt>
                    <dd className="text-lg font-medium text-gray-900">
                      {clients.filter(c => c.is_active).length}
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
          
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <XCircle className="h-6 w-6 text-red-400" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Clientes Inativos
                    </dt>
                    <dd className="text-lg font-medium text-gray-900">
                      {clients.filter(c => !c.is_active).length}
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
          
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <AlertCircle className="h-6 w-6 text-yellow-400" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      Pagamentos Pendentes
                    </dt>
                    <dd className="text-lg font-medium text-gray-900">
                      {clients.filter(c => c.payment_status === 'pendente').length}
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ClientsPage