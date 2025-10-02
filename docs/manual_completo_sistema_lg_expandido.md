# 📋 MANUAL COMPLETO - SISTEMA EMPRESARIAL APP LG
*Sistema de Gestão Empresarial Completa para Academias e Clubes Fitness*

---

## 📊 VISÃO GERAL DO SISTEMA

O APP LG é uma **plataforma completa de gestão empresarial** desenvolvida especificamente para academias, integrando todos os departamentos organizacionais em uma solução unificada com mais de 100 funcionalidades específicas.

### 🏗️ **Arquitetura Técnica**
- **Frontend:** Next.js 14 + React 18 + TypeScript + Tailwind CSS
- **Backend:** Supabase (PostgreSQL + Edge Functions + Auth + Storage)
- **Deploy:** Vercel (Auto-deploy com GitHub integration)
- **Pagamentos:** MercadoPago + Stripe (multi-gateway)
- **Segurança:** JWT + Row Level Security + RBAC
- **Mobile:** PWA responsivo + React Native opcional

---

## 📦 MÓDULO 1: MEU NEGÓCIO / ADMINISTRATIVO
*Gestão Central da Empresa e Configurações*

### 🏢 **1.1 EMPRESA (MATRIZ)**
**Funcionalidades:**
- ✅ Cadastro da empresa matriz
- ✅ Dados fiscais e jurídicos
- ✅ Configurações globais do sistema
- ✅ Políticas corporativas
- ✅ Identidade visual (logo, cores, marca)
- ✅ Informações de contato e endereço

**Telas:**
- `/admin/empresa` - Dados da empresa
- `/admin/configuracoes` - Configurações globais
- `/admin/identidade-visual` - Branding

### 🏪 **1.2 FILIAIS**
**Funcionalidades:**
- ✅ Cadastro e gestão de filiais
- ✅ Configurações específicas por unidade
- ✅ Hierarquia organizacional
- ✅ Transferência entre filiais
- ✅ Relatórios consolidados e por filial
- ✅ Gestão de horários por unidade

**Telas:**
- `/admin/filiais` - Lista de filiais
- `/admin/filiais/nova` - Cadastro de filial
- `/admin/filiais/{id}` - Detalhes da filial

### 👥 **1.3 USUÁRIOS**
**Funcionalidades:**
- ✅ Gestão completa de usuários
- ✅ Cadastro de funcionários e administradores
- ✅ Status ativo/inativo
- ✅ Histórico de atividades
- ✅ Redefinição de senhas
- ✅ Controle de sessões

**Telas:**
- `/admin/usuarios` - Lista de usuários
- `/admin/usuarios/novo` - Cadastro
- `/admin/usuarios/{id}` - Perfil do usuário

### 🔐 **1.4 PERFIS/PERMISSÕES (RBAC)**
**Funcionalidades:**
- ✅ Sistema de controle de acesso baseado em roles
- ✅ Criação de perfis personalizados
- ✅ Atribuição de permissões granulares
- ✅ Herança de permissões
- ✅ Auditoria de acessos
- ✅ Políticas de segurança

**Perfis Padrão:**
- **Super Admin:** Acesso total ao sistema
- **Admin Filial:** Gestão completa da filial
- **Gerente:** Acesso departamental
- **Funcionário:** Acesso operacional limitado
- **Recepção:** Check-in e cadastros básicos

**Telas:**
- `/admin/perfis` - Lista de perfis
- `/admin/permissoes` - Matriz de permissões
- `/admin/usuarios/{id}/permissoes` - Permissões do usuário

### ⚙️ **1.5 PARÂMETROS DO SISTEMA**
**Funcionalidades:**
- ✅ Configurações operacionais
- ✅ Regras de negócio configuráveis
- ✅ Parâmetros de integração
- ✅ Configurações de notificação
- ✅ Políticas de cobrança
- ✅ Configurações de backup

**Categorias:**
- **Financeiro:** Juros, multas, descontos
- **Operacional:** Horários, capacidade, regras
- **Comunicação:** WhatsApp, e-mail, SMS
- **Integração:** APIs externas, webhooks

### 📋 **1.6 LOG/AUDITORIA**
**Funcionalidades:**
- ✅ Registro completo de atividades
- ✅ Trilha de auditoria
- ✅ Logs de segurança
- ✅ Monitoramento de performance
- ✅ Alertas de atividades suspeitas
- ✅ Relatórios de compliance

