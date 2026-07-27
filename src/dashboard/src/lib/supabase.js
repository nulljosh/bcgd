import { createClient } from '@supabase/supabase-js';

// Shared `spark` project (free tier is capped at 2 projects).
// Publishable key only -- RLS denies anon reads on bcgd_leads.
const SUPABASE_URL = 'https://tjsxsqlxjmanwvmywwvw.supabase.co';
const SUPABASE_KEY = 'sb_publishable_3a5WLExQ3oF_kPV3KRCjdg_iEOiHO90';

export const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Leads the website has captured but the dashboard has not turned into jobs yet.
export async function fetchNewLeads() {
  const { data, error } = await supabase
    .from('bcgd_leads')
    .select('id, created_at, name, phone, service, message')
    .eq('status', 'Lead')
    .order('created_at', { ascending: false });
  if (error) throw error;
  return data;
}

export async function markLeadsImported(ids) {
  if (!ids.length) return;
  const { error } = await supabase
    .from('bcgd_leads')
    .update({ status: 'Imported' })
    .in('id', ids);
  if (error) throw error;
}
