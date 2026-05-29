import { useEffect, useState } from 'react'
import { useRouter } from 'next/router'
import { auth, db } from '@/lib/firebase'
import { signOut } from 'firebase/auth'
import { collection, query, where, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore'

export default function Dashboard() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [reservas, setReservas] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [formData, setFormData] = useState({
    sala: 'video',
    data: '',
    hora: '',
    turma: '',
    finalidade: '',
  })
  const [mensagem, setMensagem] = useState('')

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((currentUser) => {
      if (!currentUser) {
        router.push('/')
      } else {
        setUser(currentUser)
        carregarReservas(currentUser.uid)
      }
    })
    return () => unsubscribe()
  }, [router])

  const carregarReservas = async (userId: string) => {
    try {
      const q = query(collection(db, 'reservas'), where('userId', '==', userId))
      const snapshot = await getDocs(q)
      setReservas(snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })))
    } catch (error) {
      console.error('Erro ao carregar reservas:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = async () => {
    await signOut(auth)
    router.push('/')
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!user) return

    try {
      await addDoc(collection(db, 'reservas'), {
        userId: user.uid,
        email: user.email,
        nome: user.displayName || user.email?.split('@')[0],
        sala: formData.sala,
        data: formData.data,
        hora: formData.hora,
        turma: formData.turma,
        finalidade: formData.finalidade,
        status: 'confirmada',
        criadoEm: new Date(),
      })

      setFormData({ sala: 'video', data: '', hora: '', turma: '', finalidade: '' })
      setShowForm(false)
      setMensagem('✅ Reserva criada com sucesso!')
      setTimeout(() => setMensagem(''), 3000)
      carregarReservas(user.uid)
    } catch (error) {
      console.error('Erro ao criar reserva:', error)
      setMensagem('❌ Erro ao criar reserva')
      setTimeout(() => setMensagem(''), 3000)
    }
  }

  const handleDelete = async (id: string) => {
    if (confirm('Tem certeza que deseja cancelar esta reserva?')) {
      try {
        await deleteDoc(doc(db, 'reservas', id))
        carregarReservas(user.uid)
        setMensagem('✅ Reserva cancelada com sucesso!')
        setTimeout(() => setMensagem(''), 3000)
      } catch (error) {
        console.error('Erro ao cancelar reserva:', error)
        setMensagem('❌ Erro ao cancelar reserva')
        setTimeout(() => setMensagem(''), 3000)
      }
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-gray-600">Carregando...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 py-6 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
              <span className="text-white text-xl">📅</span>
            </div>
            <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          </div>
          <div className="flex items-center gap-4">
            <div className="text-right">
              <p className="font-semibold text-gray-900">{user?.email}</p>
              <p className="text-sm text-gray-600">Professor</p>
            </div>
            <button
              onClick={handleLogout}
              className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded transition"
            >
              Sair
            </button>
          </div>
        </div>
      </header>

      {/* Main */}
      <main className="max-w-7xl mx-auto px-4 py-8">
        {/* Mensagem */}
        {mensagem && (
          <div className="mb-6 p-4 bg-blue-100 border border-blue-400 text-blue-700 rounded-lg">
            {mensagem}
          </div>
        )}

        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Bem-vindo!</h2>
          <button
            onClick={() => setShowForm(!showForm)}
            className="bg-primary hover:bg-blue-700 text-white font-bold py-2 px-6 rounded transition"
          >
            {showForm ? 'Cancelar' : '+ Nova Reserva'}
          </button>
        </div>

        {/* Form */}
        {showForm && (
          <div className="bg-white p-6 rounded-lg shadow-md mb-8">
            <h3 className="text-xl font-bold text-gray-900 mb-4">Fazer Reserva</h3>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">Sala</label>
                  <select
                    value={formData.sala}
                    onChange={(e) => setFormData({ ...formData, sala: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="video">🎥 Sala de Vídeo</option>
                    <option value="laboratorio">💻 Laboratório de Informática</option>
                    <option value="recursos">📚 Recursos Pedagógicos</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">Data</label>
                  <input
                    type="date"
                    value={formData.data}
                    onChange={(e) => setFormData({ ...formData, data: e.target.value })}
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">Hora</label>
                  <input
                    type="time"
                    value={formData.hora}
                    onChange={(e) => setFormData({ ...formData, hora: e.target.value })}
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">Turma</label>
                  <input
                    type="text"
                    value={formData.turma}
                    onChange={(e) => setFormData({ ...formData, turma: e.target.value })}
                    placeholder="Ex: 9º A"
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-900 mb-2">Finalidade</label>
                <input
                  type="text"
                  value={formData.finalidade}
                  onChange={(e) => setFormData({ ...formData, finalidade: e.target.value })}
                  placeholder="Ex: Aula de Biologia"
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-primary hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition"
              >
                Confirmar Reserva
              </button>
            </form>
          </div>
        )}

        {/* Reservas */}
        <div>
          <h3 className="text-2xl font-bold text-gray-900 mb-4">Minhas Reservas</h3>
          {reservas.length === 0 ? (
            <div className="bg-white p-6 rounded-lg shadow-md text-center text-gray-600">
              <p>Você não tem reservas no momento</p>
              <p className="text-sm mt-2">Clique em "+ Nova Reserva" para agendar uma sala</p>
            </div>
          ) : (
            <div className="grid gap-4">
              {reservas.map((reserva) => (
                <div key={reserva.id} className="bg-white p-6 rounded-lg shadow-md">
                  <div className="flex items-start justify-between mb-4">
                    <div>
                      <h4 className="text-lg font-bold text-gray-900">
                        {reserva.sala === 'video' ? '🎥 Sala de Vídeo' : reserva.sala === 'laboratorio' ? '💻 Laboratório' : '📚 Recursos'}
                      </h4>
                      <p className="text-sm text-gray-600">Turma: {reserva.turma}</p>
                    </div>
                    <span className="bg-green-100 text-green-800 px-3 py-1 rounded text-sm font-semibold">
                      {reserva.status}
                    </span>
                  </div>
                  <div className="grid grid-cols-2 gap-4 mb-4 text-sm">
                    <div>
                      <p className="text-gray-600">Data e Hora</p>
                      <p className="font-semibold text-gray-900">{reserva.data} às {reserva.hora}</p>
                    </div>
                    <div>
                      <p className="text-gray-600">Finalidade</p>
                      <p className="font-semibold text-gray-900">{reserva.finalidade}</p>
                    </div>
                  </div>
                  <button
                    onClick={() => handleDelete(reserva.id)}
                    className="w-full bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded transition"
                  >
                    Cancelar Reserva
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
