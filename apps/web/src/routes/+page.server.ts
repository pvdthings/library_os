import type { AppData } from '$lib/models/AppData';
import { fetchThings } from '$lib/server/api.js'

export const load = async ({ fetch }): Promise<AppData> => {
  return fetchThings(fetch);
}