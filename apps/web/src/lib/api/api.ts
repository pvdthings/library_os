import { API_HOST, API_KEY } from "$env/static/private";
import type { AppData } from "$lib/api/models/AppData";

export const fetchThings = async (fetch): Promise<AppData> => {
  const result = await fetch(`${API_HOST}/web/things`, {
    headers: {
      'x-api-key': API_KEY
    }
  });

  return await result.json();
};