#!/bin/bash

echo "🚀 Script para fazer push do projeto para o GitHub"
echo "=================================================="
echo ""
echo "Este script fará o push do projeto APP LG para seu repositório GitHub."
echo ""
echo "Repositório de destino: https://github.com/joseliojamaro2015-blip/appminimax.git"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Erro: Execute este script no diretório raiz do projeto"
    exit 1
fi

# Verificar se o git está configurado
if [ ! -d ".git" ]; then
    echo "❌ Erro: Este não é um repositório Git"
    exit 1
fi

echo "📋 Status atual do repositório:"
git status
echo ""

echo "📝 Último commit:"
git log --oneline -1
echo ""

echo "🔄 Fazendo push para o GitHub..."
echo "Você pode ser solicitado a inserir suas credenciais do GitHub."
echo ""

# Fazer o push
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Sucesso! O projeto foi enviado para o GitHub."
    echo ""
    echo "🌐 Seu repositório está disponível em:"
    echo "   https://github.com/joseliojamaro2015-blip/appminimax"
    echo ""
    echo "📋 Próximos passos:"
    echo "   1. Acesse seu repositório no GitHub"
    echo "   2. Configure o deploy na Vercel"
    echo "   3. Configure o banco de dados no Supabase"
    echo "   4. Veja as instruções em INSTRUCOES_COMPLETAS.md"
    echo ""
else
    echo ""
    echo "❌ Erro ao fazer push para o GitHub."
    echo ""
    echo "💡 Possíveis soluções:"
    echo "   1. Verifique suas credenciais do GitHub"
    echo "   2. Certifique-se de que o repositório existe e você tem acesso"
    echo "   3. Tente fazer login no GitHub: gh auth login"
    echo "   4. Ou configure um token de acesso pessoal"
    echo ""
fi
