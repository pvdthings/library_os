import type { AppData } from '$lib/models/AppData';
import { supabase } from '$lib/supabaseClient.js';

export const load = async (): Promise<AppData> => {
  const { data: categories, error: categoriesError } = await supabase.from('categories').select('name');
  const { data: things } = await supabase.from('things').select();

  if (categoriesError) {
    console.log('error', categoriesError);
  }

  return {
    categories: ['All', ...(categories ?? []).map(c => c.name)],
    things: things ?? []
  };
};