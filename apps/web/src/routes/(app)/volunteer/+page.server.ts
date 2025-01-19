import { API_HOST, API_KEY } from "$env/static/private";
import { fail } from "@sveltejs/kit";

export const load = async ({ cookies, fetch }): Promise<any> => {
  const email = cookies.get('email');
  const firstName = cookies.get('firstName');
  const keyholder = cookies.get('keyholder');

  const response = await fetch(`${API_HOST}/web/volunteer/shifts`, {
    headers: {
      'x-api-key': API_KEY,
      'x-email': email
    }
  });

  return {
    shifts: await response.json(),
    authenticated: !!email,
    firstName,
    keyholder: !!email && keyholder
  };
};

export const actions = {
  authenticate: async ({ cookies, fetch, request }) => {
    const data = await request.formData();
    const email = data.get('email').toString().toLowerCase();

    if (!email) {
      return fail(400, { invalid: true });
    }

    const response = await fetch(`${API_HOST}/web/volunteer/auth`, {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'x-api-key': API_KEY
			},
			body: JSON.stringify({ email })
		});

    if (response.ok) {
      const member = await response.json();

      cookies.set('firstName', member.name.split(' ')?.[0], { path: '/' });
      cookies.set('email', email, { path: '/' });
      cookies.set('keyholder', member.keyholder, { path: '/' });

      return { success: true };
    }

    return fail(403, { email, unauthorized: response.status === 403 });
  },
  unauthenticate: async ({ cookies }) => {
    cookies.delete('firstName', { path: '/' });
    cookies.delete('email', { path: '/' });
    cookies.delete('keyholder', { path: '/' });
    return { success: true };
  },
  confirm: async ({ cookies, fetch, request }) => {
    const email = cookies.get('email');

    const data = await request.formData();
    const shifts = data.getAll('shifts').map((s) => JSON.parse(s.toString()));

    const response = await fetch(`${API_HOST}/web/volunteer/shifts/enroll`, {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'x-api-key': API_KEY,
        'x-email': email
			},
			body: JSON.stringify({ shifts })
		});

    return { success: response.ok };
  }
};