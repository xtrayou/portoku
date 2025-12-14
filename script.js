// Modal Functions
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto'; // Re-enable scrolling
    }
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

// Close modal with ESC key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            modal.style.display = 'none';
        });
        document.body.style.overflow = 'auto';
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
                observer.unobserve(entry.target); // Only animate once
            }
        });
    }, observerOptions);

    // Select elements to animate
    const animatedElements = document.querySelectorAll('.portfolio, .portfolio-1a, .portfolio-22, .card, .card-1c, .card-25, .stunning-introduction, .front-end-developer-portfolio, .skills-technologies, .experience, .contact');
    
    animatedElements.forEach(el => {
        el.classList.add('hidden');
        observer.observe(el);
    });

    // Auto slideshow for project images
    initProjectSlideshow();
});

// Project Image Slideshow
function initProjectSlideshow() {
    const projectImages = {
        papais: 8,
        puskesmas: 8,
        guacamole: 2,
        dashboard: 6
    };

    const projectElements = document.querySelectorAll('.project-image[data-project]');
    
    projectElements.forEach(element => {
        const projectName = element.getAttribute('data-project');
        const maxImages = projectImages[projectName] || 1;
        let currentIndex = 1;

        // Set initial image
        element.style.backgroundImage = `url('foto/${projectName} (${currentIndex}).png')`;

        // Auto change image every 3 seconds
        setInterval(() => {
            currentIndex = (currentIndex % maxImages) + 1;
            element.style.backgroundImage = `url('foto/${projectName} (${currentIndex}).png')`;
        }, 3000);
    });
}

// Contact Form Handler
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value;
            
            // Create email body
            const emailBody = `Name: ${name}%0D%0AEmail: ${email}%0D%0A%0D%0AMessage:%0D%0A${message}`;
            
            // Create mailto link
            const mailtoLink = `mailto:silmiyushini1919@gmail.com?subject=${encodeURIComponent(subject)}&body=${emailBody}`;
            
            // Open email client
            window.location.href = mailtoLink;
            
            // Optional: Show success message
            alert('Opening your email client...');
            
            // Reset form
            contactForm.reset();
        });
    }
});
