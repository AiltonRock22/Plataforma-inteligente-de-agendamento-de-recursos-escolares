import { useEffect, useState } from 'react'
import { useRouter } from 'next/router'
import { auth } from '@/lib/firebase'
import { signInWithEmailAndPassword } from 'firebase/auth'

export default function Home() {
  const router = useRouter()
  const [loading, setLoading] = useState(true)
  const [email, setEmail] = useState('')
  const [senha, setSenha] = useState('')
  const [erro, setErro] = useState('')
  const [carregando, setCarregando] = useState(false)

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((currentUser) => {
      setLoading(false)
      if (currentUser) {
        router.push('/dashboard')
      }
    })
    return () => unsubscribe()
  }, [router])

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setCarregando(true)
    setErro('')

    try {
      await signInWithEmailAndPassword(auth, email, senha)
      router.push('/dashboard')
    } catch (error: any) {
      console.error('Erro ao fazer login:', error)
      
      if (error.code === 'auth/user-not-found') {
        setErro('Usuário não encontrado. Verifique o email.')
      } else if (error.code === 'auth/wrong-password') {
        setErro('Senha incorreta.')
      } else if (error.code === 'auth/invalid-email') {
        setErro('Email inválido.')
      } else {
        setErro('Erro ao fazer login. Tente novamente.')
      }
    } finally {
      setCarregando(false)
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-gray-600">Carregando...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 py-6 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
              <span className="text-white text-xl">📅</span>
            </div>
            <h1 className="text-2xl font-bold text-gray-900">Agendamento Escolar</h1>
          </div>
          <p className="text-sm text-gray-600">Felício Roxo</p>
        </div>
      </header>

      {/* Main */}
      <main className="max-w-7xl mx-auto px-4 py-20">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          {/* Left side - Info */}
          <div>
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              Organize seus Agendamentos com Facilidade
            </h2>
            <p className="text-xl text-gray-600 mb-8">
              Plataforma inteligente para agendar salas de vídeo, laboratório de informática e recursos pedagógicos
            </p>

            {/* Features */}
            <div className="space-y-4">
              <div className="flex gap-3">
                <span className="text-2xl">📅</span>
                <div>
                  <h3 className="font-bold text-gray-900">Calendário Interativo</h3>
                  <p className="text-gray-600 text-sm">Visualize disponibilidades com código de cores</p>
                </div>
              </div>

              <div className="flex gap-3">
                <span className="text-2xl">🔒</span>
                <div>
                  <h3 className="font-bold text-gray-900">Controle de Prioridades</h3>
                  <p className="text-gray-600 text-sm">Regras automáticas por categoria de professor</p>
                </div>
              </div>

              <div className="flex gap-3">
                <span className="text-2xl">⚡</span>
                <div>
                  <h3 className="font-bold text-gray-900">Sem Conflitos</h3>
                  <p className="text-gray-600 text-sm">Sistema previne reservas duplicadas</p>
                </div>
              </div>
            </div>
          </div>

          {/* Right side - Login Form */}
          <div className="bg-white p-8 rounded-lg shadow-lg">
            <h3 className="text-2xl font-bold text-gray-900 mb-6">Fazer Login</h3>

            {erro && (
              <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                {erro}
              </div>
            )}

            <form onSubmit={handleLogin} className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-900 mb-2">
                  Email Institucional
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="seu.email@escolafelicio.edu.br"
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-900 mb-2">
                  Senha
                </label>
                <input
                  type="password"
                  value={senha}
                  onChange={(e) => setSenha(e.target.value)}
                  placeholder="Digite sua senha"
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>

              <button
                type="submit"
                disabled={carregando}
                className="w-full bg-primary hover:bg-blue-700 disabled:bg-gray-400 text-white font-bold py-3 px-4 rounded-lg transition"
              >
                {carregando ? 'Entrando...' : 'Entrar'}
              </button>
            </form>

            <div className="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
              <p className="text-sm text-gray-700">
                <strong>Não tem conta?</strong> Solicite ao administrador para criar sua conta no sistema.
              </p>
            </div>
          </div>
        </div>

        {/* Info Footer */}
        <div className="mt-20 bg-white p-8 rounded-lg shadow-md">
          <h3 className="text-2xl font-bold text-gray-900 mb-4">Sobre a Escola</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-gray-600">
            <div>
              <p className="font-semibold text-gray-900">Escola Estadual Felício Roxo</p>
              <p>R. Professor Genaldo, 475</p>
              <p>Sumaré, Montes Claros/MG</p>
            </div>
            <div>
              <p className="font-semibold text-gray-900">Contato</p>
              <p>Telefone: (38) 3223-8633</p>
              <p>Atendimento: Seg-Sex 7h-17h</p>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-900 text-white text-center py-6 mt-20">
        <p>&copy; 2026 Escola Estadual Felício Roxo. Todos os direitos reservados.</p>
      </footer>
    </div>
  )
}
