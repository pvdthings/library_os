import { createClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_KEY } from "$env/static/private";

console.log(SUPABASE_URL);
console.log(SUPABASE_KEY);

export const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);