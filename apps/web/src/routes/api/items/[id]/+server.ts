import { HOST, KEY } from '$lib/server/env.js';

export const GET = async ({ params }) => {
  const { id } = params;

  return await fetch(`${HOST}/web/items/${id}`, {
    headers: {
      'x-api-key': KEY
    }
  });
};