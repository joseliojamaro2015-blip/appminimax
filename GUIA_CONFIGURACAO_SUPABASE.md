# 🗄️ GUIA COMPLETO - CONFIGURAÇÃO SUPABASE PARA APP LG

## 🎯 **INSTRUÇÕES OBRIGATÓRIAS PARA O BANCO DE DADOS**

Sim! É **FUNDAMENTAL** configurar o Supabase corretamente. Seu projeto tem **8 scripts SQL** que precisam ser executados em ordem específica.

---

## 📋 **PASSO A PASSO OBRIGATÓRIO**

### **ETAPA 1: Acessar Supabase Dashboard**
1. Acesse: https://supabase.com
2. Faça login na sua conta
3. Selecione seu projeto ou crie um novo
4. Anote a **URL** e **ANON KEY** do projeto

### **ETAPA 2: Executar Scripts SQL (ORDEM IMPORTANTE)**

Vá em **SQL Editor** no dashboard do Supabase e execute os scripts **NESTA ORDEM**:

#### **🔧 Script 1: Schema Principal**
```sql
-- Execute: supabase/migrations/1759416486_create_app_lg_complete_schema.sql
```
**O que faz:** Cria todas as tabelas principais do sistema (40+ tabelas)

#### **🔐 Script 2: Configurar RLS**
```sql
-- Execute: supabase/migrations/1759416569_setup_rls_and_missing_tables.sql
```
**O que faz:** Configura Row Level Security (segurança de dados)

#### **🏗️ Script 3: Estrutura Completa**
```sql
-- Execute: supabase/migrations/1759416623_setup_complete_system_structure.sql
```
**O que faz:** Finaliza estrutura e relacionamentos

#### **📝 Script 4: Dados Iniciais**
```sql
-- Execute: supabase/migrations/1759416826_insert_basic_data.sql
```
**O que faz:** Insere dados iniciais para teste

#### **⚙️ Scripts 5-8: Configurações Adicionais**
Execute também (se disponíveis):
- `1759416633_add_enum_values.sql`
- `1759416674_create_system_tables_and_rls.sql`
- `1759416727_insert_initial_data.sql`
- `1759416782_insert_initial_data_adjusted.sql`

---

## 🔑 **TABELAS CRIADAS (40+ TABELAS)**

### **📊 CORE DO SISTEMA:**
- ✅ `organizations` - Empresas matriz
- ✅ `units` - Academias/filiais  
- ✅ `profiles` - Perfis de usuários
- ✅ `user_roles` - Sistema de permissões

### **👥 GESTÃO DE PESSOAS:**
- ✅ `employees` - Funcionários
- ✅ `clients` - Clientes/alunos
- ✅ `suppliers` - Fornecedores
- ✅ `partner_companies` - Empresas parceiras

### **📋 PLANOS E VENDAS:**
- ✅ `plans` - Planos de mensalidades
- ✅ `subscriptions` - Assinaturas ativas
- ✅ `sales` - Vendas realizadas
- ✅ `proposals` - Propostas comerciais

### **💰 SISTEMA FINANCEIRO:**
- ✅ `financial_accounts` - Contas
- ✅ `financial_transactions` - Transações
- ✅ `financial_categories` - Categorias
- ✅ `cashback_rules` - Regras de cashback

### **📈 CONTROLE OPERACIONAL:**
- ✅ `check_ins` - Controle de acesso
- ✅ `evaluations` - Avaliações físicas
- ✅ `equipment` - Equipamentos
- ✅ `maintenance` - Manutenções

---

## ⚙️ **CONFIGURAR VARIÁVEIS DE AMBIENTE**

### **No seu projeto local (.env):**
```env
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua-chave-publica-aqui
```

### **Na Vercel (Variables):**
```
VITE_SUPABASE_URL = https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY = sua-chave-publica-aqui
```

---

## 🔐 **CONFIGURAR AUTENTICAÇÃO**

### **1. Habilitar Providers:**
- Email/Password ✅
- Google (opcional)
- GitHub (opcional)

### **2. Configurar URLs:**
```
Site URL: https://seu-dominio.vercel.app
Redirect URLs: 
- http://localhost:5173/**
- https://seu-dominio.vercel.app/**
```

