import { fetchThings } from '$lib/server/api.js'

export const load = async ({ fetch }) => {
  return fetchThings(fetch);
}