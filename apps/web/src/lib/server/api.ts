import type { AppData } from "$lib/models/AppData";
import { API_KEY } from "$env/static/private";

export const fetchThings = async (fetch): Promise<AppData> => {
  const host = process.env.API_HOST ?? 'http://localhost:8088';
  const result = await fetch(`${host}/things`, {
    headers: {
      'x-api-key': API_KEY
    }
  });

  const data: AppData = await result.json();
  data.things = data.things.filter(thing => thing.categories);

  return data;
};