# 📅 Sistema de Agendamento Escolar Inteligente

**Plataforma web moderna para gerenciamento de salas de vídeo, laboratório de informática e recursos pedagógicos da Escola Estadual Felício Roxo.**

[![Status](https://img.shields.io/badge/status-ativo-brightgreen)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Node.js](https://img.shields.io/badge/node.js-v18+-green.svg)]()
[![Next.js](https://img.shields.io/badge/next.js-16.2-black.svg)]()
[![Firebase](https://img.shields.io/badge/firebase-10.0-orange.svg)]()

---

## 🎯 Visão Geral

O **Sistema de Agendamento Escolar** é uma plataforma inteligente e responsiva que permite que professores da Escola Estadual Felício Roxo agendem salas de vídeo, laboratórios de informática e recursos pedagógicos de forma organizada, segura e sem conflitos de horário.

A plataforma implementa **regras de prioridade automáticas** baseadas na categoria do professor, **validação de conflitos em tempo real** e uma **interface moderna e intuitiva** inspirada em calendários digitais.

### ✨ Principais Características

- ✅ **Autenticação Segura** - Login com email e senha via Firebase
- ✅ **Calendário Interativo** - Visualização de disponibilidades em tempo real
- ✅ **Controle de Conflitos** - Impede automaticamente reservas duplicadas
- ✅ **Regras de Prioridade** - 7 dias para professores regulares, 21 para técnicos
- ✅ **Painel Responsivo** - Funciona perfeitamente em desktop, tablet e mobile
- ✅ **Interface Moderna** - Design limpo e intuitivo com Tailwind CSS
- ✅ **Banco de Dados em Nuvem** - Firebase Firestore para armazenamento seguro
- ✅ **Deploy Automático** - Hospedado no Vercel com CI/CD integrado

---

## 🏗️ Arquitetura Técnica

### Stack Tecnológico

| Camada | Tecnologia | Versão | Descrição |
|--------|-----------|--------|-----------|
| **Frontend** | Next.js | 16.2 | Framework React com SSR e otimizações |
| **Linguagem** | TypeScript | 5.0+ | Type-safe development |
| **Estilização** | Tailwind CSS | 3.4 | Utility-first CSS framework |
| **Autenticação** | Firebase Auth | 10.0 | Gerenciamento de usuários |
| **Banco de Dados** | Firestore | - | NoSQL em tempo real |
| **Hospedagem** | Vercel | - | Deploy serverless |
| **Runtime** | Node.js | 18+ | JavaScript runtime |

### Arquitetura da Aplicação

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (Next.js)                       │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │   Página Home    │  │   Dashboard      │                │
│  │   (Login)        │  │   (Reservas)     │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              FIREBASE (Backend-as-a-Service)                │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  Authentication  │  │    Firestore     │                │
│  │   (Email/Senha)  │  │   (Reservas)     │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                  VERCEL (Hospedagem)                        │
│              Deploy automático via GitHub                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 Estrutura do Projeto

```
agendamento-escolar/
├── pages/
│   ├── index.tsx              # Página de login
│   ├── dashboard.tsx          # Dashboard com reservas
│   ├── _app.tsx               # Configuração da aplicação
│   └── api/                   # Rotas API (se necessário)
│
├── lib/
│   └── firebase.ts            # Configuração Firebase
│
├── styles/
│   └── globals.css            # Estilos globais
│
├── public/                    # Arquivos estáticos
│
├── package.json               # Dependências
├── tsconfig.json              # Configuração TypeScript
├── tailwind.config.js         # Configuração Tailwind
├── next.config.js             # Configuração Next.js
├── vercel.json                # Configuração Vercel
│
└── README.md                  # Este arquivo
```

---

## 🔐 Autenticação e Segurança

### Fluxo de Autenticação

```
┌──────────────┐
│   Professor  │
└──────┬───────┘
       │ 1. Acessa o site
       ▼
┌──────────────────────┐
│  Página de Login     │
│  (Email + Senha)     │
└──────┬───────────────┘
       │ 2. Submete credenciais
       ▼
┌──────────────────────┐
│  Firebase Auth       │
│  (Valida dados)      │
└──────┬───────────────┘
       │ 3. Gera token JWT
       ▼
┌──────────────────────┐
│  Dashboard           │
│  (Acesso liberado)   │
└──────────────────────┘
```

### Gestão de Usuários

**Criar novo usuário:**

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto
3. Vá em **Authentication** → **Users**
4. Clique em **"Add user"**
5. Digite email e senha
6. Clique em **"Create"**

**Usuários podem fazer login com:**
- Email registrado
- Senha correspondente

---

## 📊 Funcionalidades Detalhadas

### 1. Página de Login

- Interface limpa e responsiva
- Campo para email institucional
- Campo para senha
- Mensagens de erro claras
- Indicador de carregamento

### 2. Dashboard

**Visualizar Reservas:**
- Lista de todas as reservas do professor
- Status de cada reserva
- Data, hora, sala e finalidade

**Fazer Nova Reserva:**
- Seleção de sala (Vídeo, Laboratório, Recursos)
- Escolha de data e hora
- Informação de turma
- Descrição da finalidade
- Validação de conflitos

**Cancelar Reserva:**
- Apenas o criador pode cancelar
- Confirmação antes de deletar
- Feedback visual de sucesso

---

## 🚀 Como Instalar e Usar

### Pré-requisitos

- Node.js v18 ou superior
- npm ou yarn
- Conta no Firebase
- Conta no Vercel (para deploy)

### 1. Clonar o Repositório

```bash
git clone git@github.com:AiltonRock22/agendamento-escolar.git
cd agendamento-escolar
```

### 2. Instalar Dependências

```bash
npm install
# ou
yarn install
```

### 3. Configurar Variáveis de Ambiente

Crie um arquivo `.env.local` na raiz do projeto:

```env
NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyBzOdP8TmP9FrrNtchY2IDgMVO3vWOuVQQ
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=agendamentoescola-ee596.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=agendamentoescola-ee596
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=agendamentoescola-ee596.firebasestorage.app
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=437842972818
NEXT_PUBLIC_FIREBASE_APP_ID=1:437842972818:web:edbbac2b8612450d3cd64b
```

### 4. Rodar Localmente

```bash
npm run dev
# ou
yarn dev
```

Acesse: **http://localhost:3000**

### 5. Build para Produção

```bash
npm run build
npm run start
```

---

## 🌐 Deploy no Vercel

### Método 1: Automático (Recomendado)

1. Faça push para GitHub
2. Acesse [vercel.com](https://vercel.com)
3. Clique em **"New Project"**
4. Selecione seu repositório
5. Configure as variáveis de ambiente (Firebase)
6. Clique em **"Deploy"**

### Método 2: CLI do Vercel

```bash
npm install -g vercel
vercel
```

Siga as instruções no terminal.

---

## 📋 Variáveis de Ambiente

### Obrigatórias

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `NEXT_PUBLIC_FIREBASE_API_KEY` | Chave da API Firebase | `AIzaSy...` |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | Domínio de autenticação | `project.firebaseapp.com` |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | ID do projeto Firebase | `agendamentoescola-ee596` |
| `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` | Bucket de armazenamento | `project.firebasestorage.app` |
| `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` | ID do sender | `437842972818` |
| `NEXT_PUBLIC_FIREBASE_APP_ID` | ID da aplicação | `1:437842972818:web:...` |

**Nota:** Variáveis com prefixo `NEXT_PUBLIC_` são expostas no frontend (seguro para Firebase).

---

## 🎨 Design e Interface

### Paleta de Cores

```
Primária:    #0066FF (Azul - Escola)
Secundária:  #FF3333 (Vermelho - Escola)
Sucesso:     #22C55E (Verde)
Aviso:       #FBBF24 (Amarelo)
Erro:        #EF4444 (Vermelho)
Background:  #FFFFFF (Branco)
Foreground:  #1F2937 (Cinza Escuro)
```

### Tipografia

- **Font Family:** Inter, -apple-system, BlinkMacSystemFont
- **Headings:** Bold (700)
- **Body:** Regular (400)

### Responsividade

- ✅ Mobile (320px+)
- ✅ Tablet (768px+)
- ✅ Desktop (1024px+)

---

## 📱 Compatibilidade

| Navegador | Versão Mínima | Status |
|-----------|---------------|--------|
| Chrome | 90+ | ✅ Suportado |
| Firefox | 88+ | ✅ Suportado |
| Safari | 14+ | ✅ Suportado |
| Edge | 90+ | ✅ Suportado |
| Mobile Safari | 14+ | ✅ Suportado |
| Chrome Mobile | 90+ | ✅ Suportado |

---

## 🧪 Testes

```bash
# Rodar testes
npm run test

# Testes com coverage
npm run test:coverage

# Modo watch
npm run test:watch
```

---

## 📚 Documentação Adicional

- [Next.js Documentation](https://nextjs.org/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vercel Deployment](https://vercel.com/docs)
- [TypeScript](https://www.typescriptlang.org/docs/)

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 📞 Suporte e Contato

**Escola Estadual Felício Roxo**

- 📍 Endereço: R. Professor Genaldo, 475, Sumaré, Montes Claros/MG
- 📞 Telefone: (38) 3223-8633
- ⏰ Atendimento: Segunda a Sexta, 7h às 17h

**Segmentos Atendidos:**
- Ensino Fundamental II
- Ensino Médio em Tempo Integral
- Educação de Jovens e Adultos (EJA)

---

## 🙏 Agradecimentos

Desenvolvido com ❤️ para a **Escola Estadual Felício Roxo**

Obrigado por usar o Sistema de Agendamento Escolar!

---

## 📈 Roadmap Futuro

- [ ] Painel administrativo para gerenciar usuários
- [ ] Relatórios de uso de salas
- [ ] Notificações por email
- [ ] Integração com calendário Google
- [ ] Modo escuro
- [ ] Suporte a múltiplas escolas

---

**Última atualização:** Maio 2026

**Versão:** 1.0.0

**Status:** ✅ Em produção
