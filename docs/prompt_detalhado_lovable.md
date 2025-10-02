# 🚀 PROMPT DETALHADO PARA LOVABLE - SISTEMA APP LG
*Sistema Empresarial Completo para Gestão de Academias*

---

## 📝 PROMPT PRINCIPAL

**Desenvolva um sistema empresarial completo para gestão de academias chamado "APP LG" utilizando as seguintes especificações:**

### 🎯 **OBJETIVO PRINCIPAL**
Criar uma plataforma web moderna e responsiva para gestão completa de academias e clubes fitness, integrando todos os aspectos operacionais em uma interface unificada e profissional.

### 🛠️ **STACK TECNOLÓGICO**
- **Frontend:** React 18 + TypeScript + Tailwind CSS
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **UI Library:** shadcn/ui (componentes modernos)
- **Ícones:** Lucide React
- **Tipografia:** Inter font
- **Estado:** Zustand para gerenciamento de estado
- **Formulários:** React Hook Form + Zod para validação

### 🎨 **DESIGN SYSTEM**

**Paleta de Cores:**
```css
/* Cores Primárias */
--blue-primary: #2563eb;    /* Azul corporativo */
--green-fitness: #10b981;   /* Verde saúde */
--orange-energy: #f59e0b;   /* Laranja motivação */

/* Cores Neutras */
--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-200: #e5e7eb;
--gray-600: #6b7280;
--gray-900: #111827;
```

**Tipografia:**
- Font family: Inter
- Heading scales: text-4xl, text-3xl, text-2xl, text-xl
- Body: text-base, text-sm
- Weight: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)

**Espaçamento:**
- Sistema baseado em múltiplos de 4px: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64px
- Gaps: space-2, space-4, space-6, space-8

**Bordas e Sombras:**
- Border radius: rounded-lg (8px), rounded-xl (12px)
- Sombras: shadow-sm, shadow-md, shadow-lg
- Borders: border-gray-200

### 🏗️ **ESTRUTURA DE LAYOUT**

**Layout Principal:**
```
┌─────────────────────────────────────────┐
│ Header (breadcrumbs, search, profile)   │
├──────────┬──────────────────────────────┤
│ Sidebar  │ Main Content Area           │
│ Nav      │                             │
│ (240px)  │ Dynamic content based       │
│          │ on selected module          │
│          │                             │
│          │                             │
└──────────┴──────────────────────────────┘
```

**Componentes do Layout:**

1. **Sidebar Navigation:**
   - Logo APP LG no topo
   - 8 módulos principais com ícones
   - Indicador de módulo ativo
   - Expansível/colapsável no mobile
   - Sticky position

2. **Header:**
   - Breadcrumbs navigation
   - Barra de busca global
   - Notificações (bell icon)
   - Avatar do usuário com dropdown
   - Botão toggle sidebar (mobile)

3. **Main Content:**
   - Container responsivo
   - Padding consistente
   - Grid system flexível

### 📊 **MÓDULOS DO SISTEMA**

Implemente os seguintes 8 módulos principais:

#### 🏢 **1. MÓDULO ADMINISTRATIVO**
**Rota:** `/admin`
**Ícone:** Settings
**Subpáginas:**
- `/admin/empresa` - Dados da empresa matriz
- `/admin/filiais` - Gestão de filiais
- `/admin/usuarios` - Gestão de usuários
- `/admin/permissoes` - Sistema RBAC
- `/admin/parametros` - Configurações do sistema
- `/admin/auditoria` - Logs e auditoria

#### 📝 **2. MÓDULO CADASTROS**
**Rota:** `/cadastros`
**Ícone:** UserPlus
**Subpáginas:**
- `/cadastros/pessoas-fisicas` - CPF, dados pessoais
- `/cadastros/pessoas-juridicas` - CNPJ, dados empresariais
- `/cadastros/clientes` - Base de clientes
- `/cadastros/fornecedores` - Parceiros comerciais
- `/cadastros/vendedores` - Equipe de vendas
- `/cadastros/funcionarios` - Recursos humanos
- `/cadastros/prestadores` - Profissionais terceirizados

#### 🏋️ **3. MÓDULO ACADEMIAS**
**Rota:** `/academias`
**Ícone:** Dumbbell
**Subpáginas:**
- `/academias/parceiras` - Rede de academias
- `/academias/matriculas` - Processo de matrícula
- `/academias/checkins` - Sistema de check-in
- `/academias/avaliacoes` - Avaliações físicas/nutricionais

#### 👥 **4. MÓDULO MEMBROS**
**Rota:** `/membros`
**Ícone:** Users
**Subpáginas:**
- `/membros/listagem` - Lista de membros
- `/membros/planos` - Assinaturas e planos
- `/membros/pagamentos` - Formas de pagamento
- `/membros/compras` - Histórico de compras
- `/membros/frequencia` - Histórico de check-ins