**Telas:**
- `/admin/logs` - Visualização de logs
- `/admin/auditoria` - Relatórios de auditoria
- `/admin/seguranca` - Logs de segurança

---

## 📝 MÓDULO 2: CADASTROS
*Gestão de Pessoas e Entidades*

### 👤 **2.1 PESSOA FÍSICA**
**Funcionalidades:**
- ✅ Cadastro completo de pessoas físicas
- ✅ Documentos (CPF, RG, CNH)
- ✅ Dados de contato e endereço
- ✅ Informações médicas básicas
- ✅ Fotos e documentos digitais
- ✅ Histórico de relacionamento

### 🏢 **2.2 PESSOA JURÍDICA**
**Funcionalidades:**
- ✅ Cadastro de empresas
- ✅ Dados fiscais (CNPJ, IE, IM)
- ✅ Informações de contato corporativo
- ✅ Representantes legais
- ✅ Contratos e convênios
- ✅ Histórico de transações

### 🤝 **2.3 CLIENTES**
**Funcionalidades:**
- ✅ Perfil completo do cliente
- ✅ Histórico de matrículas
- ✅ Preferências e restrições
- ✅ Programa de fidelidade
- ✅ Comunicação personalizada
- ✅ Score de engajamento

### 🚚 **2.4 FORNECEDORES**
**Funcionalidades:**
- ✅ Cadastro de fornecedores
- ✅ Categorização por tipo de produto/serviço
- ✅ Avaliação de performance
- ✅ Contratos e condições de pagamento
- ✅ Histórico de compras
- ✅ Documentação fiscal

### 💼 **2.5 VENDEDORES**
**Funcionalidades:**
- ✅ Cadastro da equipe de vendas
- ✅ Metas individuais e por equipe
- ✅ Comissionamento
- ✅ Território de atuação
- ✅ Performance e rankings
- ✅ Treinamentos e certificações

### 👨‍💼 **2.6 FUNCIONÁRIOS**
**Funcionalidades:**
- ✅ Cadastro completo de RH
- ✅ Controle de ponto
- ✅ Cargos e hierarquias
- ✅ Documentos trabalhistas
- ✅ Avaliações de performance
- ✅ Treinamentos e capacitações

### 🔧 **2.7 PRESTADORES DE SERVIÇO**
**Funcionalidades:**
- ✅ Cadastro de profissionais autônomos
- ✅ Especializações e certificações
- ✅ Agenda de disponibilidade
- ✅ Avaliações de clientes
- ✅ Contratos de prestação
- ✅ Histórico de atendimentos

---

## 🏋️ MÓDULO 3: ACADEMIAS
*Gestão da Rede de Academias*

### 🏢 **3.1 ACADEMIAS PARCEIRAS**
**Funcionalidades:**
- ✅ Rede de academias conveniadas
- ✅ Sistema de reciprocidade
- ✅ Mapeamento geográfico
- ✅ Avaliações e reviews
- ✅ Contratos de parceria
- ✅ Faturamento entre parceiros

### 📋 **3.2 MATRÍCULAS**
**Funcionalidades:**
- ✅ Processo completo de matrícula
- ✅ Documentação digital
- ✅ Assinatura eletrônica
- ✅ Aprovação automática/manual
- ✅ Integração com pagamento
- ✅ Welcome kit digital

### ✅ **3.3 CHECK-INS**
**Funcionalidades:**
- ✅ Check-in por QR Code
- ✅ Reconhecimento facial
- ✅ Check-in manual
- ✅ Controle de capacidade
- ✅ Histórico de frequência
- ✅ Alertas de inatividade

### 📊 **3.4 AVALIAÇÕES (FÍSICA, NUTRICIONAL)**
**Funcionalidades:**
- ✅ Agendamento de avaliações
- ✅ Fichas digitais padronizadas
- ✅ Histórico de progressão
- ✅ Relatórios biomédicos
- ✅ Recomendações automáticas
- ✅ Integração com wearables

---

## 👥 MÓDULO 4: MEMBROS
*Gestão Completa de Membros*

