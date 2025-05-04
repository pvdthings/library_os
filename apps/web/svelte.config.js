import adapter from '@sveltejs/adapter-vercel';
import { sveltePreprocess } from 'svelte-preprocess';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: sveltePreprocess({
		postcss: true
	}),
	kit: {
		adapter: adapter(),
		csp: {
			mode: 'hash',
			directives: {
				'default-src': ["'self'"],
				'script-src': ["'self'"], // Add 'nonce-{nonce}' or 'sha256-{hash}' if needed
				'style-src': ["'self'", "'unsafe-inline'", 'https://fonts.googleapis.com'], // Allow inline styles if necessary
				'img-src': ["'self'", 'data:', 'https://v5.airtableusercontent.com'],
				'connect-src': ["'self'"],
				'font-src': ["'self'", 'https://fonts.googleapis.com', 'https://fonts.gstatic.com'],
			}
		}
	}
};

export default config;
