#!/bin/bash
# Script para validar e testar o Terraform localmente antes de fazer push

set -e

echo "🔍 Iniciando validação local do Terraform..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Terraform Format
echo -e "${YELLOW}1️⃣  Verificando formatação...${NC}"
if terraform fmt -check -recursive .; then
    echo -e "${GREEN}✅ Formatação OK${NC}"
else
    echo -e "${RED}❌ Erros de formatação encontrados${NC}"
    echo "Executando: terraform fmt -recursive ."
    terraform fmt -recursive .
fi
echo ""

# 2. Terraform Init
echo -e "${YELLOW}2️⃣  Inicializando Terraform...${NC}"
terraform init
echo -e "${GREEN}✅ Inicialização OK${NC}"
echo ""

# 3. Terraform Validate
echo -e "${YELLOW}3️⃣  Validando configuração...${NC}"
if terraform validate; then
    echo -e "${GREEN}✅ Validação OK${NC}"
else
    echo -e "${RED}❌ Erros de validação encontrados${NC}"
    exit 1
fi
echo ""

# 4. Terraform Plan
echo -e "${YELLOW}4️⃣  Gerando plano de execução...${NC}"
terraform plan -out=tfplan
echo -e "${GREEN}✅ Plano gerado com sucesso${NC}"
echo ""

# 5. TFLint (se disponível)
if command -v tflint &> /dev/null; then
    echo -e "${YELLOW}5️⃣  Executando TFLint...${NC}"
    tflint --init
    tflint -f compact
    echo -e "${GREEN}✅ TFLint OK${NC}"
else
    echo -e "${YELLOW}⚠️  TFLint não instalado (opcional)${NC}"
fi
echo ""

echo -e "${GREEN}🎉 Validação local completa!${NC}"
echo ""
echo "Para fazer push, execute:"
echo "  git add ."
echo "  git commit -m 'Mensagem do commit'"
echo "  git push origin main"
