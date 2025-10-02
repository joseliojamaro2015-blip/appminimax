# 📋 MANUAL DETALHADO - SISTEMA EMPRESARIAL APP LG EXPANDIDO
*Sistema de Gestão Completa para Academias e Clubes Fitness*

---

## 📊 VISÃO GERAL DO SISTEMA EXPANDIDO

O APP LG evoluiu de um sistema básico de check-in para uma **plataforma completa de gestão empresarial** para academias, integrando 9 departamentos organizacionais com mais de 80 funcionalidades específicas.

### 🏗️ **Arquitetura Técnica**
- **Frontend:** Next.js 14 + React 18 + TypeScript + Tailwind CSS
- **Backend:** Supabase (PostgreSQL + Edge Functions + Auth + Storage)
- **Deploy:** Vercel (Auto-deploy com GitHub integration)
- **Pagamentos:** MercadoPago + Stripe (multi-gateway)
- **Segurança:** JWT + Row Level Security + RBAC

---

## 🔥 DEPARTAMENTO 1: MIX NEGÓCIO
*Gestão de Produtos, Vendas e Performance*

### 📦 **1.1 PRODUTOS EM VENDAS**
**Funcionalidades:**
- ✅ Catálogo completo de produtos/serviços
- ✅ Gestão de preços e promoções
- ✅ Controle de estoque (suplementos, equipamentos)
- ✅ Produtos digitais (planos, consultorias online)
- ✅ Pacotes e combos personalizados
- ✅ Sistema de desconto e cupons

**Telas:**
- `/produtos/catalogo` - Listagem de produtos
- `/produtos/novo` - Cadastro de produtos
- `/produtos/promocoes` - Gestão de promoções
- `/produtos/estoque` - Controle de inventário

### 📊 **1.2 DASHBOARD MEMBROS**
**Funcionalidades:**
- ✅ Métricas de engajamento dos membros
- ✅ Análise de frequência de uso
- ✅ Retenção e churn rate
- ✅ Lifetime value (LTV) dos clientes
- ✅ Segmentação de membros por perfil
- ✅ Alertas de membros inativos

**Telas:**
- `/dashboard/membros` - Visão geral
- `/dashboard/retencao` - Análise de retenção
- `/dashboard/segmentacao` - Segmentos de clientes

### 🏢 **1.3 CONNAISSANT ACADEMIAS**
**Funcionalidades:**
- ✅ Rede de academias parceiras
- ✅ Sistema de reciprocidade entre unidades
- ✅ Check-in em academias parceiras
- ✅ Mapeamento geográfico de unidades
- ✅ Avaliações e reviews de unidades

**Telas:**
- `/academias/rede` - Mapa da rede
- `/academias/reciprocidade` - Configurações de acesso

### 🛒 **1.4 CARRINHO PARCERIA**
**Funcionalidades:**
- ✅ Compras em academias parceiras
- ✅ Sistema de pontos e cashback
- ✅ Desconto progressivo por volume
- ✅ Programa de fidelidade integrado

### 📈 **1.5 CURVA ABC**
**Funcionalidades:**
- ✅ Análise ABC de produtos/serviços
- ✅ Identificação de produtos premium
- ✅ Otimização de mix de produtos
- ✅ Relatórios de performance

### 🎯 **1.6 METAS**
**Funcionalidades:**
- ✅ Definição de metas por período
- ✅ Acompanhamento de performance
- ✅ Alertas de meta próxima ao vencimento
- ✅ Gamificação para equipe de vendas

---

## 👥 DEPARTAMENTO 2: CADASTRO
*Gestão de Recursos Humanos e Categorização*

### 👨‍💼 **2.1 FUNCIONÁRIOS**
**Funcionalidades:**
- ✅ Cadastro completo de colaboradores
- ✅ Controle de ponto e frequência
- ✅ Gestão de cargos e hierarquias
- ✅ Sistema de permissões por função
- ✅ Documentos e certificações
- ✅ Avaliação de performance

**Telas:**
- `/funcionarios/listagem` - Lista de funcionários
- `/funcionarios/novo` - Cadastro
- `/funcionarios/ponto` - Controle de ponto
- `/funcionarios/avaliacoes` - Avaliações

### 🏢 **2.2 EMPRESAS**
**Funcionalidades:**
- ✅ Cadastro de empresas parceiras
- ✅ Contratos corporativos
- ✅ Gestão de convênios
- ✅ Faturamento empresarial
- ✅ Relatórios por empresa

