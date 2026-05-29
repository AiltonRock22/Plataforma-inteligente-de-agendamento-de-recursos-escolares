#!/bin/bash

# Script de Deploy Automático para GitHub
# Use: bash deploy-github.sh seu-usuario seu-repositorio

set -e

echo "🚀 Sistema de Agendamento Escolar - Deploy GitHub"
echo "=================================================="

# Verificar argumentos
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Erro: Faltam argumentos"
    echo ""
    echo "Uso: bash deploy-github.sh <seu-usuario-github> <nome-repositorio>"
    echo ""
    echo "Exemplo:"
    echo "  bash deploy-github.sh joaosilva agendamento-escolar"
    echo ""
    exit 1
fi

GITHUB_USER=$1
REPO_NAME=$2
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo "📝 Configuração:"
echo "  Usuário GitHub: $GITHUB_USER"
echo "  Repositório: $REPO_NAME"
echo "  URL: $REPO_URL"
echo ""

# Verificar se git está instalado
if ! command -v git &> /dev/null; then
    echo "❌ Git não está instalado. Instale com: sudo apt-get install git"
    exit 1
fi

# Inicializar git se não existir
if [ ! -d ".git" ]; then
    echo "🔧 Inicializando repositório Git..."
    git init
    git config user.email "seu-email@example.com"
    git config user.name "Seu Nome"
fi

# Adicionar todos os arquivos
echo "📦 Adicionando arquivos..."
git add .

# Criar commit
echo "💾 Criando commit..."
git commit -m "Sistema de Agendamento Escolar - Escola Estadual Felício Roxo" || echo "✓ Nada para fazer"

# Renomear branch para main se necessário
if git rev-parse --verify main >/dev/null 2>&1; then
    echo "✓ Branch main já existe"
else
    echo "🔄 Renomeando branch para main..."
    git branch -M main
fi

# Adicionar remote
echo "🔗 Configurando repositório remoto..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Fazer push
echo "🚀 Enviando para GitHub..."
git push -u origin main --force

echo ""
echo "✅ SUCESSO!"
echo ""
echo "Seu repositório está em: $REPO_URL"
echo ""
echo "Próximos passos:"
echo "1. Acesse: https://vercel.com"
echo "2. Clique em 'New Project'"
echo "3. Selecione seu repositório"
echo "4. Configure as variáveis de ambiente (Firebase)"
echo "5. Clique em 'Deploy'"
echo ""
echo "🎉 Pronto! Seu site estará em: https://$REPO_NAME.vercel.app"