#### 💼 **5. MÓDULO VENDAS**
**Rota:** `/vendas`
**Ícone:** TrendingUp
**Subpáginas:**
- `/vendas/planos` - Planos individuais/corporativos
- `/vendas/servicos` - Serviços por demanda
- `/vendas/propostas` - Orçamentos e propostas
- `/vendas/pipeline` - Pipeline de vendas

#### 💰 **6. MÓDULO FINANCEIRO**
**Rota:** `/financeiro`
**Ícone:** DollarSign
**Subpáginas:**
- `/financeiro/contas` - Contas financeiras
- `/financeiro/categorias` - Receitas/despesas
- `/financeiro/transacoes` - Movimentações
- `/financeiro/conciliacao` - Conciliação bancária
- `/financeiro/relatorios` - DRE, fluxo de caixa

#### 🎁 **7. MÓDULO CASHBACK**
**Rota:** `/cashback`
**Ícone:** Gift
**Subpáginas:**
- `/cashback/regras` - Configuração de regras
- `/cashback/creditos` - Validação de créditos
- `/cashback/resgates` - Sistema de resgates
- `/cashback/fidelidade` - Programa de fidelidade

#### 🏢 **8. MÓDULO PERFIL FILIAL**
**Rota:** `/filial`
**Ícone:** Building
**Subpáginas:**
- `/filial/dados` - Dados da filial
- `/filial/contatos` - Informações de contato
- `/filial/politicas` - Políticas locais
- `/filial/configuracoes` - Configurações específicas

### 🏠 **DASHBOARD PRINCIPAL**

**Rota:** `/dashboard`
**Componentes:**

1. **Cards de Métricas (4 cards em grid):**
   ```
   ┌─────────────┬─────────────┬─────────────┬─────────────┐
   │ Membros     │ Receita     │ Check-ins   │ Novos       │
   │ Ativos      │ Mensal      │ Hoje        │ Membros     │
   │ 1,247       │ R$ 89.5K    │ 342         │ 23          │
   │ +5.2%       │ +12.1%      │ +8.7%       │ +15.3%      │
   └─────────────┴─────────────┴─────────────┴─────────────┘
   ```

2. **Gráfico de Check-ins (Linha - últimos 7 dias)**
3. **Top 5 Membros Mais Ativos (Lista)**
4. **Receita por Filial (Gráfico de barras)**
5. **Alertas e Notificações**
6. **Tarefas Pendentes**

### 🔐 **SISTEMA DE AUTENTICAÇÃO**

**Páginas de Auth:**
- `/login` - Tela de login
- `/signup` - Registro (apenas admins)
- `/forgot-password` - Recuperação de senha

**Perfis de Usuário (RBAC):**
1. **Super Admin** - Acesso total
2. **Admin Filial** - Gestão da filial
3. **Gerente** - Acesso departamental
4. **Funcionário** - Acesso operacional
5. **Membro** - Acesso limitado (perfil próprio)

### 🧩 **COMPONENTES ESSENCIAIS**

**1. Cards de Métricas:**
```tsx
interface MetricCardProps {
  title: string;
  value: string | number;
  change: string;
  icon: LucideIcon;
  trend: 'up' | 'down' | 'neutral';
}
```

**2. Tabelas de Dados:**
- Cabeçalhos fixos
- Paginação
- Busca/filtros
- Ações inline (edit, delete, view)
- Zebra striping
- Loading states

**3. Formulários:**
- Validação em tempo real
- Labels flutuantes
- Estados de erro/sucesso
- Campos obrigatórios marcados
- Auto-complete onde aplicável

**4. Modais:**
- Overlay escuro
- Animações suaves
- Tamanhos variados (sm, md, lg, xl)
- Fechar por ESC ou clique fora

**5. Navigation Breadcrumbs:**
```
Home > Módulo > Subpágina > Ação
```

### 📱 **RESPONSIVIDADE**

**Breakpoints:**
- Mobile: < 768px
- Tablet: 768px - 1024px  
- Desktop: > 1024px

**Comportamentos:**
- **Mobile:** Sidebar como drawer, cards empilhados
- **Tablet:** Sidebar colapsável, grid 2 colunas
- **Desktop:** Layout completo, múltiplas colunas

### 🎯 **FUNCIONALIDADES ESPECÍFICAS**

**1. Check-in System:**
- Interface para QR Code scanning
- Check-in manual por busca
- Feedback visual de sucesso
- Histórico de check-ins

**2. Sistema de Busca Global:**
- Busca unificada no header
- Resultados categorizados
- Atalhos de teclado (Ctrl+K)

**3. Gestão de Estados:**
- Loading skeletons
- Estados vazios (empty states)
- Estados de erro
- Confirmações de ação