### 🏃‍♂️ **2.3 CATEGORIA DE ATIVIDADES/SERVIÇOS**
**Funcionalidades:**
- ✅ Classificação de modalidades
- ✅ Categorização de equipamentos
- ✅ Agrupamento de serviços
- ✅ Hierarquia de categorias

### 💰 **2.4 CONTAS FINANCEIRAS**
**Funcionalidades:**
- ✅ Plano de contas contábil
- ✅ Centros de custo
- ✅ Contas a pagar e receber
- ✅ Conciliação bancária
- ✅ Fluxo de caixa

### 📊 **2.5 CATEGORIAS FINANCEIRAS**
**Funcionalidades:**
- ✅ Classificação de receitas/despesas
- ✅ Relatórios por categoria
- ✅ Análise de margem por categoria

---

## 🤝 DEPARTAMENTO 3: CLIENTES E FORNECEDORES
*Gestão de Relacionamentos e Parcerias*

### 💼 **3.1 VENDA DE SERVIÇO POR DEMANDA**
**Funcionalidades:**
- ✅ Agendamento de serviços sob demanda
- ✅ Personal trainer por hora
- ✅ Consultorias especializadas
- ✅ Massagem e fisioterapia
- ✅ Avaliação física pontual
- ✅ Pagamento por uso

**Telas:**
- `/servicos/agendamento` - Agenda de serviços
- `/servicos/profissionais` - Lista de profissionais
- `/servicos/historico` - Histórico de atendimentos

### 💳 **3.2 CASHBACK - VALIDAÇÃO**
**Funcionalidades:**
- ✅ Sistema de cashback automático
- ✅ Validação de transações
- ✅ Extrato de cashback
- ✅ Resgate de valores
- ✅ Programa de indicação

### 🎫 **3.3 CAREMARK - DESCONTO**
**Funcionalidades:**
- ✅ Cartão de desconto para parceiros
- ✅ Rede de estabelecimentos conveniados
- ✅ Descontos escalonados
- ✅ Geolocalização de parceiros

---

## 💰 DEPARTAMENTO 4: VENDAS DE PLANO INDIVIDUAL
*Gestão de Vendas Personalizadas*

### 🏃‍♀️ **4.1 AVALIAÇÃO FÍSICA**
**Funcionalidades:**
- ✅ Agendamento de avaliações
- ✅ Fichas de avaliação digitais
- ✅ Histórico de progressão
- ✅ Relatórios biomédicos
- ✅ Fotos de progresso
- ✅ Integração com bioimpedância

**Telas:**
- `/avaliacoes/agenda` - Agenda de avaliações
- `/avaliacoes/ficha` - Ficha de avaliação
- `/avaliacoes/relatorios` - Relatórios

### ⚙️ **4.2 ADMINISTRATIVO**
**Funcionalidades:**
- ✅ Processamento de vendas
- ✅ Contratos individuais
- ✅ Documentação legal
- ✅ Aprovações de desconto

---

## 🎓 DEPARTAMENTO 5: MATRÍCULAS
*Gestão do Processo de Matrícula*

### 🔄 **5.1 RETENÇÃO DE CHECK-IN**
**Funcionalidades:**
- ✅ Análise de padrões de uso
- ✅ Alertas de inatividade
- ✅ Campanhas de reengajamento
- ✅ Gamificação de frequência

### ⚙️ **5.2 ADMINISTRATIVO**
**Funcionalidades:**
- ✅ Processamento de matrículas
- ✅ Documentação necessária
- ✅ Verificação de dados
- ✅ Aprovação de matrículas

### 💰 **5.3 FINANCEIRO**
**Funcionalidades:**
- ✅ Cobrança de taxas de matrícula
- ✅ Planos de pagamento
- ✅ Desconto para estudantes/idosos
- ✅ Parcelamento de mensalidades

### 👤 **5.4 USUÁRIOS**
**Funcionalidades:**
- ✅ Criação de perfis de usuário
- ✅ Configuração de acesso
- ✅ Definição de permissões
- ✅ Ativação de carteirinha

---

## 🚀 DEPARTAMENTO 6: ATIVAÇÃO DE MEMBROS
*Onboarding e Engajamento*

