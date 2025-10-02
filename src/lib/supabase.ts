import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://wdcyzxzaxttqxdwuyftc.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkY3l6eHpheHR0cXhkd3V5ZnRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MjUyMTgsImV4cCI6MjA3NDMwMTIxOH0.fifytjVEyqPxfQxcBD6J6RdkCAMQ5b8v80X0UMqGoEc'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Helper para verificar se o usuário está logado
export async function getCurrentUser() {
  const { data: { user }, error } = await supabase.auth.getUser()
  if (error) {
    console.error('Error getting user:', error)
    return null
  }
  return user
}

// Helper para fazer logout
export async function signOut() {
  const { error } = await supabase.auth.signOut()
  if (error) {
    console.error('Error signing out:', error)
    throw error
  }
}

// Helper para fazer login
export async function signIn(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })
  
  if (error) {
    console.error('Error signing in:', error)
    throw error
  }
  
  return data
}

// Helper para registrar usuário
export async function signUp(email: string, password: string, fullName: string) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: fullName
      }
    }
  })
  
  if (error) {
    console.error('Error signing up:', error)
    throw error
  }
  
  return data
}

// Helper para obter perfil do usuário
export async function getUserProfile(userId: string) {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle()
  
  if (error) {
    console.error('Error getting profile:', error)
    return null
  }
  
  return data
}