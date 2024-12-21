import { supabase } from '$lib/supabaseClient';
import { json } from '@sveltejs/kit';

export const GET = async ({ params }) => {
  const { id } = params;
  const { data: things } = await supabase.from('things')
    .select(`
      *,
      list:items ( id, brand, hidden, number ),
      categories ( name ),
      images:thing_images ( url ),
      items (
        stock:count
      ),
      loans:loans_items (
        unavailable:count
      )
    `)
    .eq('id', id)
    .eq('loans.returned', false);

  const thing = things?.[0];

  return json({
    id: thing.id,
    availableDate: undefined,
    available: thing.items[0].stock - thing.loans[0].unavailable,
    stock: thing.items[0].stock,
    categories: thing.categories.map(cat => cat.name),
    eyeProtection: !!thing.eye_protection,
    hidden: !!thing.hidden,
    image: thing.images.length ? thing.images[0].url : undefined,
    items: thing.list.map(item => ({ ...item, status: 'available' })),
    name: thing.name,
    spanishName: thing.spanish_name
  });
};