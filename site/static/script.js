const carousel = q(".carousel");

if (carousel) {
  // Select the first image and clone it for infinite scrolling
  const firstImage = carousel.querySelector("img");
  const clonedImage = firstImage.cloneNode(true);
  carousel.appendChild(clonedImage);

  // Wrap each image inside a div container
  carousel.querySelectorAll("img").forEach((image) => {
    const wrapper = document.createElement("div");
    wrapper.style.display = "inline-block";
    wrapper.style.width = "100vw";
    wrapper.style.height = "100vh";
    wrapper.appendChild(image.cloneNode(true)); // Clone the image into the wrapper
    carousel.appendChild(wrapper); // Append the wrapper to the carousel
    image.remove(); // Remove the original image
  });

  let carouselWidth = carousel.scrollWidth;
  let visibleWidth = carousel.clientWidth;
  let scrollAmount = 0;
  let isAutoScrolling = false;
  let autoScrollInterval;

  // Snap to the closest image after manual scroll
  carousel.addEventListener("scroll", () => {
    if (!isAutoScrolling) {
      const scrollPosition = carousel.scrollLeft;
      const images = carousel.querySelectorAll("div");
      let closestImageIndex = 0;
      let closestDistance = Infinity;

      images.forEach((image, index) => {
        const imageLeft = image.offsetLeft;
        const distance = Math.abs(imageLeft - scrollPosition);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestImageIndex = index;
        }
      });

      const closestImage = images[closestImageIndex];
      carousel.scrollTo({
        left: closestImage.offsetLeft,
        behavior: "smooth",
      });

      // Reset to the first image if at the cloned last image
      if (closestImageIndex === images.length - 1) {
        setTimeout(() => {
          carousel.scrollTo({
            left: 0,
            behavior: "auto", // Instant reset to the first image
          });
          scrollAmount = 0;
        }, 1000);
      }
    }
  });

  // Pause auto-scroll on hover, resume when mouse leaves
  carousel.addEventListener("mouseenter", () => {
    clearInterval(autoScrollInterval); // Pause scrolling when the user hovers over the carousel
  });

  carousel.addEventListener("mouseleave", () => {
    autoScrollInterval = setInterval(autoScroll, 10000); // Resume scrolling when the mouse leaves
  });

  // Function to handle auto-scrolling
  function autoScroll() {
    carouselWidth = carousel.scrollWidth;
    visibleWidth = carousel.clientWidth;

    scrollAmount += visibleWidth;

    if (scrollAmount >= carouselWidth - visibleWidth) {
      isAutoScrolling = true;
      carousel.scrollTo({
        left: scrollAmount,
        behavior: "smooth",
      });

      setTimeout(() => {
        carousel.scrollTo({
          left: 0,
          behavior: "auto",
        });
        scrollAmount = 0;
        isAutoScrolling = false;
      }, 1000);
    } else {
      isAutoScrolling = true;
      carousel.scrollTo({
        left: scrollAmount,
        behavior: "smooth",
      });
      setTimeout(() => {
        isAutoScrolling = false;
      }, 1000);
    }
  }

  // Start the auto-scroll at an interval
  autoScrollInterval = setInterval(autoScroll, 10000);
}

let sidebarOpen = false;

function q(selector) {
  return document.querySelector(selector);
}

function toggleSide() {
  if (sidebarOpen) {
    q(".sidebar").style.left = "";
    q(".album").style.width = "";
  } else {
    q(".sidebar").style.left = "0";
    q(".album").style.width = "calc(100vw - 264px)";
  }

  sidebarOpen = !sidebarOpen;
}

function popup(html) {
  let container = q(".popupContainer");

  if (!container) {
    container = document.createElement("div");
    container.classList.add("popupContainer");
    container.style.position = "fixed";
    container.style.top = "8px";
    container.style.right = "8px";

    document.body.appendChild(container);
  }

  const popup = document.createElement("div");
  popup.style.background = "var(--h)";
  popup.style.borderRadius = "8px";
  popup.style.padding = "8px";
  popup.style.boxShadow = "0 0 8px var(--a)";
  popup.style.marginBottom = "8px";
  popup.style.maxWidth = "calc(50vw - 24px)";
  popup.style.overflowWrap = "break-word";
  popup.innerHTML = html;

  container.appendChild(popup);

  popup.addEventListener("click", () => popup.remove());
}
