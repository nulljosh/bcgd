import { useState } from 'react';
import { supabase } from '../lib/supabase';
import Logo from './Logo';

// Replaces the old 4-digit PinGate. Leads are customer PII (names + phone
// numbers) so read access is gated by real Supabase auth + RLS, not a client
// -side PIN check that anyone could edit out in devtools.
export default function AuthGate() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const [shaking, setShaking] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setBusy(true);
    setError('');
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    setBusy(false);
    if (error) {
      setError(error.message);
      setShaking(true);
      setPassword('');
      setTimeout(() => setShaking(false), 500);
    }
    // Success: App's onAuthStateChange listener swaps this out.
  };

  return (
    <div className="pin-gate">
      <form
        className={`pin-card glass-card ${shaking ? 'pin-shake' : ''}`}
        onSubmit={handleSubmit}
      >
        <Logo size={48} />
        <h1 className="pin-title">Best Choice Garage Doors</h1>
        <p className="pin-subtitle">Sign in</p>
        <input
          type="email"
          value={email}
          onChange={e => { setEmail(e.target.value); setError(''); }}
          className="auth-input"
          placeholder="Email"
          autoComplete="username"
          autoFocus
          required
        />
        <input
          type="password"
          value={password}
          onChange={e => { setPassword(e.target.value); setError(''); }}
          className="auth-input"
          placeholder="Password"
          autoComplete="current-password"
          required
        />
        {error && <p className="pin-error">{error}</p>}
        <button type="submit" className="btn btn-primary pin-submit" disabled={busy}>
          {busy ? 'Signing in...' : 'Sign In'}
        </button>
      </form>
    </div>
  );
}
