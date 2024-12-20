import type { AppData } from '$lib/models/AppData';
import { supabase } from '$lib/supabaseClient.js';

export const load = async (): Promise<AppData> => {
  const { data: categories, error: categoriesError } = await supabase.from('categories').select('name');
  const { data: things } = await supabase.from('things').select(`
    id,
    name,
    spanish_name,
    categories ( name ),
    thing_images ( url )
  `);

  if (categoriesError) {
    console.log('error', categoriesError);
  }

  return {
    categories: ['All', ...categories.map(c => c.name)],
    things: things.map(thing => ({
      id: thing.id,
      name: thing.name,
      image: thing.thing_images.length ? thing.thing_images[0].url : undefined,
      spanishName: thing.spanish_name,
      categories: thing.categories.map(cat => cat.name),
      stock: 1,
      available: 1
    }))
  };
};