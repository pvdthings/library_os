import { API_HOST, API_KEY } from '$env/static/private';

export const GET = async ({ params }) => {
  const { id } = params;

  return await fetch(`${API_HOST}/web/items/${id}`, {
    headers: {
      'x-api-key': API_KEY
    }
  });
};