### 🆔 **4.1 MEMBROS**
**Funcionalidades:**
- ✅ Perfil completo do membro
- ✅ Status da matrícula
- ✅ Histórico de atividades
- ✅ Preferências pessoais
- ✅ Comunicação multicanal
- ✅ Programa de indicação

### 💳 **4.2 ASSINATURAS/PLANOS**
**Funcionalidades:**
- ✅ Variedade de planos de assinatura
- ✅ Upgrade/downgrade automático
- ✅ Planos corporativos
- ✅ Promoções e descontos
- ✅ Renovação automática
- ✅ Freeze de planos

### 💰 **4.3 FORMAS DE PAGAMENTO**
**Funcionalidades:**
- ✅ Múltiplas formas de pagamento
- ✅ Pagamento recorrente
- ✅ Cartão de crédito/débito
- ✅ PIX, boleto, transferência
- ✅ Carteira digital
- ✅ Parcelamento flexível

### 🛒 **4.4 COMPRAS/RESGATES**
**Funcionalidades:**
- ✅ Loja virtual integrada
- ✅ Sistema de pontos
- ✅ Cashback e recompensas
- ✅ Histórico de transações
- ✅ Programa de fidelidade
- ✅ Cupons e vouchers

### ✅ **4.5 CHECK-INS**
**Funcionalidades:**
- ✅ Check-in simplificado
- ✅ Histórico pessoal
- ✅ Metas de frequência
- ✅ Gamificação
- ✅ Check-in em parceiros
- ✅ Estatísticas pessoais

---

## 💼 MÓDULO 5: VENDAS
*Gestão Comercial Completa*

### 👤 **5.1 PLANOS (INDIVIDUAL/CORPORATIVO)**
**Funcionalidades:**
- ✅ Catálogo de planos individuais
- ✅ Pacotes corporativos
- ✅ Customização de benefícios
- ✅ Simulador de preços
- ✅ Contratos digitais
- ✅ Renovação automática

### 🔧 **5.2 SERVIÇOS POR DEMANDA**
**Funcionalidades:**
- ✅ Personal trainer
- ✅ Massagem terapêutica
- ✅ Consulta nutricional
- ✅ Avaliação física
- ✅ Agendamento online
- ✅ Pagamento avulso

### 📋 **5.3 PROPOSTAS/ORÇAMENTOS**
**Funcionalidades:**
- ✅ Geração automática de propostas
- ✅ Aprovação digital
- ✅ Versionamento de propostas
- ✅ Pipeline de vendas
- ✅ Follow-up automático
- ✅ Conversão em contrato

### 🤝 **5.4 VÍNCULO AO VENDEDOR**
**Funcionalidades:**
- ✅ Atribuição de clientes
- ✅ Comissionamento
- ✅ Metas individuais
- ✅ Performance tracking
- ✅ Relatórios de vendas
- ✅ Gamificação da equipe

---

## 💰 MÓDULO 6: FINANCEIRO
*Gestão Financeira Completa*

### 🏦 **6.1 CONTAS FINANCEIRAS**
**Funcionalidades:**
- ✅ Plano de contas
- ✅ Contas bancárias
- ✅ Cartões de crédito
- ✅ Contas de investimento
- ✅ Conciliação automática
- ✅ Saldos em tempo real

### 📊 **6.2 CATEGORIAS FINANCEIRAS (RECEITA/DESPESA)**
**Funcionalidades:**
- ✅ Classificação de receitas
- ✅ Categorização de despesas
- ✅ Centros de custo
- ✅ Relatórios por categoria
- ✅ Análise de margem
- ✅ Orçamento anual

### 💳 **6.3 TRANSAÇÕES**
**Funcionalidades:**
- ✅ Registro de todas as transações
- ✅ Entrada e saída de valores
- ✅ Histórico completo
- ✅ Comprovantes digitais
- ✅ Rastreabilidade
- ✅ Auditoria financeira

### 🔄 **6.4 CONCILIAÇÃO**
**Funcionalidades:**
- ✅ Conciliação bancária automática
- ✅ Importação de extratos
- ✅ Matching de transações
- ✅ Divergências e ajustes
- ✅ Relatórios de conciliação
- ✅ Fechamento mensal

