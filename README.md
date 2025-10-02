<<<<<<< HEAD
# 🏋️ Sistema APP LG - Gestão de Academia

Sistema completo de gestão para academias desenvolvido com React, TypeScript e Supabase.

## 🚀 Funcionalidades

### 8 Módulos Principais:
- **👥 Administrativo**: Gestão de usuários, configurações e logs
- **📝 Cadastros**: Alunos, instrutores e planos
- **🏢 Academias**: Unidades, modalidades e equipamentos  
- **📅 Agendamentos**: Horários e reservas de aulas
- **💰 Financeiro**: Contratos, mensalidades e movimentações
- **📧 Comunicação**: Mensagens e notificações
- **📊 Relatórios**: Avaliações físicas e relatórios gerenciais
- **📦 Estoque**: Produtos, vendas e movimentações

## 🛠️ Tecnologias

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS + Shadcn/ui
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **Deploy**: Vercel
- **Database**: 25+ tabelas com relacionamentos

## 📋 Como Usar

### 1. Clonar o Repositório
```bash
git clone https://github.com/joseliojamaro2015-blip/appminimax.git
cd appminimax
```

### 2. Instalar Dependências
```bash
npm install
```

### 3. Configurar Variáveis de Ambiente
Crie um arquivo `.env.local`:
```env
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua-chave-anonima
VITE_APP_URL=http://localhost:5173
```

### 4. Configurar Banco de Dados
Execute o script SQL em `supabase/migrations/` no seu projeto Supabase.

### 5. Executar Localmente
```bash
npm run dev
```

### 6. Build para Produção
```bash
npm run build
```

## 📁 Estrutura do Projeto

```
├── src/
│   ├── components/     # Componentes React
│   ├── hooks/         # Custom hooks
│   ├── lib/           # Utilitários e configurações
│   ├── pages/         # Páginas da aplicação
│   └── types/         # Definições TypeScript
├── supabase/          # Configurações e migrações
├── docs/              # Documentação completa
├── public/            # Arquivos estáticos
└── INSTRUCOES_COMPLETAS.md  # Guia completo de deploy
```

## 🗄️ Banco de Dados

### 25 Tabelas Organizadas em 8 Módulos:

**Administrativo** (3 tabelas)
- configuracoes_sistema
- usuarios_sistema  
- logs_sistema

**Cadastros** (3 tabelas)
- alunos
- instrutores
- planos

**Academias** (3 tabelas)
- unidades
- modalidades
- equipamentos

**Agendamentos** (2 tabelas)
- horarios_modalidades
- agendamentos

**Financeiro** (3 tabelas)
- contratos
- mensalidades
- movimentacoes_financeiras

**Comunicação** (2 tabelas)
- mensagens
- notificacoes

**Relatórios** (2 tabelas)
- avaliacoes_fisicas
- relatorios

**Estoque** (4 tabelas)
- produtos
- movimentacoes_estoque
- vendas
- itens_venda

## 🔧 Deploy

### Vercel
1. Conecte seu repositório GitHub à Vercel
2. Configure as variáveis de ambiente
3. Deploy automático a cada push

### Supabase
1. Crie um projeto no Supabase
2. Execute o script SQL de criação das tabelas
3. Configure RLS (Row Level Security)
4. Ajuste as URLs e chaves no projeto

### GitHub Actions (Opcional)
O projeto inclui workflow de CI/CD para deploy automático.

## 📖 Documentação

- **INSTRUCOES_COMPLETAS.md**: Guia detalhado de configuração e deploy
- **documentacao_navegavel.html**: Interface interativa das funcionalidades
- **docs/**: Documentação técnica completa

## 🛡️ Segurança

- ✅ Row Level Security (RLS) configurado
- ✅ Autenticação via Supabase Auth
- ✅ Validações de dados
- ✅ Controle de acesso por perfil

## 📊 Performance

- ✅ Índices otimizados no banco
- ✅ Lazy loading de componentes
- ✅ Cache de consultas
- ✅ Build otimizado

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 📞 Suporte

Para dúvidas ou suporte:
- Consulte a documentação em `docs/`
- Abra uma issue no GitHub
- Veja as instruções completas em `INSTRUCOES_COMPLETAS.md`

---

**Desenvolvido por**: MiniMax Agent  
**Versão**: 1.0.0  
**Data**: Outubro 2025
=======
# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type aware lint rules:

- Configure the top-level `parserOptions` property like this:

```js
export default tseslint.config({
  languageOptions: {
    // other options...
    parserOptions: {
      project: ['./tsconfig.node.json', './tsconfig.app.json'],
      tsconfigRootDir: import.meta.dirname,
    },
  },
})
```

- Replace `tseslint.configs.recommended` to `tseslint.configs.recommendedTypeChecked` or `tseslint.configs.strictTypeChecked`
- Optionally add `...tseslint.configs.stylisticTypeChecked`
- Install [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react) and update the config:

```js
// eslint.config.js
import react from 'eslint-plugin-react'

export default tseslint.config({
  // Set the react version
  settings: { react: { version: '18.3' } },
  plugins: {
    // Add the react plugin
    react,
  },
  rules: {
    // other rules...
    // Enable its recommended rules
    ...react.configs.recommended.rules,
    ...react.configs['jsx-runtime'].rules,
  },
})
```
>>>>>>> 77e85cde0cac4298bdad999494b581268dd4feb4
