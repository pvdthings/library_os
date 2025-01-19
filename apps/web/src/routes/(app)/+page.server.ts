import type { AppData } from '$lib/api/models/AppData';
import { fetchThings } from '$lib/api/api.js'

export const load = async ({ fetch }): Promise<AppData> => {
  return fetchThings(fetch);
}