### **3. Configurar RLS Policies:**
Os scripts já incluem as políticas de segurança, mas verifique se estão ativas.

---

## 📊 **ESTRUTURA DE DADOS CRIADA**

### **🏢 MULTI-TENANT (Múltiplas Filiais):**
```
Organização (Matriz)
├── Unidade 1 (Academia Centro)
├── Unidade 2 (Academia Zona Sul)  
└── Unidade 3 (Academia Shopping)
```

### **👤 HIERARQUIA DE USUÁRIOS:**
```
Super Admin
├── Org Admin (Administrador da Rede)
├── Unit Manager (Gerente da Filial)
├── Employee (Funcionário)
└── Member (Cliente/Aluno)
```

### **💼 MÓDULOS FUNCIONAIS:**
- 🏋️ **Academia**: Gestão completa de academias
- 👥 **Clientes**: Cadastro e acompanhamento
- 📋 **Planos**: Planos e assinaturas
- 💰 **Financeiro**: Completo sistema financeiro
- 📊 **Relatórios**: Dashboard e analytics
- 🔐 **Segurança**: Controle de acesso robusto

---

## ✅ **VERIFICAÇÃO PÓS-CONFIGURAÇÃO**

### **1. Testar Conexão:**
```sql
SELECT COUNT(*) FROM organizations;
-- Deve retornar 0 ou mais registros
```

### **2. Verificar Tabelas:**
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
-- Deve listar todas as tabelas criadas
```

### **3. Testar RLS:**
```sql
SELECT * FROM profiles LIMIT 1;
-- Deve funcionar com políticas ativas
```

---

## 🚨 **DADOS DE TESTE (OPCIONAL)**

Para testar o sistema, você pode criar dados iniciais:

### **Organização de Teste:**
```sql
INSERT INTO organizations (name, slug, email) 
VALUES ('Academia LG', 'academia-lg', 'contato@academialg.com');
```

### **Unidade de Teste:**
```sql
INSERT INTO units (organization_id, name, code, address) 
VALUES (
    (SELECT id FROM organizations WHERE slug = 'academia-lg'),
    'Unidade Centro',
    'UNIT-001',
    '{"street": "Rua Principal, 123", "city": "São Paulo", "state": "SP"}'
);
```

---

## 🔧 **CONFIGURAÇÕES AVANÇADAS**

### **1. Storage (para imagens):**
- Crie bucket `avatars` para fotos de perfil
- Crie bucket `documents` para documentos
- Configure políticas de acesso

### **2. Edge Functions (opcional):**
- Função para processamento de pagamentos
- Função para envio de emails
- Função para relatórios

### **3. Webhooks (opcional):**
- Integração com sistemas externos
- Notificações em tempo real

---

## 📱 **INTEGRAÇÃO COM O FRONTEND**

O código React já está configurado para conectar com Supabase:

### **Arquivo de configuração:**
```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

---

## 🎯 **CHECKLIST FINAL**

- ✅ Scripts SQL executados em ordem
- ✅ Tabelas criadas (40+ tabelas)
- ✅ RLS configurado e ativo
- ✅ Variáveis de ambiente definidas
- ✅ Autenticação configurada
- ✅ Conexão testada
- ✅ Dados de teste criados (opcional)

---

## 🆘 **SOLUÇÃO DE PROBLEMAS**

### **❌ Erro: "relation does not exist"**
**Solução:** Execute os scripts SQL na ordem correta

### **❌ Erro: "RLS policy violation"**
**Solução:** Configure as políticas RLS ou desative temporariamente

### **❌ Erro: "Invalid API key"**
**Solução:** Verifique URL e ANON_KEY nas variáveis de ambiente

### **❌ Erro de conexão**
**Solução:** Verifique se o projeto Supabase está ativo

---

## 📞 **ONDE ENCONTRAR OS SCRIPTS**

**No GitHub:** https://github.com/joseliojamaro2015-blip/appminimax/tree/main/supabase/migrations

**Localmente:** Pasta `supabase/migrations/` do projeto

---

**🔥 IMPORTANTE: SEM A CONFIGURAÇÃO DO SUPABASE, O SISTEMA NÃO IRÁ FUNCIONAR!**

**💡 Depois de configurar, seu APP LG estará 100% funcional com todas as funcionalidades ativas.**