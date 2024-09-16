import { HOST, KEY } from '$lib/server/env.js';

export const GET = async ({ params }) => {
  const { id } = params;

  return await fetch(`${HOST}/web/things/${id}`, {
    headers: {
      'x-api-key': KEY
    }
  });
};