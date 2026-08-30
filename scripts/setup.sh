#!/bin/bash

echo "🚀 Configurando entorno local..."

# 1. Instalar swift-format si no existe
if ! command -v swift-format &> /dev/null; then
  echo "📦 Instalando swift-format vía Homebrew..."
  brew install swift-format
else
  echo "✅ swift-format ya está instalado."
fi

# 2. Configurar Git Hooks
mkdir -p .git/hooks

cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

cp scripts/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

echo "🎉 Listo. Linter automático y validador de commits activados."