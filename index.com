<!DOCTYPE html>
<html lang="pt-BR" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estética Estefani Ferreira — Estética Premium</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        serif: ['Cormorant Garamond', 'serif'],
                    },
                    colors: {
                        gold: {
                            50: '#fbfaf4', 100: '#f6f1df', 200: '#eddcb1',
                            300: '#e1c17b', 400: '#d5a54b', 500: '#c58b2b',
                            600: '#a77021', 700: '#84531b', 950: '#1f1003'
                        },
                        brand: { DEFAULT: '#515152', hover: '#414142', light: '#717172', dark: '#313132' },
                        dark: { 50: '#f6f6f6', 100: '#e7e7e7', 800: '#1c1c1c', 900: '#121212', 950: '#0a0a0a' }
                    }
                }
            }
        }
    </script>

    <style>
        .luxury-shadow { box-shadow: 0 10px 30px -10px rgba(197,139,43,0.15); }
        .modal-blur { backdrop-filter: blur(8px); }
        .tab-active { background: linear-gradient(135deg, #c58b2b, #a77021); color: #0a0a0a; }
        .tab-inactive { background: transparent; color: #94a3b8; border: 1px solid #515152; }
        .sidebar-link { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; transition: all 0.2s; color: #94a3b8; }
        .sidebar-link:hover { background: rgba(197,139,43,0.1); color: #d5a54b; }
        .sidebar-link.active { background: linear-gradient(135deg, rgba(197,139,43,0.2), rgba(167,112,33,0.15)); color: #d5a54b; border-left: 3px solid #c58b2b; }
        .stat-card { background: linear-gradient(135deg, #1c1c1c, #121212); border: 1px solid rgba(81,81,82,0.4); border-radius: 16px; padding: 20px; }
        .form-input { width: 100%; background: #1c1c1c; border: 1px solid #515152; border-radius: 10px; padding: 10px 14px; color: white; font-size: 14px; outline: none; transition: border-color 0.2s; }
        .form-input:focus { border-color: #c58b2b; }
        .form-input::placeholder { color: #64748b; }
        .btn-gold { background: linear-gradient(135deg, #c58b2b, #a77021); color: #0a0a0a; font-weight: 700; padding: 10px 20px; border-radius: 10px; font-size: 13px; cursor: pointer; transition: opacity 0.2s; border: none; }
        .btn-gold:hover { opacity: 0.9; }
        .btn-outline { background: transparent; border: 1px solid #515152; color: #94a3b8; font-weight: 500; padding: 10px 20px; border-radius: 10px; font-size: 13px; cursor: pointer; transition: all 0.2s; }
        .btn-outline:hover { border-color: #c58b2b; color: #d5a54b; }
        .badge-pending { background: rgba(234,179,8,0.15); color: #eab308; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .badge-confirmed { background: rgba(34,197,94,0.15); color: #22c55e; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .badge-cancelled { background: rgba(239,68,68,0.15); color: #ef4444; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .table-row { border-bottom: 1px solid rgba(81,81,82,0.2); transition: background 0.15s; }
        .table-row:hover { background: rgba(197,139,43,0.04); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
        .fade-in { animation: fadeIn 0.3s ease forwards; }
        #toast { transition: all 0.3s ease; }
        .section-panel { display: none; }
        .section-panel.active { display: block; }
        select.form-input option { background: #1c1c1c; }
    </style>
</head>

<body class="bg-dark-950 text-slate-100 font-sans antialiased">

<!-- ===================== TOAST ===================== -->
<div id="toast" class="fixed bottom-6 right-6 z-[100] hidden max-w-sm">
    <div class="bg-dark-800 border border-gold-500/40 rounded-2xl p-4 flex items-start gap-3 shadow-2xl luxury-shadow">
        <div id="toast-icon" class="mt-0.5 shrink-0"></div>
        <div>
            <p id="toast-title" class="font-semibold text-sm text-white"></p>
            <p id="toast-msg" class="text-xs text-slate-400 mt-0.5"></p>
        </div>
    </div>
</div>

<!-- ===================== MODAL DE LOGIN ===================== -->
<div id="login-modal" class="fixed inset-0 z-50 hidden items-center justify-center modal-blur bg-black/70">
    <div class="bg-dark-900 border border-brand/40 rounded-2xl p-8 w-full max-w-md mx-4 luxury-shadow fade-in">
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="font-serif text-2xl text-white">Acesso ao Sistema</h2>
                <p class="text-xs text-slate-400 mt-1">Entre com suas credenciais para continuar</p>
            </div>
            <button onclick="closeLoginModal()" class="text-slate-500 hover:text-white transition-colors">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>

        <form id="login-form" class="space-y-4">
            <div>
                <label class="text-xs font-semibold text-slate-400 uppercase tracking-wider block mb-2">E-mail</label>
                <input type="email" id="login-email" class="form-input" placeholder="seu@email.com" required>
            </div>
            <div>
                <label class="text-xs font-semibold text-slate-400 uppercase tracking-wider block mb-2">Senha</label>
                <div class="relative">
                    <input type="password" id="login-password" class="form-input pr-10" placeholder="••••••••" required>
                    <button type="button" onclick="togglePasswordVisibility()" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300">
                        <i data-lucide="eye" class="h-4 w-4" id="eye-icon"></i>
                    </button>
                </div>
            </div>
            <div id="login-error" class="hidden bg-red-950/50 border border-red-500/30 rounded-xl p-3 text-xs text-red-400"></div>
            <button type="submit" class="btn-gold w-full flex items-center justify-center gap-2 py-3">
                <span id="login-btn-text">Entrar no Sistema</span>
                <i data-lucide="log-in" class="h-4 w-4"></i>
            </button>
        </form>

        <p class="text-center text-xs text-slate-600 mt-6">
            Acesso restrito a usuários autorizados
        </p>
    </div>
</div>

<!-- ===================== PÁGINA PÚBLICA (LANDING) ===================== -->
<div id="page-public">

    <!-- Header Público -->
    <header class="fixed top-0 left-0 right-0 z-40 bg-dark-900/90 border-b border-brand/20 backdrop-blur-md">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-20">
                <div class="flex items-center gap-3">
                    <img src="https://raw.githubusercontent.com/AiltonRock22/clinica-est-tica/refs/heads/main/logo256.png"
                         alt="Logo Estefani Ferreira" class="h-12 w-12 object-contain drop-shadow-[0_0_8px_rgba(197,139,43,0.3)]"
                         onerror="this.style.display='none'">
                    <div>
                        <span class="font-serif font-bold tracking-widest text-lg text-white block uppercase">Estefani Ferreira</span>
                        <span class="text-[9px] uppercase tracking-[0.25em] text-gold-400 block -mt-1">Estética Avançada</span>
                    </div>
                </div>

                <nav class="hidden md:flex items-center gap-8">
                    <a href="#inicio" class="text-sm font-medium text-slate-300 hover:text-gold-400 transition-colors">Início</a>
                    <a href="#servicos" class="text-sm font-medium text-slate-300 hover:text-gold-400 transition-colors">Serviços</a>
                    <a href="#simulador" class="text-sm font-medium text-slate-300 hover:text-gold-400 transition-colors">Simulador</a>
                    <a href="#contato" class="text-sm font-medium text-slate-300 hover:text-gold-400 transition-colors">Contato</a>
                </nav>

                <div class="flex items-center gap-3">
                    <button onclick="openLoginModal()" class="hidden sm:flex items-center gap-2 px-5 py-2.5 rounded-xl border border-brand text-slate-300 hover:border-gold-500/50 hover:text-gold-400 transition-all text-sm font-medium">
                        <i data-lucide="lock" class="h-4 w-4"></i>
                        Área Administrativa
                    </button>
                    <button onclick="openLoginModal()" class="px-5 py-2.5 rounded-xl btn-gold text-xs uppercase tracking-wider">
                        Agendar Agora
                    </button>
                    <button onclick="toggleMobileMenu()" class="md:hidden p-2 text-slate-400 hover:text-white">
                        <i data-lucide="menu" class="h-6 w-6"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Menu -->
        <div id="mobile-menu" class="hidden md:hidden bg-dark-900 border-t border-brand/20 px-4 py-4 space-y-2">
            <a href="#inicio" onclick="toggleMobileMenu()" class="block py-2 text-sm text-slate-300 hover:text-gold-400">Início</a>
            <a href="#servicos" onclick="toggleMobileMenu()" class="block py-2 text-sm text-slate-300 hover:text-gold-400">Serviços</a>
            <a href="#simulador" onclick="toggleMobileMenu()" class="block py-2 text-sm text-slate-300 hover:text-gold-400">Simulador</a>
            <a href="#contato" onclick="toggleMobileMenu()" class="block py-2 text-sm text-slate-300 hover:text-gold-400">Contato</a>
            <button onclick="openLoginModal(); toggleMobileMenu();" class="block w-full text-left py-2 text-sm text-gold-400 font-medium">Área Administrativa</button>
        </div>
    </header>

    <!-- Hero Section -->
    <section id="inicio" class="pt-20 min-h-screen flex items-center relative overflow-hidden bg-gradient-to-b from-dark-900 via-dark-950 to-dark-950">
        <div class="absolute inset-0 opacity-5">
            <div class="absolute top-20 left-10 w-72 h-72 bg-gold-500 rounded-full blur-3xl"></div>
            <div class="absolute bottom-20 right-10 w-96 h-96 bg-gold-700 rounded-full blur-3xl"></div>
        </div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 relative z-10">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                <div class="space-y-8">
                    <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-dark-900 border border-brand text-xs font-semibold text-slate-300">
                        <span class="relative flex h-2 w-2">
                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-gold-400 opacity-75"></span>
                            <span class="relative inline-flex rounded-full h-2 w-2 bg-gold-500"></span>
                        </span>
                        Agendamentos Disponíveis Hoje
                    </div>
                    <h1 class="font-serif font-bold text-5xl sm:text-6xl text-white leading-tight">
                        A arte de revelar a sua
                        <span class="bg-gradient-to-r from-gold-300 via-gold-400 to-gold-600 bg-clip-text text-transparent block">melhor versão</span>
                    </h1>
                    <p class="text-slate-400 text-lg leading-relaxed max-w-xl">
                        A esteticista <strong class="text-gold-400 font-medium">Estefani Ferreira</strong> une tecnologia avançada e técnicas exclusivas para criar tratamentos luxuosos e personalizados. Descubra uma nova experiência de rejuvenescimento.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4">
                        <button onclick="openLoginModal()" class="btn-gold px-8 py-4 text-sm flex items-center justify-center gap-2 rounded-xl">
                            Marcar uma Consulta
                            <i data-lucide="calendar" class="h-5 w-5"></i>
                        </button>
                        <a href="#servicos" class="btn-outline px-8 py-4 text-sm flex items-center justify-center gap-2 rounded-xl">
                            Ver Tratamentos
                            <i data-lucide="arrow-down" class="h-4 w-4"></i>
                        </a>
                    </div>
                </div>

                <div class="relative">
                    <div class="bg-dark-900 border border-brand/40 rounded-2xl p-6 luxury-shadow">
                        <div class="absolute -top-4 -right-4 h-12 w-12 bg-gold-500 text-dark-950 rounded-full flex items-center justify-center font-bold font-serif text-lg">5★</div>
                        <span class="text-xs uppercase font-semibold text-gold-400 tracking-widest">Serviço em Destaque</span>
                        <h3 class="font-serif text-2xl text-white mt-2 mb-3">Peeling de Diamante com Ácido Hialurônico</h3>
                        <p class="text-sm text-slate-400 leading-relaxed mb-5">Renove a derme, reduza linhas de expressão e ganhe luminosidade imediata na primeira sessão com acompanhamento personalizado.</p>
                        <div class="flex items-center justify-between border-t border-brand/30 pt-4">
                            <div>
                                <span class="text-gold-400 font-bold text-xl">R$ 280,00</span>
                                <span class="text-xs text-slate-500 block">por sessão</span>
                            </div>
                            <button onclick="openLoginModal()" class="btn-gold px-5 py-2.5 text-xs rounded-xl">Reservar</button>
                        </div>
                    </div>

                    <div class="mt-4 grid grid-cols-3 gap-3">
                        <div class="bg-dark-900 border border-brand/30 rounded-xl p-4 text-center">
                            <span class="font-serif text-2xl font-bold text-gold-400 block">500+</span>
                            <span class="text-xs text-slate-500">Clientes</span>
                        </div>
                        <div class="bg-dark-900 border border-brand/30 rounded-xl p-4 text-center">
                            <span class="font-serif text-2xl font-bold text-gold-400 block">8+</span>
                            <span class="text-xs text-slate-500">Anos</span>
                        </div>
                        <div class="bg-dark-900 border border-brand/30 rounded-xl p-4 text-center">
                            <span class="font-serif text-2xl font-bold text-gold-400 block">98%</span>
                            <span class="text-xs text-slate-500">Satisfação</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Serviços Section -->
    <section id="servicos" class="py-24 bg-dark-950">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16 space-y-3">
                <span class="text-gold-400 text-xs font-semibold uppercase tracking-widest">Procedimentos Premium</span>
                <h2 class="font-serif text-4xl sm:text-5xl text-white">Nossos Serviços</h2>
                <p class="text-slate-400 max-w-2xl mx-auto">Cada tratamento é cientificamente projetado para garantir o máximo de eficácia com total segurança.</p>
            </div>
            <div id="public-services-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Serviços carregados do Firebase -->
                <div class="col-span-full text-center py-12 text-slate-500">
                    <i data-lucide="loader" class="h-8 w-8 mx-auto mb-3 animate-spin text-gold-500"></i>
                    <p class="text-sm">Carregando serviços...</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Simulador Section -->
    <section id="simulador" class="py-24 bg-dark-900 border-t border-brand/20">
        <div class="max-w-4xl mx-auto px-4 sm:px-6">
            <div class="text-center mb-12 space-y-3">
                <span class="text-gold-400 text-xs font-semibold uppercase tracking-widest">Calculadora</span>
                <h2 class="font-serif text-3xl text-white">Estime seu Tratamento</h2>
                <p class="text-slate-400 text-sm">Selecione os procedimentos desejados para obter um valor estimado.</p>
            </div>
            <div class="bg-dark-950 border border-brand/30 rounded-2xl p-6 sm:p-8">
                <div id="simulator-services" class="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-6">
                    <p class="text-slate-500 text-sm col-span-full text-center py-4">Carregando serviços...</p>
                </div>
                <div class="bg-dark-900 border border-gold-500/20 rounded-xl p-6 flex flex-col sm:flex-row items-center justify-between gap-4">
                    <div>
                        <span class="text-xs text-slate-400 uppercase font-semibold block mb-1">Total Estimado</span>
                        <span id="simulator-total" class="font-serif text-3xl font-bold text-gold-400">R$ 0,00</span>
                    </div>
                    <button onclick="openLoginModal()" class="btn-gold px-6 py-3 text-xs uppercase tracking-wider rounded-xl w-full sm:w-auto">
                        Agendar Agora
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Contato Section -->
    <section id="contato" class="py-24 bg-dark-950 border-t border-brand/20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                <div class="space-y-6">
                    <span class="text-gold-400 text-xs font-semibold uppercase tracking-widest">Fale Conosco</span>
                    <h2 class="font-serif text-4xl text-white">Entre em Contato</h2>
                    <p class="text-slate-400 leading-relaxed">Estamos prontos para atendê-la com todo o cuidado e atenção que você merece. Agende sua consulta ou tire suas dúvidas.</p>
                    <div class="space-y-4">
                        <div class="flex items-center gap-4">
                            <div class="h-10 w-10 bg-dark-900 border border-brand/40 rounded-xl flex items-center justify-center text-gold-400">
                                <i data-lucide="phone" class="h-5 w-5"></i>
                            </div>
                            <div>
                                <p class="text-xs text-slate-500 uppercase font-semibold">WhatsApp</p>
                                <p class="text-white font-medium">(11) 99999-9999</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-4">
                            <div class="h-10 w-10 bg-dark-900 border border-brand/40 rounded-xl flex items-center justify-center text-gold-400">
                                <i data-lucide="instagram" class="h-5 w-5"></i>
                            </div>
                            <div>
                                <p class="text-xs text-slate-500 uppercase font-semibold">Instagram</p>
                                <p class="text-white font-medium">@estefaniferreira.estetica</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-4">
                            <div class="h-10 w-10 bg-dark-900 border border-brand/40 rounded-xl flex items-center justify-center text-gold-400">
                                <i data-lucide="map-pin" class="h-5 w-5"></i>
                            </div>
                            <div>
                                <p class="text-xs text-slate-500 uppercase font-semibold">Endereço</p>
                                <p class="text-white font-medium">Rua das Flores, 123 — São Paulo, SP</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-4">
                            <div class="h-10 w-10 bg-dark-900 border border-brand/40 rounded-xl flex items-center justify-center text-gold-400">
                                <i data-lucide="clock" class="h-5 w-5"></i>
                            </div>
                            <div>
                                <p class="text-xs text-slate-500 uppercase font-semibold">Horário</p>
                                <p class="text-white font-medium">Seg–Sex: 9h–19h | Sáb: 9h–14h</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-dark-900 border border-brand/30 rounded-2xl p-8 luxury-shadow">
                    <h3 class="font-serif text-2xl text-white mb-6">Solicite um Agendamento</h3>
                    <div class="space-y-4">
                        <input type="text" class="form-input" placeholder="Seu nome completo">
                        <input type="tel" class="form-input" placeholder="Seu WhatsApp">
                        <select class="form-input">
                            <option value="">Selecione um serviço</option>
                            <option>Limpeza de Pele</option>
                            <option>Peeling Químico</option>
                            <option>Massagem Modeladora</option>
                        </select>
                        <textarea class="form-input" rows="3" placeholder="Mensagem ou observações (opcional)"></textarea>
                        <button onclick="openLoginModal()" class="btn-gold w-full py-3 rounded-xl">
                            Enviar Solicitação
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark-950 border-t border-brand/20 py-10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center space-y-4">
            <img src="https://raw.githubusercontent.com/AiltonRock22/clinica-est-tica/refs/heads/main/logo256.png"
                 alt="Logo" class="h-12 w-12 mx-auto object-contain opacity-60 hover:opacity-100 transition-all grayscale hover:grayscale-0"
                 onerror="this.style.display='none'">
            <p class="font-serif text-gold-500 tracking-widest uppercase text-xs">Estética Estefani Ferreira</p>
            <p class="text-xs text-slate-600">© 2026 Estética Estefani Ferreira. Todos os direitos reservados.</p>
        </div>
    </footer>

</div><!-- /page-public -->


<!-- ===================== PAINEL ADMINISTRATIVO ===================== -->
<div id="page-admin" class="hidden min-h-screen flex">

    <!-- Sidebar -->
    <aside id="sidebar" class="w-64 bg-dark-900 border-r border-brand/20 flex flex-col fixed top-0 left-0 h-full z-30 transition-transform duration-300">
        <!-- Logo -->
        <div class="p-6 border-b border-brand/20">
            <div class="flex items-center gap-3">
                <img src="https://raw.githubusercontent.com/AiltonRock22/clinica-est-tica/refs/heads/main/logo256.png"
                     alt="Logo" class="h-10 w-10 object-contain drop-shadow-[0_0_6px_rgba(197,139,43,0.3)]"
                     onerror="this.style.display='none'">
                <div>
                    <span class="font-serif font-bold text-sm text-white block">Estefani Ferreira</span>
                    <span class="text-[10px] text-gold-400 uppercase tracking-widest">Painel Admin</span>
                </div>
            </div>
        </div>

        <!-- Nav Links -->
        <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
            <button onclick="showSection('dashboard')" class="sidebar-link active w-full text-left" id="nav-dashboard">
                <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                Dashboard
            </button>
            <button onclick="showSection('agendamentos')" class="sidebar-link w-full text-left" id="nav-agendamentos">
                <i data-lucide="calendar" class="h-4 w-4 shrink-0"></i>
                Agendamentos
            </button>
            <button onclick="showSection('clientes')" class="sidebar-link w-full text-left" id="nav-clientes">
                <i data-lucide="users" class="h-4 w-4 shrink-0"></i>
                Clientes
            </button>
            <button onclick="showSection('aniversarios')" class="sidebar-link w-full text-left" id="nav-aniversarios">
                <i data-lucide="cake" class="h-4 w-4 shrink-0"></i>
                Aniversários
            </button>
            <button onclick="showSection('servicos')" class="sidebar-link w-full text-left" id="nav-servicos">
                <i data-lucide="sparkles" class="h-4 w-4 shrink-0"></i>
                Serviços
            </button>
            <button onclick="showSection('produtos')" class="sidebar-link w-full text-left" id="nav-produtos">
                <i data-lucide="package" class="h-4 w-4 shrink-0"></i>
                Produtos / Estoque
            </button>
            <button onclick="showSection('vendas')" class="sidebar-link w-full text-left" id="nav-vendas">
                <i data-lucide="shopping-cart" class="h-4 w-4 shrink-0"></i>
                Ponto de Venda
            </button>
            <button onclick="showSection('relatorios')" class="sidebar-link w-full text-left" id="nav-relatorios">
                <i data-lucide="bar-chart-2" class="h-4 w-4 shrink-0"></i>
                Relatórios
            </button>
        </nav>

        <!-- User Info + Logout -->
        <div class="p-4 border-t border-brand/20">
            <div class="flex items-center gap-3 mb-3">
                <div class="h-9 w-9 rounded-full bg-gradient-to-br from-gold-500 to-gold-700 flex items-center justify-center font-bold text-dark-950 text-sm" id="admin-avatar">E</div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-white truncate" id="admin-name">Estefani</p>
                    <p class="text-xs text-slate-500 truncate" id="admin-email">admin@email.com</p>
                </div>
            </div>
            <button onclick="doLogout()" class="btn-outline w-full flex items-center justify-center gap-2 text-xs py-2">
                <i data-lucide="log-out" class="h-3.5 w-3.5"></i>
                Sair
            </button>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 ml-64 flex flex-col min-h-screen">

        <!-- Top Bar -->
        <header class="bg-dark-900/80 border-b border-brand/20 backdrop-blur-md sticky top-0 z-20 px-6 py-4 flex items-center justify-between">
            <div>
                <h1 id="page-title" class="font-serif text-xl text-white">Dashboard</h1>
                <p id="page-subtitle" class="text-xs text-slate-500 mt-0.5">Visão geral do sistema</p>
            </div>
            <div class="flex items-center gap-3">
                <span class="text-xs text-slate-500" id="current-date"></span>
                <button onclick="doLogout()" class="sm:hidden btn-outline text-xs px-3 py-2">Sair</button>
            </div>
        </header>

        <!-- Content Area -->
        <main class="flex-1 p-6 overflow-y-auto">

            <!-- ===== DASHBOARD ===== -->
            <div id="section-dashboard" class="section-panel active fade-in">
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
                    <div class="stat-card">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-xs text-slate-500 uppercase font-semibold">Agendamentos</span>
                            <i data-lucide="calendar" class="h-4 w-4 text-gold-400"></i>
                        </div>
                        <p class="font-serif text-3xl font-bold text-white" id="stat-total-appts">0</p>
                        <p class="text-xs text-slate-500 mt-1">Total registrado</p>
                    </div>
                    <div class="stat-card">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-xs text-slate-500 uppercase font-semibold">Receita</span>
                            <i data-lucide="trending-up" class="h-4 w-4 text-gold-400"></i>
                        </div>
                        <p class="font-serif text-2xl font-bold text-white" id="stat-revenue">R$ 0,00</p>
                        <p class="text-xs text-slate-500 mt-1">Serviços confirmados</p>
                    </div>
                    <div class="stat-card">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-xs text-slate-500 uppercase font-semibold">Estoque Baixo</span>
                            <i data-lucide="alert-triangle" class="h-4 w-4 text-amber-400"></i>
                        </div>
                        <p class="font-serif text-3xl font-bold text-white" id="stat-low-stock">0</p>
                        <p class="text-xs text-slate-500 mt-1">Produtos críticos</p>
                    </div>
                    <div class="stat-card">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-xs text-slate-500 uppercase font-semibold">Aniversários</span>
                            <i data-lucide="cake" class="h-4 w-4 text-gold-400"></i>
                        </div>
                        <p class="font-serif text-3xl font-bold text-white" id="stat-birthdays">0</p>
                        <p class="text-xs text-slate-500 mt-1">Cadastrados</p>
                    </div>
                </div>

                <!-- Gráficos de Vendas -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="bar-chart-2" class="h-4 w-4 text-gold-400"></i>
                            Faturamento (Últimos 12 Meses)
                        </h3>
                        <canvas id="chart-revenue-12m" style="max-height: 250px;"></canvas>
                    </div>
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="line-chart" class="h-4 w-4 text-gold-400"></i>
                            Comparativo: Este Mês vs Mês Anterior
                        </h3>
                        <canvas id="chart-revenue-comparison" style="max-height: 250px;"></canvas>
                    </div>
                </div>

                <!-- Próximos Agendamentos -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="calendar-clock" class="h-4 w-4 text-gold-400"></i>
                            Próximos Agendamentos
                        </h3>
                        <div id="dash-upcoming-appts" class="space-y-3">
                            <p class="text-slate-500 text-sm">Nenhum agendamento.</p>
                        </div>
                    </div>
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="cake" class="h-4 w-4 text-gold-400"></i>
                            Próximos Aniversariantes
                        </h3>
                        <div id="dash-birthdays" class="space-y-3">
                            <p class="text-slate-500 text-sm">Nenhum aniversariante.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== AGENDAMENTOS ===== -->
            <div id="section-agendamentos" class="section-panel fade-in">
                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="plus-circle" class="h-4 w-4 text-gold-400"></i>
                        Novo Agendamento
                    </h3>
                    <form id="form-new-appt" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Cliente</label>
                            <select id="appt-client-select" class="form-input" onchange="populateApptClientData()">
                                <option value="">Selecione um cliente</option>
                            </select>
                            <small class="text-slate-500 text-xs mt-1 block">Ou preencha manualmente abaixo</small>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Nome (manual)</label>
                            <input type="text" id="appt-client" class="form-input" placeholder="Nome do cliente" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">E-mail</label>
                            <input type="email" id="appt-email" class="form-input" placeholder="email@exemplo.com">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Telefone</label>
                            <input type="tel" id="appt-phone" class="form-input" placeholder="(11) 99999-9999">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Serviço</label>
                            <select id="appt-service" class="form-input" required>
                                <option value="">Selecione um serviço</option>
                            </select>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Data</label>
                            <input type="date" id="appt-date" class="form-input" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Horário</label>
                            <input type="time" id="appt-time" class="form-input" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Profissional</label>
                            <input type="text" id="appt-professional" class="form-input" value="Estefani Ferreira">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Observações</label>
                            <input type="text" id="appt-notes" class="form-input" placeholder="Observações opcionais">
                        </div>
                        <div class="flex items-end">
                            <button type="submit" class="btn-gold w-full py-2.5 flex items-center justify-center gap-2">
                                <i data-lucide="plus" class="h-4 w-4"></i>
                                Agendar
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Filtros -->
                <div class="flex flex-wrap gap-3 mb-4">
                    <input type="text" id="appt-search" class="form-input max-w-xs" placeholder="Buscar por cliente ou serviço..." oninput="renderAppointments()">
                    <select id="appt-filter-status" class="form-input max-w-xs" onchange="renderAppointments()">
                        <option value="">Todos os status</option>
                        <option value="Pendente">Pendente</option>
                        <option value="Confirmado">Confirmado</option>
                        <option value="Cancelado">Cancelado</option>
                    </select>
                </div>

                <div class="bg-dark-900 border border-brand/20 rounded-2xl overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead>
                                <tr class="border-b border-brand/20">
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Cliente</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Serviço</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Data / Hora</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Valor</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Status</th>
                                    <th class="text-right p-4 text-xs font-semibold text-slate-400 uppercase">Ações</th>
                                </tr>
                            </thead>
                            <tbody id="appt-table-body">
                                <tr><td colspan="6" class="p-8 text-center text-slate-500 text-sm">Nenhum agendamento encontrado.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== CLIENTES ===== -->
            <div id="section-clientes" class="section-panel fade-in">
                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="user-plus" class="h-4 w-4 text-gold-400"></i>
                        Cadastrar Cliente
                    </h3>
                    <form id="form-new-client" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Nome Completo</label>
                            <input type="text" id="client-name" class="form-input" placeholder="Nome do cliente" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">E-mail</label>
                            <input type="email" id="client-email" class="form-input" placeholder="email@exemplo.com">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Telefone / WhatsApp</label>
                            <input type="tel" id="client-phone" class="form-input" placeholder="(11) 99999-9999">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Data de Nascimento</label>
                            <input type="date" id="client-birthday" class="form-input">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Cidade</label>
                            <input type="text" id="client-city" class="form-input" placeholder="São Paulo">
                        </div>
                        <div class="flex items-end">
                            <button type="submit" class="btn-gold w-full py-2.5 flex items-center justify-center gap-2">
                                <i data-lucide="user-plus" class="h-4 w-4"></i>
                                Cadastrar
                            </button>
                        </div>
                    </form>
                </div>

                <div class="flex gap-3 mb-4">
                    <input type="text" id="client-search" class="form-input max-w-xs" placeholder="Buscar cliente..." oninput="renderClients()">
                </div>

                <div class="bg-dark-900 border border-brand/20 rounded-2xl overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead>
                                <tr class="border-b border-brand/20">
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Nome</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Contato</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Nascimento</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Cidade</th>
                                    <th class="text-right p-4 text-xs font-semibold text-slate-400 uppercase">Ações</th>
                                </tr>
                            </thead>
                            <tbody id="clients-table-body">
                                <tr><td colspan="5" class="p-8 text-center text-slate-500 text-sm">Nenhum cliente cadastrado.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== ANIVERSÁRIOS ===== -->
            <div id="section-aniversarios" class="section-panel fade-in">
                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="cake" class="h-4 w-4 text-gold-400"></i>
                        Adicionar Aniversariante
                    </h3>
                    <form id="form-new-birthday" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Cliente</label>
                            <select id="bday-client-select" class="form-input" onchange="populateBirthdayClientData()">
                                <option value="">Selecione um cliente</option>
                            </select>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Nome</label>
                            <input type="text" id="bday-name" class="form-input" placeholder="Nome do cliente" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Data de Nascimento</label>
                            <input type="date" id="bday-date" class="form-input" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Telefone</label>
                            <input type="tel" id="bday-phone" class="form-input" placeholder="(11) 99999-9999">
                        </div>
                        <div class="flex items-end">
                            <button type="submit" class="btn-gold w-full py-2.5 flex items-center justify-center gap-2">
                                <i data-lucide="plus" class="h-4 w-4"></i>
                                Adicionar
                            </button>
                        </div>
                    </form>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="gift" class="h-4 w-4 text-gold-400"></i>
                            Aniversariantes do Mês Atual
                        </h3>
                        <div id="bday-this-month" class="space-y-3">
                            <p class="text-slate-500 text-sm">Nenhum aniversariante este mês.</p>
                        </div>
                    </div>
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="list" class="h-4 w-4 text-gold-400"></i>
                            Todos os Aniversariantes
                        </h3>
                        <div id="bday-all-list" class="space-y-2 max-h-96 overflow-y-auto">
                            <p class="text-slate-500 text-sm">Nenhum aniversariante cadastrado.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== SERVIÇOS ===== -->
            <div id="section-servicos" class="section-panel fade-in">
                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="plus-circle" class="h-4 w-4 text-gold-400"></i>
                        Novo Serviço / Procedimento
                    </h3>
                    <form id="form-new-service" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Nome do Serviço</label>
                            <input type="text" id="svc-name" class="form-input" placeholder="Ex: Limpeza de Pele" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Preço (R$)</label>
                            <input type="number" id="svc-price" class="form-input" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Duração (min)</label>
                            <input type="number" id="svc-duration" class="form-input" placeholder="60" min="1">
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Descrição</label>
                            <input type="text" id="svc-desc" class="form-input" placeholder="Breve descrição">
                        </div>
                        <div class="sm:col-span-2 lg:col-span-4 flex justify-end">
                            <button type="submit" class="btn-gold px-6 py-2.5 flex items-center gap-2">
                                <i data-lucide="plus" class="h-4 w-4"></i>
                                Adicionar Serviço
                            </button>
                        </div>
                    </form>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4" id="services-grid">
                    <p class="text-slate-500 text-sm col-span-full">Nenhum serviço cadastrado.</p>
                </div>
            </div>

            <!-- ===== PRODUTOS / ESTOQUE ===== -->
            <div id="section-produtos" class="section-panel fade-in">
                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="package-plus" class="h-4 w-4 text-gold-400"></i>
                        Adicionar Produto
                    </h3>
                    <form id="form-new-product" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Nome do Produto</label>
                            <input type="text" id="prod-name" class="form-input" placeholder="Ex: Creme Facial" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Preço (R$)</label>
                            <input type="number" id="prod-price" class="form-input" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Estoque Inicial</label>
                            <input type="number" id="prod-stock" class="form-input" placeholder="10" min="0" required>
                        </div>
                        <div>
                            <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Estoque Mínimo</label>
                            <input type="number" id="prod-min-stock" class="form-input" placeholder="5" min="0">
                        </div>
                        <div class="sm:col-span-2 lg:col-span-4 flex justify-end">
                            <button type="submit" class="btn-gold px-6 py-2.5 flex items-center gap-2">
                                <i data-lucide="plus" class="h-4 w-4"></i>
                                Adicionar Produto
                            </button>
                        </div>
                    </form>
                </div>

                <div class="bg-dark-900 border border-brand/20 rounded-2xl overflow-hidden mb-6">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead>
                                <tr class="border-b border-brand/20">
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Produto</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Preço</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Estoque</th>
                                    <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Status</th>
                                    <th class="text-right p-4 text-xs font-semibold text-slate-400 uppercase">Ações</th>
                                </tr>
                            </thead>
                            <tbody id="products-table-body">
                                <tr><td colspan="5" class="p-8 text-center text-slate-500 text-sm">Nenhum produto cadastrado.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                    <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                        <i data-lucide="archive" class="h-4 w-4 text-slate-400"></i>
                        Produtos Inativos
                    </h3>
                    <div class="bg-dark-950 border border-brand/10 rounded-lg overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead>
                                    <tr class="border-b border-brand/20">
                                        <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Produto</th>
                                        <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Preço</th>
                                        <th class="text-left p-4 text-xs font-semibold text-slate-400 uppercase">Estoque</th>
                                        <th class="text-right p-4 text-xs font-semibold text-slate-400 uppercase">Ações</th>
                                    </tr>
                                </thead>
                                <tbody id="products-inactive-body">
                                    <tr><td colspan="4" class="p-8 text-center text-slate-500 text-sm">Nenhum produto inativo.</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== PONTO DE VENDA ===== -->
            <div id="section-vendas" class="section-panel fade-in">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="shopping-cart" class="h-4 w-4 text-gold-400"></i>
                            Registrar Venda
                        </h3>
                        <form id="form-new-sale" class="space-y-4">
                            <div>
                                <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Produto</label>
                                <select id="sale-product" class="form-input" required>
                                    <option value="">Selecione um produto</option>
                                </select>
                            </div>
                            <div>
                                <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Quantidade</label>
                                <input type="number" id="sale-qty" class="form-input" value="1" min="1" required>
                            </div>
                            <div>
                                <label class="text-xs text-slate-400 uppercase font-semibold block mb-2">Cliente (opcional)</label>
                                <input type="text" id="sale-client" class="form-input" placeholder="Nome do cliente">
                            </div>
                            <div class="bg-dark-950 border border-gold-500/20 rounded-xl p-4">
                                <span class="text-xs text-slate-400 uppercase font-semibold block mb-1">Total da Venda</span>
                                <span id="sale-total-preview" class="font-serif text-2xl font-bold text-gold-400">R$ 0,00</span>
                            </div>
                            <button type="submit" class="btn-gold w-full py-3 flex items-center justify-center gap-2">
                                <i data-lucide="check" class="h-4 w-4"></i>
                                Confirmar Venda
                            </button>
                        </form>
                    </div>

                    <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6">
                        <h3 class="font-semibold text-white mb-4 flex items-center gap-2">
                            <i data-lucide="receipt" class="h-4 w-4 text-gold-400"></i>
                            Últimas Vendas
                        </h3>
                        <div id="sales-list" class="space-y-3 max-h-96 overflow-y-auto">
                            <p class="text-slate-500 text-sm">Nenhuma venda registrada.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== RELATÓRIOS ===== -->
            <div id="section-relatorios" class="section-panel fade-in">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
                    <div class="stat-card lg:col-span-1">
                        <span class="text-xs text-slate-500 uppercase font-semibold block mb-2">Receita Total</span>
                        <p class="font-serif text-3xl font-bold text-gold-400" id="rep-total-revenue">R$ 0,00</p>
                        <p class="text-xs text-slate-500 mt-1">Serviços + Vendas</p>
                    </div>
                    <div class="stat-card lg:col-span-1">
                        <span class="text-xs text-slate-500 uppercase font-semibold block mb-2">Serviços Confirmados</span>
                        <p class="font-serif text-3xl font-bold text-white" id="rep-confirmed-appts">0</p>
                        <p class="text-xs text-slate-500 mt-1">Total confirmados</p>
                    </div>
                    <div class="stat-card lg:col-span-1">
                        <span class="text-xs text-slate-500 uppercase font-semibold block mb-2">Vendas Realizadas</span>
                        <p class="font-serif text-3xl font-bold text-white" id="rep-total-sales">0</p>
                        <p class="text-xs text-slate-500 mt-1">Produtos vendidos</p>
                    </div>
                </div>

                <div class="bg-dark-900 border border-brand/20 rounded-2xl p-6 mb-6">
                    <h3 class="font-semibold text-white mb-4">Serviços Mais Agendados</h3>
                    <div id="rep-top-services" class="space-y-3">
                        <p class="text-slate-500 text-sm">Nenhum dado disponível.</p>
                    </div>
                </div>

                <div class="flex flex-wrap gap-3">
                    <button onclick="generatePDF()" class="btn-gold flex items-center gap-2 px-6 py-3">
                        <i data-lucide="file-text" class="h-4 w-4"></i>
                        Exportar Relatório PDF
                    </button>
                </div>
            </div>

        </main>
    </div>
</div><!-- /page-admin -->

<!-- Modal de Confirmação de Exclusão -->
<div id="delete-modal" class="fixed inset-0 z-50 hidden items-center justify-center modal-blur bg-black/70">
    <div class="bg-dark-900 border border-red-500/30 rounded-2xl p-6 w-full max-w-sm mx-4 fade-in">
        <div class="flex items-center gap-3 mb-4">
            <div class="h-10 w-10 bg-red-950/50 rounded-xl flex items-center justify-center">
                <i data-lucide="trash-2" class="h-5 w-5 text-red-400"></i>
            </div>
            <div>
                <h3 class="font-semibold text-white">Confirmar Exclusão</h3>
                <p class="text-xs text-slate-400" id="delete-modal-msg">Tem certeza que deseja excluir?</p>
            </div>
        </div>
        <div class="flex gap-3">
            <button onclick="closeDeleteModal()" class="btn-outline flex-1 py-2.5">Cancelar</button>
            <button id="delete-confirm-btn" class="flex-1 py-2.5 bg-red-600 hover:bg-red-500 text-white font-semibold rounded-xl text-sm transition-colors">Excluir</button>
        </div>
    </div>
</div>

<!-- ===================== SCRIPTS ===================== -->
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-app.js";
    import {
        getAuth, signInWithEmailAndPassword, signOut, onAuthStateChanged
    } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-auth.js";
    import {
        getFirestore, collection, addDoc, getDocs, doc, updateDoc, deleteDoc,
        onSnapshot, query, orderBy, where, serverTimestamp
    } from "https://www.gstatic.com/firebasejs/12.13.0/firebase-firestore.js";

    // ─── FIREBASE CONFIG ────────────────────────────────────────────────────────
    const firebaseConfig = {
        apiKey: "AIzaSyD20OPUFet_4C_s2o-AM5S2ckYYy-S1ga4",
        authDomain: "esteticistaestefani.firebaseapp.com",
        projectId: "esteticistaestefani",
        storageBucket: "esteticistaestefani.firebasestorage.app",
        messagingSenderId: "196912865507",
        appId: "1:196912865507:web:f89be4219b5f89cb4c25d6",
        measurementId: "G-HL857XX51P"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    const db = getFirestore(app);

    // Coleções do Firestore
    const cols = {
        appointments: collection(db, 'appointments'),
        clients:      collection(db, 'clients'),
        birthdays:    collection(db, 'birthdays'),
        services:     collection(db, 'services'),
        products:     collection(db, 'products'),
        sales:        collection(db, 'sales'),
    };

    // ─── STATE ──────────────────────────────────────────────────────────────────
    let state = {
        user: null,
        appointments: [],
        clients: [],
        birthdays: [],
        services: [],
        products: [],
        sales: [],
        unsubs: [],
        deleteCallback: null,
    };

    // ─── HELPERS ────────────────────────────────────────────────────────────────
    function fmt(val) {
        return 'R$ ' + Number(val || 0).toFixed(2).replace('.', ',');
    }

    function fmtDate(dateStr) {
        if (!dateStr) return '—';
        const [y, m, d] = dateStr.split('-');
        return `${d}/${m}/${y}`;
    }

    function monthName(n) {
        const months = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'];
        return months[n] || '';
    }

    window.showToast = function(title, msg, type = 'success') {
        const toast = document.getElementById('toast');
        const icons = { success: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>', error: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>', info: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gold-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>' };
        document.getElementById('toast-icon').innerHTML = icons[type] || icons.info;
        document.getElementById('toast-title').textContent = title;
        document.getElementById('toast-msg').textContent = msg;
        toast.classList.remove('hidden');
        clearTimeout(toast._timer);
        toast._timer = setTimeout(() => toast.classList.add('hidden'), 4000);
    };

    // ─── AUTH ───────────────────────────────────────────────────────────────────
    window.openLoginModal = function() {
        const m = document.getElementById('login-modal');
        m.classList.remove('hidden');
        m.classList.add('flex');
        lucide.createIcons();
    };

    window.closeLoginModal = function() {
        const m = document.getElementById('login-modal');
        m.classList.add('hidden');
        m.classList.remove('flex');
        document.getElementById('login-error').classList.add('hidden');
    };

    window.togglePasswordVisibility = function() {
        const input = document.getElementById('login-password');
        const icon = document.getElementById('eye-icon');
        if (input.type === 'password') {
            input.type = 'text';
            icon.setAttribute('data-lucide', 'eye-off');
        } else {
            input.type = 'password';
            icon.setAttribute('data-lucide', 'eye');
        }
        lucide.createIcons();
    };

    document.getElementById('login-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = document.getElementById('login-email').value.trim();
        const password = document.getElementById('login-password').value;
        const btnText = document.getElementById('login-btn-text');
        const errDiv = document.getElementById('login-error');

        btnText.textContent = 'Entrando...';
        errDiv.classList.add('hidden');

        try {
            await signInWithEmailAndPassword(auth, email, password);
            closeLoginModal();
            showToast('Bem-vindo(a)!', 'Login realizado com sucesso.', 'success');
        } catch (err) {
            const msgs = {
                'auth/user-not-found': 'Usuário não encontrado.',
                'auth/wrong-password': 'Senha incorreta.',
                'auth/invalid-email': 'E-mail inválido.',
                'auth/invalid-credential': 'Credenciais inválidas. Verifique e-mail e senha.',
                'auth/too-many-requests': 'Muitas tentativas. Tente novamente mais tarde.',
            };
            errDiv.textContent = msgs[err.code] || 'Erro ao fazer login. Tente novamente.';
            errDiv.classList.remove('hidden');
        } finally {
            btnText.textContent = 'Entrar no Sistema';
        }
    });

    window.doLogout = async function() {
        state.unsubs.forEach(u => u && u());
        state.unsubs = [];
        await signOut(auth);
        showToast('Até logo!', 'Sessão encerrada com sucesso.', 'info');
    };

    // ─── AUTH STATE OBSERVER ────────────────────────────────────────────────────
    onAuthStateChanged(auth, (user) => {
        if (user) {
            state.user = user;
            document.getElementById('admin-name').textContent = user.displayName || user.email.split('@')[0];
            document.getElementById('admin-email').textContent = user.email;
            document.getElementById('admin-avatar').textContent = (user.displayName || user.email).charAt(0).toUpperCase();

            document.getElementById('page-public').classList.add('hidden');
            document.getElementById('page-admin').classList.remove('hidden');

            document.getElementById('current-date').textContent = new Date().toLocaleDateString('pt-BR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

            setupRealtimeListeners();
            seedInitialData();
            lucide.createIcons();
        } else {
            state.user = null;
            document.getElementById('page-public').classList.remove('hidden');
            document.getElementById('page-admin').classList.add('hidden');
            loadPublicServices();
            lucide.createIcons();
        }
    });

    // ─── REALTIME LISTENERS ─────────────────────────────────────────────────────
    function setupRealtimeListeners() {
        state.unsubs.forEach(u => u && u());
        state.unsubs = [];

        state.unsubs.push(onSnapshot(cols.appointments, snap => {
            state.appointments = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderAppointments();
            updateDashboard();
            updateReports();
        }));

        state.unsubs.push(onSnapshot(cols.clients, snap => {
            state.clients = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderClients();
            updateClientSelectors();
        }));

        state.unsubs.push(onSnapshot(cols.birthdays, snap => {
            state.birthdays = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderBirthdays();
            updateDashboard();
        }));

        state.unsubs.push(onSnapshot(cols.services, snap => {
            state.services = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderServices();
            updateServiceDropdowns();
            loadPublicServices();
        }));

        state.unsubs.push(onSnapshot(cols.products, snap => {
            state.products = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderProducts();
            updateProductDropdown();
            updateDashboard();
        }));

        state.unsubs.push(onSnapshot(cols.sales, snap => {
            state.sales = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            renderSales();
            updateReports();
        }));
    }

    // ─── SEED INICIAL ───────────────────────────────────────────────────────────
    async function seedInitialData() {
        const svcSnap = await getDocs(cols.services);
        if (svcSnap.empty) {
            await addDoc(cols.services, { name: "Limpeza de Pele Profunda", price: 120, duration: 60, desc: "Remoção completa de impurezas com vapor de ozônio e extração manual." });
            await addDoc(cols.services, { name: "Peeling Químico Revitalizante", price: 180, duration: 45, desc: "Tratamento para manchas e renovação celular profunda." });
            await addDoc(cols.services, { name: "Massagem Modeladora Premium", price: 160, duration: 75, desc: "Massagem modeladora de silhueta corporal com óleos ativos." });
            await addDoc(cols.services, { name: "Peeling de Diamante", price: 280, duration: 90, desc: "Esfoliação mecânica com ácido hialurônico para luminosidade imediata." });
        }

        const prodSnap = await getDocs(cols.products);
        if (prodSnap.empty) {
            await addDoc(cols.products, { name: "Creme Facial Rejuvenescedor", price: 89, stock: 12, minStock: 5 });
            await addDoc(cols.products, { name: "Sérum Ácido Hialurônico", price: 110, stock: 3, minStock: 5 });
            await addDoc(cols.products, { name: "Máscara Purificante de Algas", price: 65, stock: 20, minStock: 4 });
        }
    }

    // ─── GRÁFICOS DE VENDAS ─────────────────────────────────────────────────────────
    let chartRevenue12m = null;
    let chartRevenueComparison = null;

    window.generateCharts = function() {
        generateRevenue12mChart();
        generateRevenueComparisonChart();
    };

    function generateRevenue12mChart() {
        const now = new Date();
        const months = [];
        const revenues = [];

        for (let i = 11; i >= 0; i--) {
            const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const monthName = d.toLocaleString('pt-BR', { month: 'short', year: '2-digit' });
            months.push(monthName);

            const monthStart = new Date(d.getFullYear(), d.getMonth(), 1);
            const monthEnd = new Date(d.getFullYear(), d.getMonth() + 1, 0);
            const monthRevenue = state.appointments
                .filter(a => a.status === 'Confirmado' && new Date(a.date) >= monthStart && new Date(a.date) <= monthEnd)
                .reduce((s, a) => s + (a.price || 0), 0);
            revenues.push(monthRevenue);
        }

        const ctx = document.getElementById('chart-revenue-12m');
        if (!ctx) return;

        if (chartRevenue12m) chartRevenue12m.destroy();
        chartRevenue12m = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: months,
                datasets: [{
                    label: 'Faturamento (R\$)',
                    data: revenues,
                    backgroundColor: 'rgba(197, 139, 43, 0.7)',
                    borderColor: 'rgba(197, 139, 43, 1)',
                    borderWidth: 2,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { color: '#94a3b8', callback: (v) => 'R\$ ' + v.toLocaleString('pt-BR') },
                        grid: { color: 'rgba(81, 81, 82, 0.2)' }
                    },
                    x: { ticks: { color: '#94a3b8' }, grid: { display: false } }
                }
            }
        });
    }

    function generateRevenueComparisonChart() {
        const now = new Date();
        const currentMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        const lastMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);

        const currentRevenue = state.appointments
            .filter(a => a.status === 'Confirmado' && new Date(a.date) >= currentMonth && new Date(a.date) <= now)
            .reduce((s, a) => s + (a.price || 0), 0);

        const lastRevenue = state.appointments
            .filter(a => a.status === 'Confirmado' && new Date(a.date) >= lastMonth && new Date(a.date) <= lastMonthEnd)
            .reduce((s, a) => s + (a.price || 0), 0);

        const ctx = document.getElementById('chart-revenue-comparison');
        if (!ctx) return;

        if (chartRevenueComparison) chartRevenueComparison.destroy();
        chartRevenueComparison = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mês Anterior', 'Este Mês'],
                datasets: [{
                    label: 'Faturamento (R\$)',
                    data: [lastRevenue, currentRevenue],
                    borderColor: 'rgba(197, 139, 43, 1)',
                    backgroundColor: 'rgba(197, 139, 43, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 6,
                    pointBackgroundColor: 'rgba(197, 139, 43, 1)',
                    pointBorderColor: '#0a0a0a',
                    pointBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { color: '#94a3b8', callback: (v) => 'R\$ ' + v.toLocaleString('pt-BR') },
                        grid: { color: 'rgba(81, 81, 82, 0.2)' }
                    },
                    x: { ticks: { color: '#94a3b8' }, grid: { display: false } }
                }
            }
        });
    }

    // ─── DASHBOARD ──────────────────────────────────────────────────────────────
    function updateDashboard() {
        document.getElementById('stat-total-appts').textContent = state.appointments.length;

        const revenue = state.appointments
            .filter(a => a.status === 'Confirmado')
            .reduce((s, a) => s + (a.price || 0), 0);
        document.getElementById('stat-revenue').textContent = fmt(revenue);

        const lowStock = state.products.filter(p => (p.stock || 0) <= (p.minStock || 5)).length;
        document.getElementById('stat-low-stock').textContent = lowStock;

        document.getElementById('stat-birthdays').textContent = state.birthdays.length;

        generateCharts();

        // Próximos agendamentos
        const upcoming = [...state.appointments]
            .filter(a => a.date >= new Date().toISOString().split('T')[0])
            .sort((a, b) => a.date.localeCompare(b.date))
            .slice(0, 4);

        const upcomingEl = document.getElementById('dash-upcoming-appts');
        if (upcoming.length === 0) {
            upcomingEl.innerHTML = '<p class="text-slate-500 text-sm">Nenhum agendamento futuro.</p>';
        } else {
            upcomingEl.innerHTML = upcoming.map(a => `
                <div class="flex items-center justify-between p-3 bg-dark-950 border border-brand/15 rounded-xl">
                    <div>
                        <p class="text-sm font-semibold text-white">${a.client}</p>
                        <p class="text-xs text-slate-400">${a.service} — ${fmtDate(a.date)} às ${a.time || '—'}</p>
                    </div>
                    <span class="${a.status === 'Confirmado' ? 'badge-confirmed' : a.status === 'Cancelado' ? 'badge-cancelled' : 'badge-pending'}">${a.status || 'Pendente'}</span>
                </div>
            `).join('');
        }

        // Aniversariantes do mês
        const thisMonth = new Date().getMonth() + 1;
        const bdayThisMonth = state.birthdays.filter(b => {
            if (!b.date) return false;
            const m = parseInt(b.date.split('-')[1]);
            return m === thisMonth;
        });

        const bdayEl = document.getElementById('dash-birthdays');
        if (bdayThisMonth.length === 0) {
            bdayEl.innerHTML = '<p class="text-slate-500 text-sm">Nenhum aniversariante este mês.</p>';
        } else {
            bdayEl.innerHTML = bdayThisMonth.map(b => `
                <div class="flex items-center justify-between p-3 bg-dark-950 border border-brand/15 rounded-xl">
                    <div>
                        <p class="text-sm font-semibold text-white">${b.name}</p>
                        <p class="text-xs text-slate-400">${fmtDate(b.date)}</p>
                    </div>
                    <span class="text-gold-400 text-xs">${b.phone || '—'}</span>
                </div>
            `).join('');
        }
    }

    // ─── AGENDAMENTOS ───────────────────────────────────────────────────────────
    window.renderAppointments = function() {
        const search = (document.getElementById('appt-search')?.value || '').toLowerCase();
        const filterStatus = document.getElementById('appt-filter-status')?.value || '';

        let filtered = state.appointments.filter(a => {
            const matchSearch = !search || a.client?.toLowerCase().includes(search) || a.service?.toLowerCase().includes(search);
            const matchStatus = !filterStatus || a.status === filterStatus;
            return matchSearch && matchStatus;
        }).sort((a, b) => (b.date || '').localeCompare(a.date || ''));

        const tbody = document.getElementById('appt-table-body');
        if (filtered.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" class="p-8 text-center text-slate-500 text-sm">Nenhum agendamento encontrado.</td></tr>';
            return;
        }

        tbody.innerHTML = filtered.map(a => `
            <tr class="table-row">
                <td class="p-4">
                    <p class="font-semibold text-white text-sm">${a.client}</p>
                    <p class="text-xs text-slate-500">${a.email || ''}</p>
                </td>
                <td class="p-4 text-sm text-slate-300">${a.service}</td>
                <td class="p-4 text-sm text-slate-300">${fmtDate(a.date)} ${a.time ? 'às ' + a.time : ''}</td>
                <td class="p-4 text-sm font-semibold text-gold-400">${fmt(a.price)}</td>
                <td class="p-4">
                    <span class="${a.status === 'Confirmado' ? 'badge-confirmed' : a.status === 'Cancelado' ? 'badge-cancelled' : 'badge-pending'}">${a.status || 'Pendente'}</span>
                </td>
                <td class="p-4 text-right">
                    <div class="flex items-center justify-end gap-2">
                        ${a.status !== 'Confirmado' ? `<button onclick="confirmAppt('${a.id}')" class="text-xs text-green-400 hover:text-green-300 font-semibold transition-colors">Confirmar</button>` : ''}
                        ${a.status !== 'Cancelado' ? `<button onclick="cancelAppt('${a.id}')" class="text-xs text-amber-400 hover:text-amber-300 font-semibold transition-colors">Cancelar</button>` : ''}
                        <button onclick="openDeleteModal('Excluir agendamento de ${a.client}?', () => deleteAppt('${a.id}'))" class="text-xs text-red-400 hover:text-red-300 font-semibold transition-colors">Excluir</button>
                    </div>
                </td>
            </tr>
        `).join('');
    };

    window.confirmAppt = async function(id) {
        await updateDoc(doc(db, 'appointments', id), { status: 'Confirmado' });
        showToast('Confirmado!', 'Agendamento confirmado com sucesso.', 'success');
    };

    window.cancelAppt = async function(id) {
        await updateDoc(doc(db, 'appointments', id), { status: 'Cancelado' });
        showToast('Cancelado', 'Agendamento cancelado.', 'info');
    };

    window.deleteAppt = async function(id) {
        await deleteDoc(doc(db, 'appointments', id));
        showToast('Excluído', 'Agendamento removido.', 'info');
    };

    document.getElementById('form-new-appt').addEventListener('submit', async (e) => {
        e.preventDefault();
        const serviceVal = document.getElementById('appt-service').value;
        const [svcName, svcPrice] = serviceVal.split('|');

        const date = document.getElementById('appt-date').value;
        if (date < new Date().toISOString().split('T')[0]) {
            showToast('Data inválida', 'Não é possível agendar em datas passadas.', 'error');
            return;
        }

        await addDoc(cols.appointments, {
            client: document.getElementById('appt-client').value.trim(),
            email: document.getElementById('appt-email').value.trim(),
            phone: document.getElementById('appt-phone').value.trim(),
            service: svcName,
            price: parseFloat(svcPrice) || 0,
            date,
            time: document.getElementById('appt-time').value,
            professional: document.getElementById('appt-professional').value.trim(),
            notes: document.getElementById('appt-notes').value.trim(),
            status: 'Pendente',
            createdAt: new Date().toISOString(),
        });

        showToast('Agendado!', 'Agendamento criado com sucesso.', 'success');
        e.target.reset();
        document.getElementById('appt-professional').value = 'Estefani Ferreira';
    });

    // ─── CLIENTES ───────────────────────────────────────────────────────────────
    window.renderClients = function() {
        const search = (document.getElementById('client-search')?.value || '').toLowerCase();
        const filtered = state.clients.filter(c =>
            !search || c.name?.toLowerCase().includes(search) || c.email?.toLowerCase().includes(search)
        ).sort((a, b) => (a.name || '').localeCompare(b.name || ''));

        const tbody = document.getElementById('clients-table-body');
        if (filtered.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-center text-slate-500 text-sm">Nenhum cliente encontrado.</td></tr>';
            return;
        }

        tbody.innerHTML = filtered.map(c => `
            <tr class="table-row">
                <td class="p-4">
                    <div class="flex items-center gap-3">
                        <div class="h-8 w-8 rounded-full bg-gradient-to-br from-gold-500 to-gold-700 flex items-center justify-center text-dark-950 font-bold text-xs shrink-0">
                            ${(c.name || '?').charAt(0).toUpperCase()}
                        </div>
                        <span class="font-semibold text-white text-sm">${c.name}</span>
                    </div>
                </td>
                <td class="p-4">
                    <p class="text-sm text-slate-300">${c.email || '—'}</p>
                    <p class="text-xs text-slate-500">${c.phone || '—'}</p>
                </td>
                <td class="p-4 text-sm text-slate-300">${fmtDate(c.birthday) || '—'}</td>
                <td class="p-4 text-sm text-slate-300">${c.city || '—'}</td>
                <td class="p-4 text-right">
                    <button onclick="openDeleteModal('Excluir cliente ${c.name}?', () => deleteClient('${c.id}'))" class="text-xs text-red-400 hover:text-red-300 font-semibold transition-colors">Excluir</button>
                </td>
            </tr>
        `).join('');
    };

    window.deleteClient = async function(id) {
        await deleteDoc(doc(db, 'clients', id));
        showToast('Excluído', 'Cliente removido.', 'info');
    };

    document.getElementById('form-new-client').addEventListener('submit', async (e) => {
        e.preventDefault();
        await addDoc(cols.clients, {
            name: document.getElementById('client-name').value.trim(),
            email: document.getElementById('client-email').value.trim(),
            phone: document.getElementById('client-phone').value.trim(),
            birthday: document.getElementById('client-birthday').value,
            city: document.getElementById('client-city').value.trim(),
            createdAt: new Date().toISOString(),
        });
        showToast('Cadastrado!', 'Cliente adicionado com sucesso.', 'success');
        e.target.reset();
    });

    // ─── ANIVERSÁRIOS ───────────────────────────────────────────────────────────
    window.renderBirthdays = function() {
        const thisMonth = new Date().getMonth() + 1;

        const bdayThisMonth = state.birthdays.filter(b => {
            if (!b.date) return false;
            return parseInt(b.date.split('-')[1]) === thisMonth;
        }).sort((a, b) => (a.date || '').localeCompare(b.date || ''));

        const thisMonthEl = document.getElementById('bday-this-month');
        if (bdayThisMonth.length === 0) {
            thisMonthEl.innerHTML = '<p class="text-slate-500 text-sm">Nenhum aniversariante este mês.</p>';
        } else {
            thisMonthEl.innerHTML = bdayThisMonth.map(b => `
                <div class="flex items-center justify-between p-3 bg-dark-950 border border-brand/15 rounded-xl">
                    <div>
                        <p class="text-sm font-semibold text-white">${b.name}</p>
                        <p class="text-xs text-slate-400">${fmtDate(b.date)}</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="text-gold-400 text-xs">${b.phone || '—'}</span>
                        <button onclick="openDeleteModal('Excluir ${b.name}?', () => deleteBirthday('${b.id}'))" class="text-xs text-red-400 hover:text-red-300">Excluir</button>
                    </div>
                </div>
            `).join('');
        }

        const allEl = document.getElementById('bday-all-list');
        const sorted = [...state.birthdays].sort((a, b) => {
            const ma = parseInt((a.date || '').split('-')[1] || 0);
            const mb = parseInt((b.date || '').split('-')[1] || 0);
            const da = parseInt((a.date || '').split('-')[2] || 0);
            const db2 = parseInt((b.date || '').split('-')[2] || 0);
            return ma !== mb ? ma - mb : da - db2;
        });

        if (sorted.length === 0) {
            allEl.innerHTML = '<p class="text-slate-500 text-sm">Nenhum aniversariante cadastrado.</p>';
        } else {
            allEl.innerHTML = sorted.map(b => `
                <div class="flex items-center justify-between p-3 bg-dark-950 border border-brand/15 rounded-xl">
                    <div>
                        <p class="text-sm font-semibold text-white">${b.name}</p>
                        <p class="text-xs text-slate-400">${fmtDate(b.date)} — ${b.phone || '—'}</p>
                    </div>
                    <button onclick="openDeleteModal('Excluir ${b.name}?', () => deleteBirthday('${b.id}'))" class="text-xs text-red-400 hover:text-red-300">Excluir</button>
                </div>
            `).join('');
        }
    };

    window.deleteBirthday = async function(id) {
        await deleteDoc(doc(db, 'birthdays', id));
        showToast('Excluído', 'Aniversariante removido.', 'info');
    };

    document.getElementById('form-new-birthday').addEventListener('submit', async (e) => {
        e.preventDefault();
        await addDoc(cols.birthdays, {
            name: document.getElementById('bday-name').value.trim(),
            date: document.getElementById('bday-date').value,
            phone: document.getElementById('bday-phone').value.trim(),
        });
        showToast('Adicionado!', 'Aniversariante cadastrado.', 'success');
        e.target.reset();
    });

    // ─── SERVIÇOS ───────────────────────────────────────────────────────────────
    window.renderServices = function() {
        const grid = document.getElementById('services-grid');
        if (state.services.length === 0) {
            grid.innerHTML = '<p class="text-slate-500 text-sm col-span-full">Nenhum serviço cadastrado.</p>';
            return;
        }

        grid.innerHTML = state.services.map(s => `
            <div class="bg-dark-900 border border-brand/30 rounded-2xl p-5 hover:border-gold-500/30 transition-all group">
                <div class="flex items-start justify-between mb-3">
                    <div class="h-10 w-10 bg-gold-950/60 border border-gold-500/30 rounded-xl flex items-center justify-center text-gold-400 group-hover:bg-gold-500 group-hover:text-dark-950 transition-all">
                        <i data-lucide="sparkles" class="h-5 w-5"></i>
                    </div>
                    <button onclick="openDeleteModal('Excluir serviço ${s.name}?', () => deleteService('${s.id}'))" class="text-slate-600 hover:text-red-400 transition-colors opacity-0 group-hover:opacity-100">
                        <i data-lucide="trash-2" class="h-4 w-4"></i>
                    </button>
                </div>
                <h3 class="font-serif text-lg text-white mb-1">${s.name}</h3>
                <p class="text-xs text-slate-400 leading-relaxed mb-4">${s.desc || 'Procedimento estético personalizado.'}</p>
                <div class="flex items-center justify-between border-t border-brand/20 pt-3">
                    <span class="text-gold-400 font-bold">${fmt(s.price)}</span>
                    <span class="text-xs text-slate-500">${s.duration || 60} min</span>
                </div>
            </div>
        `).join('');
        lucide.createIcons();
    };

    window.deleteService = async function(id) {
        await deleteDoc(doc(db, 'services', id));
        showToast('Excluído', 'Serviço removido.', 'info');
    };

    function updateServiceDropdowns() {
        const sel = document.getElementById('appt-service');
        if (sel) {
            sel.innerHTML = '<option value="">Selecione um serviço</option>' +
                state.services.map(s => `<option value="${s.name}|${s.price}">${s.name} — ${fmt(s.price)}</option>`).join('');
        }
    }

    document.getElementById('form-new-service').addEventListener('submit', async (e) => {
        e.preventDefault();
        const btn = e.target.querySelector('button[type="submit"]');
        btn.disabled = true;
        try {
            await addDoc(cols.services, {
                name: document.getElementById('svc-name').value.trim(),
                price: parseFloat(document.getElementById('svc-price').value) || 0,
                duration: parseInt(document.getElementById('svc-duration').value) || 60,
                desc: document.getElementById('svc-desc').value.trim(),
            });
            showToast('Serviço criado!', 'Novo serviço adicionado com sucesso.', 'success');
            e.target.reset();
        } catch(err) {
            console.error('Erro ao salvar serviço:', err);
            showToast('Erro', 'Não foi possível salvar: ' + err.message, 'error');
        } finally {
            btn.disabled = false;
        }
    });

    // ─── PRODUTOS ───────────────────────────────────────────────────────────────
    window.renderProducts = function() {
        const tbody = document.getElementById('products-table-body');
        if (state.products.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-center text-slate-500 text-sm">Nenhum produto cadastrado.</td></tr>';
            return;
        }

        tbody.innerHTML = state.products.map(p => {
            const isLow = (p.stock || 0) <= (p.minStock || 5);
            const pct = Math.min(((p.stock || 0) / Math.max((p.minStock || 5) * 4, 1)) * 100, 100);
            return `
                <tr class="table-row">
                    <td class="p-4 font-semibold text-white text-sm">${p.name}</td>
                    <td class="p-4 text-sm font-semibold text-gold-400">${fmt(p.price)}</td>
                    <td class="p-4">
                        <div class="flex items-center gap-3">
                            <span class="font-mono font-bold text-white text-sm">${p.stock || 0}</span>
                            <div class="flex-1 max-w-20 bg-dark-800 rounded-full h-1.5">
                                <div class="h-full rounded-full ${isLow ? 'bg-red-500' : 'bg-gold-500'}" style="width:${pct}%"></div>
                            </div>
                        </div>
                    </td>
                    <td class="p-4">
                        <span class="${isLow ? 'badge-cancelled' : 'badge-confirmed'}">${isLow ? 'Estoque Baixo' : 'Normal'}</span>
                    </td>
                    <td class="p-4 text-right">
                        <div class="flex items-center justify-end gap-3">
                            <button onclick="reorderProduct('${p.id}')" class="text-xs text-gold-400 hover:text-gold-300 font-semibold transition-colors">+5 unid.</button>
                            <button onclick="openDeleteModal('Excluir produto ${p.name}?', () => deleteProduct('${p.id}'))" class="text-xs text-red-400 hover:text-red-300 font-semibold transition-colors">Excluir</button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
    };

    window.renderInactiveProducts = function() {
        const tbody = document.getElementById('products-inactive-body');
        const inactiveProducts = state.products.filter(p => p.active === false);
        if (inactiveProducts.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="p-8 text-center text-slate-500 text-sm">Nenhum produto inativo.</td></tr>';
            return;
        }

        tbody.innerHTML = inactiveProducts.map(p => `
            <tr class="table-row opacity-60">
                <td class="p-4 font-semibold text-slate-300 text-sm">${p.name}</td>
                <td class="p-4 text-sm font-semibold text-slate-400">${fmt(p.price)}</td>
                <td class="p-4 text-slate-400">${p.stock || 0} unidades</td>
                <td class="p-4 text-right">
                    <div class="flex items-center justify-end gap-2 text-xs">
                        <button onclick="toggleProductStatus('${p.id}', true)" class="text-green-400 hover:text-green-300 font-semibold">Reativar</button>
                        <button onclick="openDeleteModal('Excluir ${p.name} permanentemente?', () => deleteProduct('${p.id}')" class="text-red-400 hover:text-red-300 font-semibold">Excluir</button>
                    </div>
                </td>
            </tr>
        `).join('');
    };

    window.reorderProduct = async function(id) {
        const p = state.products.find(x => x.id === id);
        if (p) {
            await updateDoc(doc(db, 'products', id), { stock: (p.stock || 0) + 5 });
            showToast('Estoque atualizado', `${p.name}: +5 unidades.`, 'success');
        }
    };

    window.deleteProduct = async function(id) {
        await deleteDoc(doc(db, 'products', id));
        showToast('Excluído', 'Produto removido.', 'info');
    };

    // ─── CONTROLE UNITÁRIO DE ESTOQUE ──────────────────────────────────────────
    window.adjustStock = async function(id, delta) {
        const p = state.products.find(x => x.id === id);
        if (p) {
            const newStock = Math.max(0, (p.stock || 0) + delta);
            await updateDoc(doc(db, 'products', id), { stock: newStock });
            showToast('Estoque', `${p.name}: ${newStock} unidades.`, 'success');
        }
    };

    // ─── ATIVAR/DESATIVAR PRODUTOS ──────────────────────────────────────────────
    window.toggleProductStatus = async function(id, active) {
        const p = state.products.find(x => x.id === id);
        if (p) {
            await updateDoc(doc(db, 'products', id), { active: active });
            showToast(active ? 'Ativado' : 'Desativado', `${p.name} ${active ? 'reativado' : 'desativado'}.`, 'info');
        }
    };

    // ─── BUSCA DE CLIENTES PARA AGENDAMENTOS ────────────────────────────────────
    window.populateApptClientData = function() {
        const sel = document.getElementById('appt-client-select');
        const clientId = sel.value;
        if (!clientId) return;
        
        const client = state.clients.find(c => c.id === clientId);
        if (client) {
            document.getElementById('appt-client').value = client.name || '';
            document.getElementById('appt-email').value = client.email || '';
            document.getElementById('appt-phone').value = client.phone || '';
        }
    };

    // ─── BUSCA DE CLIENTES PARA ANIVERSÁRIOS ────────────────────────────────────
    window.populateBirthdayClientData = function() {
        const sel = document.getElementById('bday-client-select');
        const clientId = sel.value;
        if (!clientId) return;
        
        const client = state.clients.find(c => c.id === clientId);
        if (client) {
            document.getElementById('bday-name').value = client.name || '';
            document.getElementById('bday-date').value = client.birthDate || '';
            document.getElementById('bday-phone').value = client.phone || '';
        }
    };

    // ─── ATUALIZAR SELETORES DE CLIENTES ────────────────────────────────────────
    window.updateClientSelectors = function() {
        const apptSel = document.getElementById('appt-client-select');
        const bdaySel = document.getElementById('bday-client-select');
        
        if (apptSel) {
            apptSel.innerHTML = '<option value="">Selecione um cliente</option>' +
                state.clients.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
        }
        if (bdaySel) {
            bdaySel.innerHTML = '<option value="">Selecione um cliente</option>' +
                state.clients.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
        }
    };

    function updateProductDropdown() {
        const sel = document.getElementById('sale-product');
        if (sel) {
            const activeProds = state.products.filter(p => p.active !== false);
            sel.innerHTML = '<option value="">Selecione um produto</option>' +
                activeProds.map(p => `<option value="${p.id}|${p.price}|${p.name}|${p.stock}">${p.name} — ${fmt(p.price)} (estoque: ${p.stock || 0})</option>`).join('');
        }
    }

    document.getElementById('form-new-product').addEventListener('submit', async (e) => {
        e.preventDefault();
        await addDoc(cols.products, {
            name: document.getElementById('prod-name').value.trim(),
            price: parseFloat(document.getElementById('prod-price').value) || 0,
            stock: parseInt(document.getElementById('prod-stock').value) || 0,
            minStock: parseInt(document.getElementById('prod-min-stock').value) || 5,
        });
        showToast('Produto adicionado!', 'Novo produto no estoque.', 'success');
        e.target.reset();
    });

    // ─── VENDAS ─────────────────────────────────────────────────────────────────
    document.getElementById('sale-product').addEventListener('change', function() {
        const [, price, , stock] = this.value.split('|');
        const qty = parseInt(document.getElementById('sale-qty').value) || 1;
        document.getElementById('sale-total-preview').textContent = fmt((parseFloat(price) || 0) * qty);
    });

    document.getElementById('sale-qty').addEventListener('input', function() {
        const [, price] = document.getElementById('sale-product').value.split('|');
        document.getElementById('sale-total-preview').textContent = fmt((parseFloat(price) || 0) * (parseInt(this.value) || 1));
    });

    document.getElementById('form-new-sale').addEventListener('submit', async (e) => {
        e.preventDefault();
        const [id, price, name, stock] = document.getElementById('sale-product').value.split('|');
        const qty = parseInt(document.getElementById('sale-qty').value) || 1;

        if (!id) { showToast('Erro', 'Selecione um produto.', 'error'); return; }
        if (qty > parseInt(stock)) { showToast('Estoque insuficiente', `Apenas ${stock} unidades disponíveis.`, 'error'); return; }

        const total = parseFloat(price) * qty;
        await updateDoc(doc(db, 'products', id), { stock: parseInt(stock) - qty });
        await addDoc(cols.sales, {
            product: name,
            productId: id,
            qty,
            price: parseFloat(price),
            total,
            client: document.getElementById('sale-client').value.trim(),
            date: new Date().toISOString().split('T')[0],
            createdAt: new Date().toISOString(),
        });

        showToast('Venda registrada!', `${fmt(total)} — ${name} x${qty}`, 'success');
        e.target.reset();
        document.getElementById('sale-total-preview').textContent = 'R$ 0,00';
    });

    window.renderSales = function() {
        const el = document.getElementById('sales-list');
        const sorted = [...state.sales].sort((a, b) => (b.createdAt || '').localeCompare(a.createdAt || '')).slice(0, 20);

        if (sorted.length === 0) {
            el.innerHTML = '<p class="text-slate-500 text-sm">Nenhuma venda registrada.</p>';
            return;
        }

        el.innerHTML = sorted.map(s => `
            <div class="flex items-center justify-between p-3 bg-dark-950 border border-brand/15 rounded-xl">
                <div>
                    <p class="text-sm font-semibold text-white">${s.product}</p>
                    <p class="text-xs text-slate-400">${fmtDate(s.date)} ${s.client ? '— ' + s.client : ''} — x${s.qty}</p>
                </div>
                <span class="font-semibold text-gold-400 text-sm">${fmt(s.total)}</span>
            </div>
        `).join('');
    };

    // ─── RELATÓRIOS ─────────────────────────────────────────────────────────────
    function updateReports() {
        const apptRevenue = state.appointments
            .filter(a => a.status === 'Confirmado')
            .reduce((s, a) => s + (a.price || 0), 0);
        const salesRevenue = state.sales.reduce((s, a) => s + (a.total || 0), 0);

        document.getElementById('rep-total-revenue').textContent = fmt(apptRevenue + salesRevenue);
        document.getElementById('rep-confirmed-appts').textContent = state.appointments.filter(a => a.status === 'Confirmado').length;
        document.getElementById('rep-total-sales').textContent = state.sales.length;

        // Top serviços
        const svcCount = {};
        state.appointments.forEach(a => {
            if (a.service) svcCount[a.service] = (svcCount[a.service] || 0) + 1;
        });
        const topSvcs = Object.entries(svcCount).sort((a, b) => b[1] - a[1]).slice(0, 5);
        const maxCount = topSvcs[0]?.[1] || 1;

        const el = document.getElementById('rep-top-services');
        if (topSvcs.length === 0) {
            el.innerHTML = '<p class="text-slate-500 text-sm">Nenhum dado disponível.</p>';
        } else {
            el.innerHTML = topSvcs.map(([name, count]) => `
                <div class="flex items-center gap-4">
                    <span class="text-sm text-slate-300 w-48 truncate">${name}</span>
                    <div class="flex-1 bg-dark-800 rounded-full h-2">
                        <div class="h-full bg-gradient-to-r from-gold-600 to-gold-400 rounded-full" style="width:${(count/maxCount)*100}%"></div>
                    </div>
                    <span class="text-xs font-semibold text-gold-400 w-8 text-right">${count}x</span>
                </div>
            `).join('');
        }
    }

    window.generatePDF = function() {
        const { jsPDF } = window.jspdf;
        const docPdf = new jsPDF();

        docPdf.setFillColor(18, 18, 18);
        docPdf.rect(0, 0, 210, 50, 'F');
        docPdf.setTextColor(255, 255, 255);
        docPdf.setFont('times', 'bold');
        docPdf.setFontSize(20);
        docPdf.text("ESTÉTICA ESTEFANI FERREIRA", 15, 22);
        docPdf.setFontSize(10);
        docPdf.setTextColor(197, 139, 43);
        docPdf.text("RELATÓRIO GERENCIAL — " + new Date().toLocaleDateString('pt-BR'), 15, 32);

        const apptRevenue = state.appointments.filter(a => a.status === 'Confirmado').reduce((s, a) => s + (a.price || 0), 0);
        const salesRevenue = state.sales.reduce((s, a) => s + (a.total || 0), 0);

        docPdf.setTextColor(0, 0, 0);
        docPdf.setFontSize(12);
        docPdf.text(`Receita Total: R$ ${(apptRevenue + salesRevenue).toFixed(2)}`, 15, 65);
        docPdf.text(`Serviços Confirmados: ${state.appointments.filter(a => a.status === 'Confirmado').length}`, 15, 75);
        docPdf.text(`Vendas Realizadas: ${state.sales.length}`, 15, 85);

        let y = 100;
        docPdf.setFontSize(11);
        docPdf.setFont('times', 'bold');
        docPdf.text("Agendamentos Confirmados:", 15, y);
        y += 8;
        docPdf.setFont('times', 'normal');
        docPdf.setFontSize(9);
        state.appointments.filter(a => a.status === 'Confirmado').forEach(a => {
            if (y > 270) { docPdf.addPage(); y = 20; }
            docPdf.text(`${fmtDate(a.date)} ${a.time || ''} — ${a.client} — ${a.service} — R$ ${(a.price || 0).toFixed(2)}`, 15, y);
            y += 6;
        });

        y += 5;
        if (y > 260) { docPdf.addPage(); y = 20; }
        docPdf.setFontSize(11);
        docPdf.setFont('times', 'bold');
        docPdf.text("Vendas de Produtos:", 15, y);
        y += 8;
        docPdf.setFont('times', 'normal');
        docPdf.setFontSize(9);
        state.sales.forEach(s => {
            if (y > 270) { docPdf.addPage(); y = 20; }
            docPdf.text(`${fmtDate(s.date)} — ${s.product} x${s.qty} = R$ ${(s.total || 0).toFixed(2)}`, 15, y);
            y += 6;
        });

        docPdf.save("Relatorio_Estefani_Ferreira.pdf");
        showToast('PDF Gerado!', 'Relatório exportado com sucesso.', 'success');
    };

    // ─── SERVIÇOS PÚBLICOS (LANDING) ────────────────────────────────────────────
    function loadPublicServices() {
        const grid = document.getElementById('public-services-grid');
        const simGrid = document.getElementById('simulator-services');

        if (state.services.length === 0) {
            if (grid) grid.innerHTML = '<div class="col-span-full text-center py-12 text-slate-500"><p class="text-sm">Nenhum serviço disponível no momento.</p></div>';
            if (simGrid) simGrid.innerHTML = '<p class="text-slate-500 text-sm col-span-full text-center py-4">Nenhum serviço disponível.</p>';
            return;
        }

        if (grid) {
            grid.innerHTML = state.services.map(s => `
                <div class="bg-dark-900 border border-brand/30 p-8 rounded-2xl space-y-4 hover:border-gold-500/30 transition-all group">
                    <div class="h-12 w-12 rounded-xl bg-gold-950/60 border border-gold-500/30 flex items-center justify-center text-gold-400 group-hover:bg-gold-500 group-hover:text-dark-950 transition-all">
                        <i data-lucide="sparkles" class="h-6 w-6"></i>
                    </div>
                    <h3 class="font-serif text-xl text-white">${s.name}</h3>
                    <p class="text-slate-400 text-sm leading-relaxed">${s.desc || 'Procedimento estético exclusivo.'}</p>
                    <div class="flex items-center justify-between pt-4 border-t border-brand/20">
                        <span class="text-gold-400 font-bold">${fmt(s.price)}</span>
                        <span class="text-xs text-slate-500">${s.duration || 60} min</span>
                    </div>
                </div>
            `).join('');
            lucide.createIcons();
        }

        if (simGrid) {
            simGrid.innerHTML = state.services.map(s => `
                <label class="flex items-center gap-3 p-4 bg-dark-900 border border-brand/30 rounded-xl cursor-pointer hover:border-gold-500/50 transition-all">
                    <input type="checkbox" class="sim-check h-5 w-5 rounded accent-gold-500" value="${s.price}" onchange="calcSimulator()">
                    <div>
                        <span class="block text-sm font-semibold text-white">${s.name}</span>
                        <span class="text-xs text-gold-400">${fmt(s.price)}</span>
                    </div>
                </label>
            `).join('');
        }
    }

    window.calcSimulator = function() {
        const total = [...document.querySelectorAll('.sim-check:checked')].reduce((s, c) => s + parseFloat(c.value), 0);
        document.getElementById('simulator-total').textContent = 'R$ ' + total.toFixed(2).replace('.', ',');
    };

    // ─── DELETE MODAL ───────────────────────────────────────────────────────────
    window.openDeleteModal = function(msg, callback) {
        state.deleteCallback = callback;
        document.getElementById('delete-modal-msg').textContent = msg;
        const m = document.getElementById('delete-modal');
        m.classList.remove('hidden');
        m.classList.add('flex');
    };

    window.closeDeleteModal = function() {
        const m = document.getElementById('delete-modal');
        m.classList.add('hidden');
        m.classList.remove('flex');
        state.deleteCallback = null;
    };

    document.getElementById('delete-confirm-btn').addEventListener('click', async () => {
        if (state.deleteCallback) {
            await state.deleteCallback();
            closeDeleteModal();
        }
    });

    // ─── SIDEBAR NAVIGATION ─────────────────────────────────────────────────────
    window.showSection = function(section) {
        document.querySelectorAll('.section-panel').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.sidebar-link').forEach(el => el.classList.remove('active'));

        const panel = document.getElementById(`section-${section}`);
        const nav = document.getElementById(`nav-${section}`);
        if (panel) panel.classList.add('active');
        if (nav) nav.classList.add('active');

        const titles = {
            dashboard: ['Dashboard', 'Visão geral do sistema'],
            agendamentos: ['Agendamentos', 'Gerencie todos os agendamentos'],
            clientes: ['Clientes', 'Cadastro e gestão de clientes'],
            aniversarios: ['Aniversários', 'Controle de aniversariantes'],
            servicos: ['Serviços', 'Procedimentos e tratamentos'],
            produtos: ['Produtos / Estoque', 'Controle de estoque e produtos'],
            vendas: ['Ponto de Venda', 'Registre vendas de produtos'],
            relatorios: ['Relatórios', 'Análises e exportações'],
        };

        const [title, subtitle] = titles[section] || ['', ''];
        document.getElementById('page-title').textContent = title;
        document.getElementById('page-subtitle').textContent = subtitle;

        lucide.createIcons();
    };

    // ─── MOBILE MENU ────────────────────────────────────────────────────────────
    window.toggleMobileMenu = function() {
        document.getElementById('mobile-menu').classList.toggle('hidden');
    };

    // ─── INIT ───────────────────────────────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', () => {
        lucide.createIcons();
    });

</script>
</body>
</html>

