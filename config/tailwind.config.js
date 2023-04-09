const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        "slide-down-up": {
          "0%, 100%": { transform: "translateY(-3.5rem)" },
          "30%, 70%": { transform: "translateY(0rem)" },
        },
      },
      animation: {
        "slide-down-up": "slide-down-up 3s ease-in-out forwards",
      },
      width: {
        "ai-menu": "35rem",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
