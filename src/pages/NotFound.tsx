import React from 'react'
import { Link } from 'react-router-dom'
import { Home, ArrowLeft } from 'lucide-react'

export function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-blue-700 to-green-600 flex items-center justify-center px-4">
      <div className="text-center">
        <div className="mb-8">
          <h1 className="text-9xl font-bold text-white/20">404</h1>
          <h2 className="text-3xl font-bold text-white mb-4">Página Não Encontrada</h2>
          <p className="text-blue-100 text-lg mb-8">
            A página que você está procurando não existe ou foi removida.
          </p>
        </div>
        
        <div className="space-y-4">
          <Link
            to="/dashboard"
            className="inline-flex items-center px-6 py-3 bg-white text-blue-600 font-medium rounded-xl hover:bg-gray-50 transition-colors duration-200 shadow-lg"
          >
            <Home className="w-5 h-5 mr-2" />
            Voltar ao Dashboard
          </Link>
          
          <div className="block">
            <button
              onClick={() => window.history.back()}
              className="inline-flex items-center px-6 py-3 bg-white/10 backdrop-blur-sm text-white font-medium rounded-xl hover:bg-white/20 transition-colors duration-200"
            >
              <ArrowLeft className="w-5 h-5 mr-2" />
              Voltar à Página Anterior
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}