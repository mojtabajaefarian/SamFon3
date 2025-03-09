// اسلایدر
class HeroSlider {
    constructor(config) {
        this.slides = document.querySelectorAll(".slide");
        this.currentIndex = 0;
        this.interval = config.interval;
        this.animationDuration = config.animationDuration;
        this.init();
    }

    init() {
        setInterval(() => this.nextSlide(), this.interval);
    }

    nextSlide() {
        this.slides[this.currentIndex].classList.remove("active");
        this.currentIndex = (this.currentIndex + 1) % this.slides.length;
        this.slides[this.currentIndex].classList.add("active");
    }
}

// مقداردهی اولیه
document.addEventListener("DOMContentLoaded", () => {
    new HeroSlider({
        interval: 5000,
        animationDuration: 700,
    });
});
