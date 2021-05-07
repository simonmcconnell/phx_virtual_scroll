module.exports = {
  mode: "jit",
  purge: [
    "../lib/**/*.html.eex",
    "../lib/**/*.html.leex",
    "../lib/**/*.ex",
    "./js/**/*.js",
  ],
  variants: {
    extend: {
      opacity: ["disabled"],
      cursor: ["disabled"],
      borderColor: ["disabled"],
      borderRadius: ["hover"],
    },
    boxShadow: ["group-focus", "focus"],
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
