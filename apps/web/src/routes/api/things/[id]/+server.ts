import { supabase } from '$lib/supabaseClient';
import { json } from '@sveltejs/kit';

export const GET = async ({ params }) => {
  const { id } = params;
  const { data: things } = await supabase.from('things')
    .select(`
      id,
      eye_protection,
      hidden,
      name,
      spanish_name,
      items ( id, brand, hidden, number ),
      thing_images ( url )
    `)
    .eq('id', id);

  const thing = things?.[0];

  console.log('thing', thing);

  return json({
    id: thing['id'],
    availableDate: undefined,
    available: thing.items.length, // TODO
    stock: thing.items.length, // TODO
    categories: [], // TODO
    eyeProtection: !!thing['eye_protection'],
    hidden: !!thing['hidden'],
    image: thing.thing_images.length ? thing.thing_images[0].url : undefined,
    items: thing['items'].map(item => ({ ...item, status: 'available' })),
    name: thing['name'],
    spanishName: thing['spanish_name']
  });
};