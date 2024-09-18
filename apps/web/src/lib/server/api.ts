import type { AppData } from "$lib/models/AppData";
import { HOST, KEY } from "./env";

export const fetchThings = async (fetch): Promise<AppData> => {
  const result = await fetch(`${HOST}/things`, {
    headers: {
      'x-api-key': KEY
    }
  });

  return await result.json();
};