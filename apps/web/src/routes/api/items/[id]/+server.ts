import { supabase } from '$lib/supabaseClient.js';
import { json } from '@sveltejs/kit';

export const GET = async ({ params }) => {
  const { id } = params;
  const { data: items } = await supabase.from('items')
    .select(`
      *,
      attachments:item_attachments ( url ),
      images:item_images ( url ),
      things ( id, eye_protection, name, spanish_name ),
      loans:loans_items (
        *,
        loan_details:loans ( * )
      )
    `)
    .eq('id', id)
    .eq('loans_items.returned', false);

  const item = items?.[0];
  const { eye_protection, name, spanish_name } = item.things;
  const hasActiveLoan = !!item.loans.length;

  return json({
    id: item.id,
    available: !hasActiveLoan,
    availableDate: item.loans.length ? item.loans[0].loan_details?.due_date : undefined,
    brand: item.brand,
    status: item.status,
    eyeProtection: eye_protection,
    image: item.images.length ? item.images[0].url : undefined,
    number: item.number,
    manuals: item.attachments.map(a => a.url),
    name: name,
    spanishName: spanish_name
  });
};