import { supabase } from '$lib/supabaseClient.js';
import { json } from '@sveltejs/kit';

export const GET = async ({ params }) => {
  const { id } = params;
  const { data: items } = await supabase.from('items')
    .select(`
      id,
      brand,
      number,
      status,
      item_attachments ( url ),
      things ( id, eye_protection, name, spanish_name )
    `)
    .eq('id', id);

  const item = items?.[0];
  const { eye_protection, name, spanish_name } = item.things;

  console.log('item', item);

  return json({
    id: item.id,
    available: undefined,
    availableDate: undefined,
    brand: item.brand,
    condition: item.status,
    eyeProtection: eye_protection,
    image: undefined,
    number: item.number,
    manuals: item.item_attachments.map(a => a.url),
    name: name,
    spanishName: spanish_name
  });
};