import type { AppData } from '$lib/api/models/AppData';
import { API_HOST, API_KEY } from '$env/static/private';

export const load = async ({ fetch }): Promise<AppData> => {
  const result = await fetch(`${API_HOST}/web/catalog`, {
    headers: {
      'x-api-key': API_KEY
    }
  });

  return await result.json();
}