import React, { useState, useEffect } from 'react'
import { 
  Dumbbell, MapPin, Users, Clock, Star, Wifi,
  Plus, Search, Filter, Eye, Edit, Phone, Mail,
  Calendar, CheckCircle, AlertTriangle, Navigation,
  Camera, Heart, Award
} from 'lucide-react'
import { supabase } from '../../lib/supabase'

export function Gyms() {
  const [units, setUnits] = useState<any[]>([])
  const [checkins, setCheckins] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('network')

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      setLoading(true)
      const [unitsRes, checkinsRes] = await Promise.all([
        supabase.from('units').select('*').order('created_at', { ascending: false }),
        supabase.from('check_ins').select('*').order('check_in_time', { ascending: false }).limit(10)
      ])
      
      setUnits(unitsRes.data || [])
      setCheckins(checkinsRes.data || [])
    } catch (error) {
      console.error('Erro ao carregar dados:', error)
    } finally {
      setLoading(false)
    }
  }

  const tabs = [
    { id: 'network', label: 'Rede de Academias', icon: <Dumbbell className="w-4 h-4" /> },
    { id: 'memberships', label: 'Matrículas', icon: <Users className="w-4 h-4" /> },
    { id: 'checkins', label: 'Check-ins', icon: <CheckCircle className="w-4 h-4" /> },
    { id: 'assessments', label: 'Avaliações', icon: <Heart className="w-4 h-4" /> }
  ]

  const renderGymCard = (unit: any) => (
    <div key={unit.id} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
      {/* Header Image */}
      <div className="h-48 bg-gradient-to-r from-blue-600 to-green-600 relative">
        <div className="absolute inset-0 bg-black bg-opacity-20 flex items-center justify-center">
          <Dumbbell className="w-16 h-16 text-white" />
        </div>
        <div className="absolute top-4 right-4">
          <span className={`px-3 py-1 rounded-full text-xs font-medium ${
            unit.status === 'active' ? 'bg-green-500 text-white' :
            unit.status === 'maintenance' ? 'bg-yellow-500 text-white' :
            'bg-red-500 text-white'
          }`}>
            {unit.status === 'active' ? 'Operacional' :
             unit.status === 'maintenance' ? 'Manutenção' : 'Fechada'}
          </span>
        </div>
        <div className="absolute bottom-4 left-4 text-white">
          <h3 className="text-xl font-bold">{unit.name}</h3>
          <p className="text-sm opacity-90">{unit.code}</p>
        </div>
      </div>
      
      {/* Content */}
      <div className="p-6">
        {/* Basic Info */}
        <div className="space-y-3 mb-4">
          <div className="flex items-center text-sm text-gray-600">
            <MapPin className="w-4 h-4 mr-2 flex-shrink-0" />
            <span>{unit.address?.street || 'Endereço não informado'}</span>
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <Users className="w-4 h-4 mr-2 flex-shrink-0" />
            <span>Capacidade: {unit.capacity || 0} pessoas</span>
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <Clock className="w-4 h-4 mr-2 flex-shrink-0" />
            <span>Abre às 06:00 - Fecha às 22:00</span>
          </div>
        </div>
        
        {/* Amenities */}
        <div className="mb-4">
          <p className="text-sm font-medium text-gray-700 mb-2">Comodidades:</p>
          <div className="flex flex-wrap gap-2">
            {(unit.amenities || []).slice(0, 4).map((amenity: string, index: number) => (
              <span key={index} className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">
                {amenity}
              </span>
            ))}
            {(unit.amenities || []).length > 4 && (
              <span className="px-2 py-1 bg-gray-100 text-gray-600 text-xs rounded-full">
                +{(unit.amenities || []).length - 4} mais
              </span>
            )}
          </div>
        </div>
        
        {/* Stats */}
        <div className="grid grid-cols-3 gap-4 mb-4 p-3 bg-gray-50 rounded-lg">
          <div className="text-center">
            <div className="text-lg font-bold text-blue-600">4.8</div>
            <div className="text-xs text-gray-600 flex items-center justify-center">
              <Star className="w-3 h-3 mr-1 fill-current text-yellow-400" />
              Avaliação
            </div>
          </div>
          <div className="text-center">
            <div className="text-lg font-bold text-green-600">89</div>
            <div className="text-xs text-gray-600">Check-ins hoje</div>
          </div>
          <div className="text-center">
            <div className="text-lg font-bold text-purple-600">68%</div>
            <div className="text-xs text-gray-600">Ocupação</div>
          </div>
        </div>
        
        {/* Actions */}
        <div className="flex items-center justify-between pt-4 border-t border-gray-200">
          <div className="flex items-center space-x-2">
            <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50">
              <Eye className="w-4 h-4" />
            </button>
            <button className="p-2 text-gray-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50">
              <Edit className="w-4 h-4" />
            </button>
            <button className="p-2 text-gray-400 hover:text-green-600 transition-colors rounded-lg hover:bg-green-50">
              <Navigation className="w-4 h-4" />
            </button>
          </div>
          <button className="text-xs text-blue-600 hover:text-blue-700 font-medium">
            Ver Detalhes
          </button>
        </div>
      </div>
    </div>
  )

  const renderMemberships = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Gestão de Matrículas</h3>
          <p className="text-sm text-gray-600">Processo digital de matrícula e documentação</p>
        </div>
        <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4 mr-2" />
          Nova Matrícula
        </button>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Matrículas Hoje</h4>
            <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
              <Users className="w-5 h-5 text-green-600" />
            </div>
          </div>
          <div className="text-2xl font-bold text-gray-900 mb-1">12</div>
          <div className="text-sm text-green-600">+3 desde ontem</div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Pendentes</h4>
            <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
              <Clock className="w-5 h-5 text-yellow-600" />
            </div>
          </div>
          <div className="text-2xl font-bold text-gray-900 mb-1">5</div>
          <div className="text-sm text-yellow-600">Aguardando docs</div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Taxa Conversão</h4>
            <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
              <Award className="w-5 h-5 text-blue-600" />
            </div>
          </div>
          <div className="text-2xl font-bold text-gray-900 mb-1">78%</div>
          <div className="text-sm text-blue-600">Leads → Membros</div>
        </div>
      </div>
    </div>
  )

  const renderCheckins = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Sistema de Check-in</h3>
          <p className="text-sm text-gray-600">Controle de acesso e frequência dos membros</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
            <Camera className="w-4 h-4 mr-2" />
            QR Code Scanner
          </button>
          <button className="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
            <CheckCircle className="w-4 h-4 mr-2" />
            Check-in Manual
          </button>
        </div>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Check-ins Hoje</h4>
            <CheckCircle className="w-8 h-8 text-green-600" />
          </div>
          <div className="text-3xl font-bold text-gray-900 mb-2">234</div>
          <div className="text-sm text-green-600">+18% vs ontem</div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Pico de Movimento</h4>
            <Clock className="w-8 h-8 text-blue-600" />
          </div>
          <div className="text-3xl font-bold text-gray-900 mb-2">18h</div>
          <div className="text-sm text-blue-600">67 pessoas ativas</div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Média Permanência</h4>
            <Users className="w-8 h-8 text-purple-600" />
          </div>
          <div className="text-3xl font-bold text-gray-900 mb-2">1h32m</div>
          <div className="text-sm text-purple-600">Por sessão</div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="font-semibold text-gray-900">Capacidade Atual</h4>
            <AlertTriangle className="w-8 h-8 text-orange-600" />
          </div>
          <div className="text-3xl font-bold text-gray-900 mb-2">68%</div>
          <div className="text-sm text-orange-600">Moderado</div>
        </div>
      </div>
      
      {/* Recent Check-ins */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <h4 className="font-semibold text-gray-900 mb-4">Check-ins Recentes</h4>
        <div className="space-y-3">
          {checkins.slice(0, 5).map((checkin, index) => (
            <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                  <Users className="w-4 h-4 text-white" />
                </div>
                <div>
                  <p className="font-medium text-gray-900">Membro #{checkin.client_id?.slice(0, 8)}</p>
                  <p className="text-sm text-gray-500">
                    Check-in: {new Date(checkin.check_in_time).toLocaleTimeString('pt-BR', {
                      hour: '2-digit',
                      minute: '2-digit'
                    })}
                  </p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-sm font-medium text-green-600">Ativo</p>
                <p className="text-xs text-gray-500">45 min</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )

  const renderAssessments = () => (
    <div className="text-center py-12">
      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <Heart className="w-8 h-8 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">Avaliações Físicas e Nutricionais</h3>
      <p className="text-gray-600 mb-6">Agende e gerencie avaliações para acompanhar o progresso dos membros</p>
      <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
        <Calendar className="w-4 h-4 mr-2" />
        Nova Avaliação
      </button>
    </div>
  )

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="h-8 bg-gray-200 rounded animate-pulse"></div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[...Array(6)].map((_, i) => (
            <div key={i} className="bg-white rounded-xl shadow-sm border border-gray-200 animate-pulse">
              <div className="h-48 bg-gray-200"></div>
              <div className="p-6 space-y-3">
                <div className="h-6 bg-gray-200 rounded"></div>
                <div className="h-4 bg-gray-200 rounded w-3/4"></div>
                <div className="h-4 bg-gray-200 rounded w-1/2"></div>
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
          <h1 className="text-3xl font-bold text-gray-900">Módulo Academias</h1>
          <p className="text-gray-600 mt-1">Gestão da rede, matrículas e check-ins</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors">
            <Search className="w-4 h-4 mr-2" />
            Buscar
          </button>
          <button className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
            <Plus className="w-4 h-4 mr-2" />
            Nova Academia
          </button>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Academias Ativas</p>
              <p className="text-2xl font-bold text-gray-900">{units.filter(u => u.status === 'active').length}</p>
            </div>
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
              <Dumbbell className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Check-ins Hoje</p>
              <p className="text-2xl font-bold text-gray-900">{checkins.length}</p>
            </div>
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
              <CheckCircle className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Matrículas Mês</p>
              <p className="text-2xl font-bold text-gray-900">47</p>
            </div>
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
              <Users className="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </div>
        
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Avaliações Agendadas</p>
              <p className="text-2xl font-bold text-gray-900">23</p>
            </div>
            <div className="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
              <Heart className="w-6 h-6 text-orange-600" />
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
          {activeTab === 'network' && (
            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {units.map(renderGymCard)}
              </div>
            </div>
          )}
          {activeTab === 'memberships' && renderMemberships()}
          {activeTab === 'checkins' && renderCheckins()}
          {activeTab === 'assessments' && renderAssessments()}
        </div>
      </div>
    </div>
  )
}

export default Gyms
