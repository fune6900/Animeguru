module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      keyframes: {
        slideIn: {
          '0%': { transform: 'translateX(100%)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
      },
      animation: {
        'slide-in': 'slideIn 0.3s ease-out',
        'fade-out': 'fadeOut 0.5s ease-in-out',
      },
      colors: {
        primary: '#6AB9DF',
        secondary: '#5B9CBD',
        accent: '#3F85C5',
        'base-100': '#E2F4FD',      },
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: "#6AB9DF",
          secondary: "#5B9CBD",
          accent: "#3F85C5",
          "base-100": "#E2F4FD",
        },
      },
    ],
  },
}