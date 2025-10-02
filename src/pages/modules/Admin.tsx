import React, { useState, useEffect } from 'react'
import { 
  Building2, Users, Shield, Settings, Activity, FileText,
  Plus, Edit, Trash2, Eye, Search, Filter, Download,
  AlertCircle, CheckCircle, Clock, Users2
} from 'lucide-react'
import { supabase } from '../../lib/supabase'
import { Organization, Unit } from '../../types/database'

export function Admin() {
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [units, setUnits] = useState<Unit[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('organizations')

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      setLoading(true)
      const [orgsRes, unitsRes] = await Promise.all([
        supabase.from('organizations').select('*').order('created_at', { ascending: false }),
        supabase.from('units').select('*').order('created_at', { ascending: false })
      ])
      
      setOrganizations(orgsRes.data || [])
      setUnits(unitsRes.data || [])
    } catch (error) {
      console.error('Erro ao carregar dados:', error)
    } finally {
      setLoading(false)
    }
  }

  const tabs = [
    { id: 'organizations', label: 'Empresa', icon: <Building2 className="w-4 h-4" /> },
    { id: 'units', label: 'Filiais', icon: <Users2 className="w-4 h-4" /> },
    { id: 'users', label: 'Usuários', icon: <Users className="w-4 h-4" /> },
    { id: 'permissions', label: 'Permissões', icon: <Shield className="w-4 h-4" /> },
    { id: 'settings', label: 'Parâmetros', icon: <Settings className="w-4 h-4" /> },
    { id: 'logs', label: 'Auditoria', icon: <FileText className="w-4 h-4" /> }
  ]

  const renderOrganizations = () => (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Gestão da Empresa</h3>
          <p className="text-sm text-gray-600">Configure informações da empresa matriz</p>
        </div>
        <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4 mr-2" />
          Nova Empresa
        </button>
      </div>

      {/* Organizations Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {organizations.map((org) => (
          <div key={org.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-start justify-between mb-4">
              <div className="flex items-center space-x-3">
                <div className="w-12 h-12 bg-gradient-to-r from-blue-600 to-green-600 rounded-lg flex items-center justify-center">
                  <Building2 className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h4 className="text-lg font-semibold text-gray-900">{org.name}</h4>
                  <p className="text-sm text-gray-500">{org.document_number}</p>
                </div>
              </div>
              <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                org.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
              }`}>
                {org.status === 'active' ? 'Ativa' : 'Inativa'}
              </span>
            </div>
            
            <div className="space-y-2 mb-4">
              <div className="flex items-center text-sm text-gray-600">
                <span className="font-medium w-20">Email:</span>
                <span>{org.email || 'Não informado'}</span>
              </div>
              <div className="flex items-center text-sm text-gray-600">
                <span className="font-medium w-20">Telefone:</span>
                <span>{org.phone || 'Não informado'}</span>
              </div>
              <div className="flex items-center text-sm text-gray-600">
                <span className="font-medium w-20">Timezone:</span>
                <span>{org.timezone}</span>
              </div>
            </div>
            
            <div className="flex items-center justify-between pt-4 border-t border-gray-200">
              <div className="flex items-center space-x-2">
                <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors">
                  <Eye className="w-4 h-4" />
                </button>
                <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors">
                  <Edit className="w-4 h-4" />
                </button>
                <button className="p-2 text-gray-400 hover:text-red-600 transition-colors">
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
              <span className="text-xs text-gray-500">
                Criada em {new Date(org.created_at || '').toLocaleDateString('pt-BR')}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  )

  const renderUnits = () => (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Gestão de Filiais</h3>
          <p className="text-sm text-gray-600">Gerencie todas as unidades da rede</p>
        </div>
        <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4 mr-2" />
          Nova Filial
        </button>
      </div>

      {/* Units Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {units.map((unit) => (
          <div key={unit.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-start justify-between mb-4">
              <div>
                <h4 className="text-lg font-semibold text-gray-900">{unit.name}</h4>
                <p className="text-sm text-gray-500">{unit.code}</p>
              </div>
              <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                unit.status === 'active' ? 'bg-green-100 text-green-800' : 
                unit.status === 'maintenance' ? 'bg-yellow-100 text-yellow-800' :
                'bg-red-100 text-red-800'
              }`}>
                {unit.status === 'active' ? 'Ativa' : 
                 unit.status === 'maintenance' ? 'Manutenção' : 'Inativa'}
              </span>
            </div>
            
            <div className="space-y-2 mb-4">
              <div className="flex items-center text-sm text-gray-600">
                <span className="font-medium w-24">Capacidade:</span>
                <span>{unit.capacity || 0} pessoas</span>
              </div>
              <div className="flex items-center text-sm text-gray-600">
                <span className="font-medium w-24">Email:</span>
                <span className="truncate">{unit.email || 'Não informado'}</span>
              </div>
              <div className="text-sm text-gray-600">
                <span className="font-medium">Comodidades:</span>
                <div className="flex flex-wrap gap-1 mt-1">
                  {(unit.amenities || []).slice(0, 3).map((amenity, index) => (
                    <span key={index} className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">
                      {amenity}
                    </span>
                  ))}
                  {(unit.amenities || []).length > 3 && (
                    <span className="px-2 py-1 bg-gray-100 text-gray-600 text-xs rounded-full">
                      +{(unit.amenities || []).length - 3} mais
                    </span>
                  )}
                </div>
              </div>
            </div>
            
            <div className="flex items-center justify-between pt-4 border-t border-gray-200">
              <div className="flex items-center space-x-2">
                <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors">
                  <Eye className="w-4 h-4" />
                </button>
                <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors">
                  <Edit className="w-4 h-4" />
                </button>
                <button className="p-2 text-gray-400 hover:text-red-600 transition-colors">
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
              <span className="text-xs text-gray-500">
                {new Date(unit.created_at || '').toLocaleDateString('pt-BR')}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  )

  const renderPlaceholder = (title: string, description: string) => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <Settings className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600 mb-6">{description}</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Plus className="w-4 h-4 mr-2" />
        Configurar
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
              <div className="h-6 bg-gray-200 rounded mb-4"></div>
              <div className="space-y-2">
                <div className="h-4 bg-gray-200 rounded"></div>
                <div className="h-4 bg-gray-200 rounded w-3/4"></div>
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
          <h1 className="text-3xl font-bold text-gray-900">Módulo Administrativo</h1>
          <p className="text-gray-600 mt-1">Gestão central da empresa e configurações do sistema</p>
        </div>
        <div className="flex items-center space-x-3">
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

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Empresas</p>
              <p className="text-2xl font-bold text-gray-900">{organizations.length}</p>
            </div>
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
              <Building2 className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Filiais</p>
              <p className="text-2xl font-bold text-gray-900">{units.length}</p>
            </div>
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
              <Users2 className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Usuários Ativos</p>
              <p className="text-2xl font-bold text-gray-900">127</p>
            </div>
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
              <Users className="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Sistema</p>
              <p className="text-lg font-semibold text-green-600">Operacional</p>
            </div>
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
              <CheckCircle className="w-6 h-6 text-green-600" />
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
          {activeTab === 'organizations' && renderOrganizations()}
          {activeTab === 'units' && renderUnits()}
          {activeTab === 'users' && renderPlaceholder('Gestão de Usuários', 'Configure usuários e seus acessos ao sistema')}
          {activeTab === 'permissions' && renderPlaceholder('Sistema de Permissões', 'Defina roles e permissões granulares')}
          {activeTab === 'settings' && renderPlaceholder('Parâmetros do Sistema', 'Configure parâmetros operacionais e regras de negócio')}
          {activeTab === 'logs' && renderPlaceholder('Logs de Auditoria', 'Visualize o histórico de atividades do sistema')}
        </div>
      </div>
    </div>
  )
}

export default Admin
