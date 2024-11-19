import { HOST, KEY } from "$lib/server/env";

export const load = async ({ fetch }): Promise<any> => {
  const response = await fetch(`${HOST}/web/volunteer/shifts`, {
    headers: {
      'x-api-key': KEY
    }
  });

  return {
    shifts: await response.json()
  };
};