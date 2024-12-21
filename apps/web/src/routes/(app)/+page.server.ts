import type { AppData } from '$lib/models/AppData';
import { supabase } from '$lib/supabaseClient.js';

export const load = async (): Promise<AppData> => {
  const { data: categories, error: categoriesError } = await supabase
    .from('categories')
    .select('name');

  const { data: things, error: thingsError } = await supabase
    .from('things')
    .select(`
      *,
      categories ( name ),
      images:thing_images ( url ),
      items (
        stock:count
      ),
      loans:loans_items (
        unavailable:count
      )
    `).eq('loans.returned', false);

  if (categoriesError) {
    console.log('error', categoriesError);
  }

  if (thingsError) {
    console.log('error', thingsError);
  }

  return {
    categories: ['All', ...categories.map(c => c.name)],
    things: things.map(thing => {
      const { categories, images, items: [{ stock }], loans: [{ unavailable }] } = thing;
      return {
        id: thing.id,
        name: thing.name,
        image: images.length ? images[0].url : undefined,
        spanishName: thing.spanish_name,
        categories: categories.map(c => c.name),
        stock,
        available: stock - unavailable
      };
    })
  };
};