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
        primary: "#ffde59",
        bg: "#282828"
      },
      height: {
        "1/2-screen": "50vh",
        "3/4-screen": "75vh"
      },
      width: {
        "largest": "50rem"
      },
      padding: {
        "1/4-screen": "25vw"
      },
      backgroundImage: theme => ({
        "purple-city": "url('/2.png')",
        "long-city": "url('/long-city.png')"
      })
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        pvdthingsTheme: {
          "primary": "#facc15",
          "secondary": "#d8e1ff",       
          "accent": "#a78bfa",
          "neutral": "#2c2537", 
          "base-100": "#e0e7ff",
          "info": "#2563eb", 
          "success": "#54de97",
          "warning": "#fb923c", 
          "error": "#df2926",

          "--btn-text-case": "none",
          "--rounded-box": "6px"
        }
      }
    ]
  },
}