### 🔧 **6.1 MANUTENÇÃO**
**Funcionalidades:**
- ✅ Manutenção de dados dos membros
- ✅ Atualização de informações
- ✅ Gestão de status de ativação
- ✅ Limpeza de dados inativos

### ⚙️ **6.2 ADMINISTRATIVO**
**Funcionalidades:**
- ✅ Processo de ativação
- ✅ Verificação de documentos
- ✅ Aprovação de ativações
- ✅ Comunicação com novos membros

### 📢 **6.3 MARKETING**
**Funcionalidades:**
- ✅ Campanhas de boas-vindas
- ✅ E-mail marketing automatizado
- ✅ SMS de ativação
- ✅ Ofertas para novos membros
- ✅ Programa de indicação

**Telas:**
- `/marketing/campanhas` - Gestão de campanhas
- `/marketing/automacao` - Fluxos automatizados
- `/marketing/indicacao` - Programa de indicação

### 💰 **6.4 FINANCEIRO**
**Funcionalidades:**
- ✅ Processamento de pagamentos iniciais
- ✅ Setup de cobrança recorrente
- ✅ Gestão de inadimplência
- ✅ Relatórios financeiros de ativação

### 👤 **6.5 USUÁRIOS**
**Funcionalidades:**
- ✅ Onboarding de novos usuários
- ✅ Tour virtual da academia
- ✅ Configuração de preferências
- ✅ Treinamento de uso do app

### ✅ **6.6 CHECK-IN**
**Funcionalidades:**
- ✅ Primeiro check-in assistido
- ✅ Tutorial de uso do QR Code
- ✅ Configuração de notificações
- ✅ Integração com wearables

---

## 📚 DEPARTAMENTO 7: MATRÍCULA/AVANÇAR
*Processos Avançados de Matrícula*

### 🏃‍♀️ **7.1 AVALIAÇÃO FÍSICA**
**Funcionalidades:**
- ✅ Avaliação obrigatória pré-matrícula
- ✅ Teste de aptidão física
- ✅ Recomendações de modalidades
- ✅ Definição de objetivos

### 🍎 **7.2 AVALIAÇÃO NUTRICIONAL**
**Funcionalidades:**
- ✅ Avaliação nutricional completa
- ✅ Plano alimentar personalizado
- ✅ Acompanhamento nutricional
- ✅ Integração com nutricionistas
- ✅ Calculadora de IMC e bioimpedância

**Telas:**
- `/nutricao/avaliacao` - Avaliação nutricional
- `/nutricao/planos` - Planos alimentares
- `/nutricao/acompanhamento` - Follow-up

### 🎯 **7.3 RETENÇÃO**
**Funcionalidades:**
- ✅ Estratégias de retenção
- ✅ Ofertas personalizadas
- ✅ Análise de motivos de cancelamento
- ✅ Programas de fidelidade

### 🛒 **7.4 COMPRAS**
**Funcionalidades:**
- ✅ Loja integrada de suplementos
- ✅ Equipamentos de treino
- ✅ Roupas e acessórios
- ✅ Programa de pontos

---

## ⚙️ DEPARTAMENTO 8: ADMINISTRATIVO
*Gestão Administrativa e Operacional*

### 👤 **8.1 USUÁRIOS**
**Funcionalidades:**
- ✅ Gestão completa de usuários
- ✅ Perfis e roles
- ✅ Histórico de atividades
- ✅ Gestão de sessões

### 🔐 **8.2 PERMISSÕES**
**Funcionalidades:**
- ✅ Sistema RBAC (Role-Based Access Control)
- ✅ Permissões granulares
- ✅ Auditoria de acessos
- ✅ Gestão de grupos

**Telas:**
- `/admin/usuarios` - Gestão de usuários
- `/admin/permissoes` - Configuração de permissões
- `/admin/auditoria` - Logs de auditoria

### 🌐 **8.3 SUPORTE INTERNET**
**Funcionalidades:**
- ✅ Help desk integrado
- ✅ Base de conhecimento
- ✅ Chat online
- ✅ Tickets de suporte
- ✅ FAQ dinâmica

### 📦 **8.4 SUPRIMENTOS**
**Funcionalidades:**
- ✅ Gestão de estoque
- ✅ Compras e fornecedores
- ✅ Controle de qualidade
- ✅ Alertas de reposição

