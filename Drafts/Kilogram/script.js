document.addEventListener('DOMContentLoaded', () => {
    
    // --- Like Function ---
    function toggleBtn(element, emptyIcon, filledIcon, activeClass) {
        // Toggle between outlined heart and filled heart
        element.classList.toggle(emptyIcon);
        element.classList.toggle(filledIcon);
        element.classList.toggle(activeClass);

        // Subtle bounce animation effect
        element.style.transform = 'scale(1.2)';

        setTimeout(() => {
            element.style.transform = 'scale(1)';
        }, 150);
    }

    // --- Like Button Interaction ---
    const likeButtons = document.querySelectorAll('.like-btn');
    
    likeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            toggleBtn(this, 'ph', 'ph-fill', 'liked');
        });
    });

    // --- Save/Bookmark Interaction ---
    const saveButtons = document.querySelectorAll('.save-btn');
    
    saveButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            // Toggle between outlined bookmark and filled bookmark
            toggleBtn(this, 'ph', 'ph-fill', 'saved');
        });
    });

    // --- Navigation Switching Logic ---
    
    // 1. Select the HTML elements we want to interact with
    const views = [
        document.getElementById('home-view'),
        document.getElementById('profile-view'),
        document.getElementById('search-view')
    ];
    
    const navItems = [
        document.getElementById('nav-home'),
        document.getElementById('nav-profile'),
        document.getElementById('nav-search')
    ];

    function activateView(viewId, navId) {
        views.forEach(view => { if (view) view.style.display = 'none'; });
        navItems.forEach(nav => { if (nav) nav.classList.remove('active'); });

        document.getElementById(viewId).style.display = 'block';
        document.getElementById(navId).classList.add('active');
    }

    document.getElementById('nav-home').addEventListener('click', () => {activateView('home-view', 'nav-home')});
    document.getElementById('nav-profile').addEventListener('click', () => {activateView('profile-view', 'nav-profile')});
    document.getElementById('nav-search').addEventListener('click', () => {activateView('search-view', 'nav-search')});

    // 3. Attach click listeners to the sidebar buttons
    navProfile.addEventListener('click', function() {
        // When Profile is clicked: show profile, hide home
        switchView(profileView, homeView, navProfile, navHome);
    });

    navHome.addEventListener('click', function() {
        // When Home is clicked: show home, hide profile
        switchView(homeView, profileView, navHome, navProfile);
    });

    // --- Double Click Image to Like ---
    const postImages = document.querySelectorAll('.post-image');
    
    postImages.forEach(image => {
        image.addEventListener('dblclick', function() {
            // Find the closest like button within the same post card
            const postCard = this.closest('.post-card');
            const likeBtn = postCard.querySelector('.like-btn');
            
            // If it's not already liked, trigger the like state
            if (!likeBtn.classList.contains('liked')) {
                toggleBtn(likeBtn, 'ph', 'ph-fill', 'liked');
            }
        });
    });
});