import { useEffect, useState } from 'react'
import { useRouter } from 'next/router'
import { auth } from '@/lib/firebase'
import { signInWithPopup, GoogleAuthProvider } from 'firebase/auth'

export default function Home() {
  const router = useRouter()
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((currentUser) => {
      setLoading(false)
      if (currentUser) {
        router.push('/dashboard')
      }
    })
    return () => unsubscribe()
  }, [router])

  const handleLogin = async () => {
    try {
      const provider = new GoogleAuthProvider()
      await signInWithPopup(auth, provider)
    } catch (error) {
      console.error('Erro ao fazer login:', error)
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
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            Organize seus Agendamentos com Facilidade
          </h2>
          <p className="text-xl text-gray-600 mb-8">
            Plataforma inteligente para agendar salas de vídeo, laboratório de informática e recursos pedagógicos
          </p>
          <button
            onClick={handleLogin}
            className="bg-primary hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-lg transition"
          >
            Entrar com Google
          </button>
        </div>

        {/* Features */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
          <div className="bg-white p-6 rounded-lg shadow-md border-l-4 border-primary">
            <h3 className="text-xl font-bold text-gray-900 mb-2">📅 Calendário Interativo</h3>
            <p className="text-gray-600">Visualize disponibilidades em vistas semanal e mensal com código de cores intuitivo</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md border-l-4 border-secondary">
            <h3 className="text-xl font-bold text-gray-900 mb-2">🔒 Controle de Prioridades</h3>
            <p className="text-gray-600">Regras automáticas: 7 dias para regulares, 21 para técnicos, sem conflitos</p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md border-l-4 border-green-500">
            <h3 className="text-xl font-bold text-gray-900 mb-2">⚡ Sem Conflitos</h3>
            <p className="text-gray-600">Sistema automático previne reservas duplicadas no mesmo horário</p>
          </div>
        </div>

        {/* Info */}
        <div className="mt-16 bg-white p-8 rounded-lg shadow-md">
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