### 💰 **8.5 VENDAS**
**Funcionalidades:**
- ✅ Pipeline de vendas
- ✅ CRM integrado
- ✅ Relatórios de performance
- ✅ Comissões de vendedores

---

## 🏢 DEPARTAMENTO 9: PERFIL FILIAL
*Configurações e Dados da Empresa*

### 🏢 **9.1 DADOS DA EMPRESA**
**Funcionalidades:**
- ✅ Informações corporativas
- ✅ Dados fiscais e jurídicos
- ✅ Configurações de filiais
- ✅ Horários de funcionamento
- ✅ Contatos e endereços

**Telas:**
- `/empresa/perfil` - Dados gerais
- `/empresa/filiais` - Gestão de filiais
- `/empresa/configuracoes` - Configurações gerais

### 💰 **9.2 FINANCEIRO**
**Funcionalidades:**
- ✅ Relatórios financeiros consolidados
- ✅ DRE por filial
- ✅ Fluxo de caixa
- ✅ Análise de lucratividade

### 🛠️ **9.3 SERVIÇOS**
**Funcionalidades:**
- ✅ Catálogo de serviços oferecidos
- ✅ Configuração de preços
- ✅ Disponibilidade por filial
- ✅ Agendamento online

### 📋 **9.4 CONTRATO DE DADOS**
**Funcionalidades:**
- ✅ Gestão de contratos
- ✅ Assinaturas digitais
- ✅ Versionamento de contratos
- ✅ Conformidade LGPD

### 📊 **9.5 EXPORTAÇÃO DE DADOS**
**Funcionalidades:**
- ✅ Exportação em múltiplos formatos
- ✅ Relatórios personalizados
- ✅ Integração com BI
- ✅ Backup automatizado

---

## 🔒 SISTEMA DE SEGURANÇA E PERMISSÕES

### **Níveis de Acesso:**
1. **Super Admin** - Acesso total ao sistema
2. **Admin Filial** - Gestão da filial específica
3. **Gerente** - Operações departamentais
4. **Funcionário** - Acesso limitado por função
5. **Membro** - Área do cliente

### **Controles de Segurança:**
- ✅ Autenticação multifator (2FA)
- ✅ Criptografia end-to-end
- ✅ Logs de auditoria completos
- ✅ Conformidade LGPD
- ✅ Backup automatizado
- ✅ Monitoramento de intrusion

---

## 📱 APLICAÇÕES MÓVEIS

### **App Cliente (React Native)**
- Check-in/check-out
- Carteirinha digital
- Agendamentos
- Compras
- Avaliações

### **App Funcionário (PWA)**
- Scanner check-in
- Gestão de agendamentos
- Relatórios
- Comunicação interna

---

## 🔌 INTEGRAÇÕES EXTERNAS

### **APIs Implementadas:**
- MercadoPago (Pagamentos)
- Stripe (Pagamentos internacionais)
- WhatsApp Business (Comunicação)
- Google Maps (Localização)
- Mailgun (E-mail marketing)
- Twilio (SMS)
- DocuSign (Assinaturas digitais)

### **Integrações Planejadas:**
- ERP SAP
- Contabilidade (Conta Azul)
- RH (Gupy)
- BI (Power BI)

---

## 📊 RELATÓRIOS E ANALYTICS

### **Dashboards Principais:**
1. **Executivo** - Métricas de alto nível
2. **Operacional** - KPIs operacionais
3. **Financeiro** - Análise financeira
4. **Marketing** - Performance de campanhas
5. **RH** - Métricas de pessoas

### **Relatórios Automatizados:**
- Relatórios diários de check-ins
- Análise semanal de retenção
- Relatório mensal financeiro
- Trimestral de performance

---

## 🚀 ROADMAP DE IMPLEMENTAÇÃO

### **Fase 1 (3 meses)** - Fundação
- Core do sistema com Supabase
- Autenticação e permissões
- Módulos básicos (check-in, pagamentos)

### **Fase 2 (3 meses)** - Expansão
- Departamentos administrativos
- CRM e marketing
- Relatórios básicos

### **Fase 3 (3 meses)** - Avançado
- BI e analytics
- Integrações externas
- Apps móveis

### **Fase 4 (3 meses)** - Otimização
- IA e machine learning
- Automação avançada
- Escalabilidade

**TOTAL DE FUNCIONALIDADES: 80+ módulos distribuídos em 9 departamentos**