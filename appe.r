import React, { useState, useEffect, useMemo } from 'react';
import { 
  Activity, 
  Plus, 
  CheckCircle, 
  XCircle, 
  Clock, 
  Settings, 
  LogOut, 
  Terminal, 
  Brain, 
  Calendar,
  Trash2,
  RefreshCw,
  ChevronRight,
  TrendingUp,
  Lock
} from 'lucide-react';

// --- CONSTANTS & CONFIG ---
const SRS_INTERVALS = [0, 1, 3, 7, 14, 30, 90]; // Days until next review per level
const MAX_LEVEL = 6;
const APP_ID = "nexus_v2_data";

// --- UTILITY FUNCTIONS ---
const getStorage = () => {
  const data = localStorage.getItem(APP_ID);
  return data ? JSON.parse(data) : { 
    user: null, 
    topics: [], 
    settings: { theme: 'cyber', gridDensity: 'normal' } 
  };
};

const setStorage = (data) => {
  localStorage.setItem(APP_ID, JSON.stringify(data));
};

const generateId = () => Math.random().toString(36).substr(2, 9);

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
};

// --- COMPONENTS ---

// 1. LOGIN / GATEKEEPER
const Gatekeeper = ({ onLogin }) => {
  const [codename, setCodename] = useState('');
  const [loading, setLoading] = useState(false);

  const handleEnter = (e) => {
    e.preventDefault();
    if (!codename.trim()) return;
    setLoading(true);
    // Simulate decryption delay
    setTimeout(() => {
      onLogin(codename);
      setLoading(false);
    }, 800);
  };

  return (
    <div className="min-h-screen bg-zinc-950 flex flex-col items-center justify-center p-4 relative overflow-hidden">
      {/* Background Grid */}
      <div className="absolute inset-0 opacity-10" 
           style={{ backgroundImage: 'radial-gradient(#00f0ff 1px, transparent 1px)', backgroundSize: '30px 30px' }}>
      </div>

      <div className="z-10 w-full max-w-md bg-zinc-900/80 backdrop-blur-xl border border-zinc-700 rounded-2xl p-8 shadow-2xl shadow-cyan-900/20">
        <div className="flex justify-center mb-6">
          <div className="w-16 h-16 rounded-full bg-cyan-500/10 flex items-center justify-center border border-cyan-500/30 text-cyan-400">
            <Lock size={32} />
          </div>
        </div>
        
        <h1 className="text-3xl font-bold text-center text-white mb-2 tracking-tight font-mono">NEXUS // CORE</h1>
        <p className="text-zinc-400 text-center mb-8 text-sm font-mono">SECURE KNOWLEDGE RETENTION SYSTEM</p>

        <form onSubmit={handleEnter} className="space-y-4">
          <div>
            <label className="text-xs font-mono text-cyan-500 mb-1 block">IDENTITY_STRING</label>
            <input 
              type="text" 
              value={codename}
              onChange={(e) => setCodename(e.target.value)}
              className="w-full bg-black/50 border border-zinc-700 rounded-lg px-4 py-3 text-white font-mono focus:border-cyan-500 focus:ring-1 focus:ring-cyan-500 outline-none transition-all placeholder-zinc-600"
              placeholder="ENTER CODENAME"
              autoFocus
            />
          </div>
          <button 
            type="submit"
            disabled={loading}
            className="w-full bg-cyan-600 hover:bg-cyan-500 text-white font-bold py-3 rounded-lg transition-all flex items-center justify-center gap-2 group"
          >
            {loading ? (
              <span className="animate-pulse">DECRYPTING...</span>
            ) : (
              <>
                INITIALIZE SESSION <ChevronRight size={16} className="group-hover:translate-x-1 transition-transform" />
              </>
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

// 2. DASHBOARD HEADER
const Header = ({ user, stats, onOpenSettings }) => {
  return (
    <div className="w-full mb-8">
      <div className="flex justify-between items-center mb-6">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-cyan-900/30 border border-cyan-500/30 flex items-center justify-center text-cyan-400">
            <Terminal size={20} />
          </div>
          <div>
            <div className="text-xs text-zinc-500 font-mono">OPERATOR</div>
            <div className="text-white font-bold tracking-wide">{user?.toUpperCase()}</div>
          </div>
        </div>
        <button 
          onClick={onOpenSettings}
          className="p-2 hover:bg-zinc-800 rounded-lg text-zinc-400 hover:text-white transition-colors"
        >
          <Settings size={20} />
        </button>
      </div>

      {/* Hero Stats Card */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="col-span-1 md:col-span-2 bg-gradient-to-br from-zinc-900 to-zinc-950 border border-zinc-800 rounded-2xl p-6 relative overflow-hidden group">
          <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
            <Activity size={100} />
          </div>
          <h2 className="text-zinc-400 font-mono text-sm mb-1">SYSTEM RETENTION</h2>
          <div className="flex items-baseline gap-2">
            <span className="text-5xl font-bold text-white">{stats.retention}%</span>
            <span className="text-emerald-500 flex items-center text-sm font-mono">
              <TrendingUp size={14} className="mr-1" /> OPTIMAL
            </span>
          </div>
          
          {/* Progress Bar */}
          <div className="w-full h-2 bg-zinc-800 rounded-full mt-6 overflow-hidden">
            <div 
              className="h-full bg-cyan-500 shadow-[0_0_15px_rgba(6,182,212,0.5)] transition-all duration-1000"
              style={{ width: `${stats.retention}%` }}
            ></div>
          </div>
        </div>

        <div className="col-span-1 bg-zinc-900/50 border border-zinc-800 rounded-2xl p-6 flex flex-col justify-center items-center relative overflow-hidden">
          <div className="absolute inset-0 bg-orange-500/5 blur-3xl"></div>
          <h2 className="text-zinc-400 font-mono text-sm mb-2">ACTION REQUIRED</h2>
          <div className="text-4xl font-bold text-white mb-1">{stats.dueCount}</div>
          <div className="text-xs text-orange-400 font-mono border border-orange-500/30 bg-orange-500/10 px-2 py-1 rounded">
            ITEMS DUE
          </div>
        </div>
      </div>
    </div>
  );
};

// 3. TOPIC CARD
const TopicCard = ({ topic, onReview, onDelete, onUndo }) => {
  const isDue = new Date().getTime() >= topic.nextReview;
  const progress = (topic.level / MAX_LEVEL) * 100;

  // Determine Level Color
  let levelColor = "bg-zinc-700";
  if (topic.level > 0) levelColor = "bg-emerald-500";
  if (topic.level > 3) levelColor = "bg-cyan-500";
  if (topic.level === MAX_LEVEL) levelColor = "bg-purple-500";

  return (
    <div className={`
      relative flex flex-col justify-between
      bg-zinc-900 border transition-all duration-300 rounded-xl p-5
      ${isDue ? 'border-orange-500/50 shadow-[0_0_20px_rgba(249,115,22,0.1)] hover:border-orange-500' : 'border-zinc-800 hover:border-zinc-600'}
    `}>
      {/* Header */}
      <div className="flex justify-between items-start mb-3">
        <div className="flex gap-1.5 mt-1">
          {[...Array(MAX_LEVEL)].map((_, i) => (
            <div 
              key={i} 
              className={`w-1.5 h-1.5 rounded-full ${i < topic.level ? levelColor : 'bg-zinc-800'}`}
            />
          ))}
        </div>
        <div className="font-mono text-xs text-zinc-500">LVL {topic.level}</div>
      </div>

      {/* Content */}
      <div className="mb-6">
        <h3 className="text-lg font-bold text-white leading-tight mb-2 line-clamp-2">{topic.title}</h3>
        {topic.description && (
          <p className="text-zinc-500 text-sm line-clamp-2">{topic.description}</p>
        )}
      </div>

      {/* Footer / Actions */}
      <div className="mt-auto">
        <div className="flex justify-between items-center text-xs font-mono text-zinc-500 mb-3">
          <span>{isDue ? 'STATUS: CRITICAL' : `NEXT: ${formatDate(topic.nextReview)}`}</span>
        </div>
        
        <div className="flex gap-2 h-10">
          {isDue ? (
            <button 
              onClick={() => onReview(topic.id, true)}
              className="flex-1 bg-white hover:bg-zinc-200 text-black font-bold rounded-lg flex items-center justify-center transition-colors"
            >
              REVIEW
            </button>
          ) : (
            <button 
              onClick={() => onUndo(topic.id)}
              className="flex-1 bg-zinc-800 hover:bg-zinc-700 text-zinc-300 font-medium rounded-lg flex items-center justify-center gap-2 transition-colors text-xs"
            >
              <RefreshCw size={12} /> UNDO
            </button>
          )}
          <button 
            onClick={() => onDelete(topic.id)}
            className="w-10 bg-zinc-900 border border-zinc-700 hover:border-red-500 hover:text-red-500 text-zinc-500 rounded-lg flex items-center justify-center transition-all"
          >
            <Trash2 size={14} />
          </button>
        </div>
      </div>
    </div>
  );
};

// 4. ADD TOPIC MODAL
const AddModal = ({ isOpen, onClose, onAdd }) => {
  const [title, setTitle] = useState('');
  const [desc, setDesc] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!title.trim()) return;
    onAdd(title, desc);
    setTitle('');
    setDesc('');
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
      <div className="bg-zinc-900 border border-zinc-700 w-full max-w-md rounded-2xl p-6 shadow-2xl animate-in fade-in zoom-in duration-200">
        <h2 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
          <Brain className="text-cyan-500" /> New Memory Node
        </h2>
        <form onSubmit={handleSubmit}>
          <input 
            className="w-full bg-black/30 border border-zinc-700 text-white rounded-lg px-4 py-3 mb-3 focus:border-cyan-500 outline-none placeholder-zinc-600"
            placeholder="Topic Title"
            value={title}
            onChange={e => setTitle(e.target.value)}
            autoFocus
          />
          <textarea 
            className="w-full bg-black/30 border border-zinc-700 text-zinc-300 rounded-lg px-4 py-3 mb-6 focus:border-cyan-500 outline-none placeholder-zinc-600 h-24 resize-none"
            placeholder="Description or Context (Optional)"
            value={desc}
            onChange={e => setDesc(e.target.value)}
          />
          <div className="flex gap-3">
            <button 
              type="button" 
              onClick={onClose}
              className="flex-1 py-3 rounded-lg text-zinc-400 hover:text-white hover:bg-zinc-800 transition-colors"
            >
              Cancel
            </button>
            <button 
              type="submit"
              className="flex-1 py-3 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white font-bold shadow-lg shadow-cyan-900/20"
            >
              Create Node
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

// --- MAIN APP LOGIC ---

export default function App() {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const [topics, setTopics] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [view, setView] = useState('app'); // 'app' or 'settings'

  // Load Data
  useEffect(() => {
    const data = getStorage();
    if (data.user) {
      setUser(data.user);
      setTopics(data.topics || []);
    }
    setLoading(false);
  }, []);

  // Save Data on Change
  useEffect(() => {
    if (!loading) {
      setStorage({ user, topics });
    }
  }, [user, topics, loading]);

  // Actions
  const handleLogin = (name) => {
    setUser(name);
  };

  const handleLogout = () => {
    setUser(null);
    setTopics([]);
    localStorage.removeItem(APP_ID);
  };

  const addTopic = (title, desc) => {
    const newTopic = {
      id: generateId(),
      title,
      description: desc,
      level: 0,
      created: Date.now(),
      nextReview: Date.now(), // Due immediately
    };
    setTopics(prev => [newTopic, ...prev]);
  };

  const deleteTopic = (id) => {
    if(confirm("Confirm deletion of memory node?")) {
      setTopics(prev => prev.filter(t => t.id !== id));
    }
  };

  const handleReview = (id, success) => {
    setTopics(prev => prev.map(t => {
      if (t.id !== id) return t;
      
      let newLevel = t.level;
      if (success) {
        newLevel = Math.min(t.level + 1, MAX_LEVEL);
        
        // --- Optional: Calendar Integration Logic here ---
        // For now, we keep it simple within the app
      } else {
        newLevel = Math.max(t.level - 1, 0);
      }

      const daysToAdd = SRS_INTERVALS[newLevel];
      const nextDate = new Date();
      nextDate.setDate(nextDate.getDate() + daysToAdd);

      return {
        ...t,
        level: newLevel,
        nextReview: nextDate.getTime()
      };
    }));
  };

  const undoReview = (id) => {
    setTopics(prev => prev.map(t => {
      if (t.id !== id) return t;
      return {
        ...t,
        level: Math.max(t.level - 1, 0),
        nextReview: Date.now() - 1000 // Make it due now
      };
    }));
  };

  // Stats Logic
  const stats = useMemo(() => {
    if (topics.length === 0) return { retention: 0, dueCount: 0 };
    const totalLevels = topics.reduce((acc, t) => acc + t.level, 0);
    const maxPossible = topics.length * MAX_LEVEL;
    const retention = Math.round((totalLevels / maxPossible) * 100) || 0;
    
    const now = new Date().getTime();
    const dueCount = topics.filter(t => t.nextReview <= now).length;
    
    return { retention, dueCount };
  }, [topics]);

  // Sort topics: Due items first, then by date
  const sortedTopics = [...topics].sort((a, b) => {
    const now = new Date().getTime();
    const aDue = a.nextReview <= now;
    const bDue = b.nextReview <= now;
    if (aDue && !bDue) return -1;
    if (!aDue && bDue) return 1;
    return a.nextReview - b.nextReview;
  });

  if (loading) return <div className="bg-zinc-950 min-h-screen"></div>;

  if (!user) {
    return <Gatekeeper onLogin={handleLogin} />;
  }

  return (
    <div className="min-h-screen bg-zinc-950 text-zinc-100 font-sans selection:bg-cyan-500/30">
      
      {/* Background Ambience */}
      <div className="fixed inset-0 pointer-events-none">
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-cyan-900/10 rounded-full blur-[100px]" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-purple-900/10 rounded-full blur-[100px]" />
        <div className="absolute inset-0 opacity-[0.03]" 
             style={{ backgroundImage: 'linear-gradient(rgba(255, 255, 255, 0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, 0.1) 1px, transparent 1px)', backgroundSize: '40px 40px' }}>
        </div>
      </div>

      <div className="relative max-w-6xl mx-auto p-6 md:p-10">
        
        {/* Header */}
        <Header 
          user={user} 
          stats={stats} 
          onOpenSettings={() => setView(view === 'settings' ? 'app' : 'settings')} 
        />

        {view === 'settings' ? (
           <div className="bg-zinc-900 border border-zinc-800 rounded-2xl p-8 max-w-2xl mx-auto animate-in fade-in slide-in-from-bottom-4">
             <div className="flex items-center gap-3 mb-6">
               <Settings className="text-cyan-500" />
               <h2 className="text-2xl font-bold">System Configuration</h2>
             </div>
             
             <div className="space-y-6">
               <div className="bg-black/20 p-4 rounded-lg border border-zinc-800">
                  <h3 className="font-mono text-zinc-400 text-xs mb-2">USER IDENTITY</h3>
                  <div className="text-xl">{user}</div>
               </div>

               <div className="bg-black/20 p-4 rounded-lg border border-zinc-800">
                  <h3 className="font-mono text-zinc-400 text-xs mb-2">DATA MANAGEMENT</h3>
                  <p className="text-zinc-500 text-sm mb-4">Erasing session data is irreversible. All topics will be lost.</p>
                  <button 
                    onClick={handleLogout}
                    className="w-full border border-red-500/50 hover:bg-red-500/10 text-red-400 py-3 rounded-lg transition-all flex items-center justify-center gap-2"
                  >
                    <LogOut size={16} /> TERMINATE SESSION & WIPE DATA
                  </button>
               </div>
               
               <button onClick={() => setView('app')} className="text-zinc-500 hover:text-white text-sm">Return to Grid</button>
             </div>
           </div>
        ) : (
          <>
            {/* Controls */}
            <div className="flex justify-between items-center mb-6">
              <div className="flex items-center gap-2 text-zinc-500 text-sm font-mono">
                <Brain size={16} />
                <span>ACTIVE NODES: {topics.length}</span>
              </div>
              <button 
                onClick={() => setIsModalOpen(true)}
                className="bg-white hover:bg-cyan-50 hover:text-cyan-600 text-black font-bold py-2 px-4 rounded-full flex items-center gap-2 transition-all shadow-lg hover:shadow-cyan-500/20"
              >
                <Plus size={18} /> Add Topic
              </button>
            </div>

            {/* Grid */}
            {topics.length === 0 ? (
              <div className="border-2 border-dashed border-zinc-800 rounded-2xl p-12 text-center">
                <div className="w-16 h-16 bg-zinc-900 rounded-full flex items-center justify-center mx-auto mb-4 text-zinc-600">
                  <Brain size={32} />
                </div>
                <h3 className="text-xl font-bold text-zinc-300 mb-2">System Empty</h3>
                <p className="text-zinc-500 mb-6">Initialize your first memory node to begin tracking.</p>
                <button 
                  onClick={() => setIsModalOpen(true)}
                  className="text-cyan-400 hover:text-cyan-300 font-mono text-sm border-b border-cyan-400/50 pb-1"
                >
                  INITIALIZE_NEW_NODE()
                </button>
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 pb-20">
                {sortedTopics.map(topic => (
                  <TopicCard 
                    key={topic.id} 
                    topic={topic} 
                    onReview={handleReview}
                    onDelete={deleteTopic}
                    onUndo={undoReview}
                  />
                ))}
              </div>
            )}
          </>
        )}
      </div>

      <AddModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onAdd={addTopic} 
      />
    </div>
  );
}