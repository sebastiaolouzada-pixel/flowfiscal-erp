# FlowFiscal ERP - Backend

Backend da aplicação FlowFiscal ERP desenvolvido em FastAPI.

## Instalação Local

```bash
cd backend
pip install -r requirements.txt
```

## Executar Localmente

```bash
uvicorn app.main:app --reload
```

Acesse em: http://localhost:8000/docs

## Deploy na Nuvem

Este projeto está configurado para deploy automático no Railway.

### Passo 1: Crie uma conta no Railway
https://railway.app

### Passo 2: Conecte seu GitHub
1. Vá para https://railway.app
2. Clique em "Start a New Project"
3. Selecione "Deploy from GitHub"

### Passo 3: Selecione seu repositório
1. Procure por `flowfiscal-erp`
2. Clique para conectar

### Passo 4: Railway fará o deploy automaticamente! 🚀

Sua API estará disponível em uma URL pública que o Railway vai fornecer.

## Endpoints Disponíveis

- `GET /health` - Health check
- `GET /users` - Listar usuários
- `POST /users` - Criar usuário
- `GET /users/{id}` - Obter usuário
- `PUT /users/{id}` - Atualizar usuário
- `DELETE /users/{id}` - Deletar usuário
- `GET /invoices` - Listar invoices
- `POST /invoices` - Criar invoice
- `GET /invoices/{id}` - Obter invoice
- `PUT /invoices/{id}` - Atualizar invoice
- `DELETE /invoices/{id}` - Deletar invoice

## Documentação Interativa

Acesse `/docs` para ver a documentação interativa (Swagger UI)
