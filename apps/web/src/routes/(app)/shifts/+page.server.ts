import { HOST, KEY } from "$lib/server/env";
import { fail } from "@sveltejs/kit";

export const load = async ({ cookies, fetch }): Promise<any> => {
  const email = cookies.get('email');

  const response = await fetch(`${HOST}/web/volunteer/shifts`, {
    headers: {
      'x-api-key': KEY,
      'x-email': email
    }
  });

  return {
    shifts: await response.json(),
    authenticated: !!email
  };
};

export const actions = {
  authenticate: async ({ cookies, fetch, request }) => {
    const data = await request.formData();
    const email = data.get('email').toString();

    if (!email) {
      return fail(400, { invalid: true });
    }

    const response = await fetch(`${HOST}/web/volunteer/auth`, {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'x-api-key': KEY
			},
			body: JSON.stringify({ email })
		});

    if (response.ok) {
      const member = await response.json();

      cookies.set('firstName', member.name.split(' ')?.[0], { path: '/' });
      cookies.set('email', email, { path: '/' });

      return { success: true };
    }

    return fail(403, { email, unauthorized: response.status === 403 });
  },
  unauthenticate: async ({ cookies }) => {
    cookies.delete('firstName', { path: '/' });
    cookies.delete('email', { path: '/' });
    return { success: true };
  },
  confirm: async ({ cookies, fetch, request }) => {
    const email = cookies.get('email');

    const data = await request.formData();
    const shifts = data.get('shifts');

    const response = await fetch(`${HOST}/web/volunteer/shifts/enroll`, {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'x-api-key': KEY,
        'x-email': email
			},
			body: JSON.stringify({ shifts })
		});

    return { success: response.ok };
  }
};