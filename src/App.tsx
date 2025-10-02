import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import { Layout } from './components/Layout'
import { ProtectedRoute } from './components/ProtectedRoute'
import Login from './components/Login'
import Dashboard from './components/Dashboard'

// Importar páginas dos módulos
import AdminPage from './pages/modules/Admin'
import FinancialPage from './pages/modules/Financial'
import GymsPage from './pages/modules/Gyms'
import MembersPage from './pages/modules/Members'
import ClientsPage from './pages/modules/cadastros/Clientes'

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          {/* Rota de login */}
          <Route path="/login" element={<Login />} />
          
          {/* Rotas protegidas */}
          <Route
            path="/*"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard" element={<Dashboard />} />
            <Route path="admin" element={<AdminPage />} />
            <Route path="cadastros">
              <Route index element={<Navigate to="/cadastros/clientes" replace />} />
              <Route path="clientes" element={<ClientsPage />} />
            </Route>
            <Route path="academias" element={<GymsPage />} />
            <Route path="membros" element={<MembersPage />} />
            <Route path="vendas" element={<div className="p-6"><h1 className="text-2xl font-bold">Módulo de Vendas</h1><p>Em desenvolvimento...</p></div>} />
            <Route path="financeiro" element={<FinancialPage />} />
            <Route path="cashback" element={<div className="p-6"><h1 className="text-2xl font-bold">Módulo de Cashback</h1><p>Em desenvolvimento...</p></div>} />
            <Route path="filial" element={<div className="p-6"><h1 className="text-2xl font-bold">Perfil da Filial</h1><p>Em desenvolvimento...</p></div>} />
          </Route>
          
          {/* Rota padrão - redireciona para dashboard */}
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </Router>
    </AuthProvider>
  )
}

export default App