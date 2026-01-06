document.addEventListener('DOMContentLoaded', function() {
    
    // Get all necessary elements
    const giftBox = document.getElementById('gift-box');
    const introPage = document.querySelector('.intro-page');
    const birthdaySong = document.getElementById('birthday-song');
    const likeButton = document.getElementById('like-button');
    const likeCounter = document.getElementById('like-counter');
    const fireworksContainer = document.getElementById('fireworks-container');
    const fallingItemsContainer = document.getElementById('falling-items-container');

    // Fireworks settings (no change needed here)
    const fireworks = new Fireworks.Fireworks(fireworksContainer, {
        autoresize: true, opacity: 0.5, acceleration: 1.05, friction: 0.97, gravity: 1.5,
        particles: 80, traceLength: 3, explosion: 10, intensity: 30, flickering: 50,
        lineStyle: 'round', hue: { min: 0, max: 360 }, delay: { min: 30, max: 60 },
        rocketsPoint: { min: 0, max: 100 }, lineWidth: { explosion: { min: 1, max: 4 }, trace: { min: 1, max: 2 } },
        brightness: { min: 50, max: 80 }, decay: { min: 0.01, max: 0.02 }, mouse: { click: false, move: false, max: 1 }
    });

    // Swiper initialization (no change needed here)
    const swiper = new Swiper('.swiper', {
        effect: 'cards', grabCursor: true,
        cardsEffect: { perSlideOffset: 8, perSlideRotate: 2, rotate: true, slideShadows: true },
    });

    // --- Raining Hearts and Roses Functionality (THE DEFINITIVE FIX) ---
    const items = ['❤️', '🌹', '😊', '🥳', '🥰', '🎉', '🤩', '✨'];
    
    function createFallingItem() {
        const item = document.createElement('div');
        item.classList.add('falling-item');
        item.innerText = items[Math.floor(Math.random() * items.length)];

        // Randomize properties for a natural look
        const duration = Math.random() * 3 + 5; // Duration between 5s and 8s
        const delay = Math.random() * 2;       // Delay up to 2s

        item.style.left = Math.random() * 100 + 'vw';
        item.style.fontSize = Math.random() * 1.5 + 1 + 'rem';
        item.style.opacity = Math.random() * 0.5 + 0.5; // Opacity between 0.5 and 1.0

        // THIS IS THE FIX: Set the entire animation property in one go.
        // Format: 'animation-name animation-timing-function duration delay'
        item.style.animation = `fall linear ${duration}s ${delay}s`;
        
        fallingItemsContainer.appendChild(item);

        // Remove the item after it falls to keep the page clean
        setTimeout(() => {
            item.remove();
        }, (duration + delay) * 1000); // Remove after its full animation cycle
    }

    // Handle the gift box click
    giftBox.addEventListener('click', () => {
        introPage.classList.add('hidden');
        fireworks.start();
        birthdaySong.play().catch(e => console.error("Audio play failed:", e));
        setInterval(createFallingItem, 300);
        setTimeout(() => { fireworks.stop(); }, 6000);
        setTimeout(() => { introPage.style.display = 'none'; }, 1000);
    });

    // Like Button Interactivity (no change needed here)
    if (likeButton) {
        let isLiked = false;
        likeButton.addEventListener('click', () => {
            isLiked = !isLiked;
            let currentLikes = parseInt(likeCounter.innerText.replace(/,/g, ''));
            if (isLiked) {
                likeButton.classList.add('liked');
                currentLikes++;
            } else {
                likeButton.classList.remove('liked');
                currentLikes--;
            }
            likeCounter.innerText = currentLikes.toLocaleString('en-US');
        });
    }
});
// Find your swiper initialization...
const swiper = new Swiper('.swiper', {
    effect: 'cards', grabCursor: true,
    cardsEffect: { perSlideOffset: 8, perSlideRotate: 2, rotate: true, slideShadows: true },
});

// --- [NEW] HIDE SWIPE ARROW ON INTERACTION ---
// Add this code right below it.
const swipeIndicator = document.querySelector('.swipe-indicator');
swiper.on('slideChange', function () {
    // When the slide changes for the first time, hide the arrow.
    swipeIndicator.style.display = 'none';
});