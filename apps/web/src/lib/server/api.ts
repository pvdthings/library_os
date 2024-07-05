import type { AppData } from "$lib/models/AppData";
import { API_HOST, API_KEY } from "$env/static/private";

export const fetchThings = async (fetch): Promise<AppData> => {
  const host = !!API_HOST ? API_HOST : 'http://localhost:8088';
  const result = await fetch(`${host}/things`, {
    headers: {
      'x-api-key': API_KEY
    }
  });

  return await result.json();
};