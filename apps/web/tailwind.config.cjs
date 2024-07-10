/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		extend: {
			boxShadow: {
				lowest: '0 1px 2px rgba(0, 0, 0, 0.25)',
				low: '0 2px 2px rgba(0, 0, 0, 0.25)',
				high: '0 3px 2px rgba(0, 0, 0, 0.25)',
				highest: '0 4px 2px rgba(0, 0, 0, 0.25)'
			},
			fontFamily: {
				display: ['IBM Plex Sans', 'Arial'],
				sans: ['IBM Plex Sans', 'Arial'],
				body: ['Roboto Slab', 'Courier']
			},
			colors: {
				primary: '#ffde59',
				bg: '#282828'
			},
			height: {
				'1/2-screen': '50vh',
				'3/4-screen': '75vh'
			},
			width: {
				largest: '50rem'
			},
			padding: {
				'1/4-screen': '25vw'
			},
			backgroundImage: (theme) => ({
				'long-city': "url('/long-city.png')"
			})
		}
	},
	plugins: [require('daisyui')],
	daisyui: {
		themes: [
			{
				indigo: {
					primary: '#6366f1',
					'primary-content': '#f3f4f6',
					secondary: '#e5e7eb',
					'secondary-content': '#101011',
					accent: '#fcd34d',
					'accent-content': '#78350f',
					neutral: '#d1d5db',
					'neutral-content': '#101011',
					'base-100': '#f3f4f6',
					'base-200': '#e5e7eb',
					'base-300': '#d1d5db',
					'base-content': '#111827',
					info: '#fcd34d',
					'info-content': '#78350f',
					success: '#86efac',
					'success-content': '#14532d',
					warning: '#fed7aa',
					'warning-content': '#7c2d12',
					error: '#fca5a5',
					'error-content': '#7f1d1d',
          '--btn-text-case': 'none',
					'--rounded-box': '6px'
				}
			}
		]
	}
};