**4. Notificações:**
- Toast notifications
- Sistema de badges
- Notificações em tempo real

### 🗃️ **ESTRUTURA DE DADOS**

**Principais Entidades:**
```typescript
// Usuário
interface User {
  id: string;
  email: string;
  name: string;
  role: 'super_admin' | 'admin_filial' | 'gerente' | 'funcionario' | 'membro';
  filial_id?: string;
  avatar_url?: string;
}

// Membro
interface Member {
  id: string;
  name: string;
  email: string;
  phone: string;
  plan_id: string;
  status: 'active' | 'inactive' | 'suspended';
  join_date: string;
  last_checkin?: string;
}

// Plano
interface Plan {
  id: string;
  name: string;
  price: number;
  duration_months: number;
  features: string[];
  active: boolean;
}

// Check-in
interface Checkin {
  id: string;
  member_id: string;
  filial_id: string;
  timestamp: string;
  type: 'qr_code' | 'manual';
}
```

### 🎨 **EXEMPLO DE IMPLEMENTAÇÃO - DASHBOARD**

```tsx
export default function DashboardPage() {
  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <div className="flex space-x-4">
          <Button variant="outline">
            <Download className="w-4 h-4 mr-2" />
            Exportar
          </Button>
          <Button>
            <Plus className="w-4 h-4 mr-2" />
            Nova Matrícula
          </Button>
        </div>
      </div>

      {/* Metrics Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Membros Ativos"
          value="1,247"
          change="+5.2%"
          icon={Users}
          trend="up"
        />
        <MetricCard
          title="Receita Mensal"
          value="R$ 89.5K"
          change="+12.1%"
          icon={DollarSign}
          trend="up"
        />
        <MetricCard
          title="Check-ins Hoje"
          value="342"
          change="+8.7%"
          icon={Target}
          trend="up"
        />
        <MetricCard
          title="Novos Membros"
          value="23"
          change="+15.3%"
          icon={UserPlus}
          trend="up"
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card className="p-6">
          <h3 className="text-lg font-semibold mb-4">Check-ins por Dia</h3>
          {/* Chart component */}
        </Card>
        
        <Card className="p-6">
          <h3 className="text-lg font-semibold mb-4">Receita por Filial</h3>
          {/* Chart component */}
        </Card>
      </div>

      {/* Recent Activity */}
      <Card className="p-6">
        <h3 className="text-lg font-semibold mb-4">Atividade Recente</h3>
        {/* Activity list */}
      </Card>
    </div>
  );
}
```

### ✅ **CHECKLIST DE IMPLEMENTAÇÃO**

**Estrutura Base:**
- [ ] Configuração inicial do projeto
- [ ] Sistema de roteamento
- [ ] Layout principal com sidebar
- [ ] Sistema de autenticação
- [ ] Configuração do Supabase

**Componentes UI:**
- [ ] Design system base
- [ ] Componentes de formulário
- [ ] Tabelas de dados
- [ ] Cards de métricas
- [ ] Modais e drawers
- [ ] Sistema de notificações

**Módulos Principais:**
- [ ] Dashboard executivo
- [ ] Módulo Administrativo
- [ ] Módulo Cadastros
- [ ] Módulo Academias
- [ ] Módulo Membros
- [ ] Módulo Vendas
- [ ] Módulo Financeiro
- [ ] Módulo Cashback
- [ ] Módulo Perfil Filial

**Funcionalidades Avançadas:**
- [ ] Sistema de busca global
- [ ] Filtros e ordenação
- [ ] Export de dados
- [ ] Sistema RBAC
- [ ] Responsividade completa
- [ ] PWA capabilities

### 🚀 **INSTRUÇÕES FINAIS**

1. **Comece com o Dashboard** e navegação base
2. **Implemente a autenticação** RBAC
3. **Desenvolva os módulos** progressivamente
4. **Foque na experiência do usuário** - interface limpa e intuitiva
5. **Garanta responsividade** total
6. **Use dados mock** realistas para demonstração
7. **Implemente loading states** e feedback visual
8. **Adicione microinterações** para melhor UX
9. **Teste em diferentes dispositivos**
10. **Documente componentes** importantes

### 🎯 **RESULTADO ESPERADO**

Uma aplicação moderna, profissional e completa para gestão de academias que seja:
- **Intuitiva** para diferentes tipos de usuários
- **Responsiva** em todos os dispositivos
- **Escalável** para crescimento futuro
- **Visualmente atrativa** com design consistente
- **Funcional** com todas as operações necessárias
- **Performática** com carregamento rápido

---

*Desenvolva um sistema que represente o estado da arte em aplicações para gestão de academias, combinando funcionalidade robusta com design moderno e experiência do usuário excepcional.*