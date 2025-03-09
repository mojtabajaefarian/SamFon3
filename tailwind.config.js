// tailwind.config.js
module.exports = {
    content: [
        "./resources/**/*.blade.php",
        "./resources/**/*.js",
        "./resources/**/*.vue",
        "./storage/framework/views/*.php",
    ],
    theme: {
        fontFamily: {
            vazir: ["Vazirmatn", "sans-serif"],
        },
        extend: {
            colors: {
                primary: "#3b82f6",
                secondary: "#6366f1",
            },
            animation: {
                "slide-in": "slideIn 0.5s ease-out",
            },
            keyframes: {
                slideIn: {
                    "0%": { transform: "translateX(100%)" },
                    "100%": { transform: "translateX(0)" },
                },
            },
        },
    },
    plugins: [
        require("@tailwindcss/forms"),
        require("@tailwindcss/typography"),
    ],
    rtl: true, // فعالسازی RTL
    important: true, // افزایش Specificity
    darkMode: "class", // حالت تاریک
};