### 📈 **6.5 RELATÓRIOS**
**Funcionalidades:**
- ✅ DRE (Demonstrativo de Resultado)
- ✅ Fluxo de caixa
- ✅ Balanço patrimonial
- ✅ Relatórios gerenciais
- ✅ Dashboards financeiros
- ✅ Export para contabilidade

---

## 🎁 MÓDULO 7: CASHBACK
*Sistema de Recompensas*

### 📋 **7.1 REGRAS**
**Funcionalidades:**
- ✅ Configuração de regras de cashback
- ✅ Percentuais por categoria
- ✅ Limites e tetos
- ✅ Condições de elegibilidade
- ✅ Campanhas promocionais
- ✅ Regras temporárias

### ✅ **7.2 CRÉDITOS (VALIDAÇÃO)**
**Funcionalidades:**
- ✅ Validação automática de transações
- ✅ Cálculo de cashback
- ✅ Aprovação manual quando necessário
- ✅ Histórico de créditos
- ✅ Notificações de acúmulo
- ✅ Extrato detalhado

### 💸 **7.3 RESGATES**
**Funcionalidades:**
- ✅ Resgate em dinheiro
- ✅ Desconto em mensalidades
- ✅ Troca por produtos/serviços
- ✅ Transferência para terceiros
- ✅ Histórico de resgates
- ✅ Comprovantes de resgate

---

## 🏢 MÓDULO 8: PERFIL FILIAL
*Configurações Locais da Filial*

### 📄 **8.1 DADOS DA EMPRESA/FILIAL**
**Funcionalidades:**
- ✅ Informações específicas da filial
- ✅ Dados para emissão de notas fiscais
- ✅ Recibos e comprovantes
- ✅ Informações de contato local
- ✅ Endereço e localização
- ✅ Horários de funcionamento

### 📞 **8.2 CONTATOS**
**Funcionalidades:**
- ✅ Telefones e e-mails
- ✅ Redes sociais
- ✅ WhatsApp Business
- ✅ Site e blog
- ✅ Atendimento ao cliente
- ✅ Emergências

### 📜 **8.3 POLÍTICAS LOCAIS**
**Funcionalidades:**
- ✅ Regras específicas da filial
- ✅ Políticas de cancelamento
- ✅ Horários especiais
- ✅ Regulamento interno
- ✅ Código de conduta
- ✅ Termos de uso local

---

## 🎯 FUNCIONALIDADES TRANSVERSAIS

### 🔔 **NOTIFICAÇÕES E COMUNICAÇÃO**
- ✅ WhatsApp Business API
- ✅ E-mail marketing
- ✅ SMS promocional
- ✅ Push notifications
- ✅ Comunicação interna
- ✅ Alertas do sistema

### 📱 **APLICATIVO MOBILE (PWA)**
- ✅ Interface responsiva
- ✅ Instalação como app
- ✅ Funciona offline
- ✅ Sincronização automática
- ✅ Push notifications
- ✅ Camera para QR Code

### 📊 **DASHBOARD E RELATÓRIOS**
- ✅ Dashboard executivo
- ✅ KPIs em tempo real
- ✅ Relatórios personalizáveis
- ✅ Export para Excel/PDF
- ✅ Agendamento de relatórios
- ✅ Distribuição automática

### 🔒 **SEGURANÇA E COMPLIANCE**
- ✅ LGPD compliance
- ✅ Criptografia de dados
- ✅ Backup automático
- ✅ Controle de acesso
- ✅ Auditoria completa
- ✅ Políticas de retenção

---

## 🚀 ROADMAP DE IMPLEMENTAÇÃO

### **FASE 1 - CORE (2-3 meses)**
1. Módulo Administrativo
2. Cadastros básicos
3. Sistema de usuários e permissões
4. Dashboard principal

### **FASE 2 - OPERACIONAL (2-3 meses)**
1. Módulo de Membros
2. Check-ins e frequência
3. Financeiro básico
4. Vendas e planos

### **FASE 3 - AVANÇADO (2-3 meses)**
1. Sistema de Cashback
2. Academias parceiras
3. Relatórios avançados
4. Integrações externas

### **FASE 4 - OTIMIZAÇÃO (1-2 meses)**
1. Performance optimization
2. Mobile app nativo
3. IA e machine learning
4. Advanced analytics

---

*📅 Última atualização: 02/10/2025*
*👨‍💻 Desenvolvido por: MiniMax Agent*