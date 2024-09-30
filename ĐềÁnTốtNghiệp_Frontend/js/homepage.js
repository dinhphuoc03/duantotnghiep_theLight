        // Xử lý cuộn trang
        let prevScrollPos = window.pageYOffset;
        const navbarTop = document.querySelector('.navbar-top');
        const navbarBottom = document.querySelector('.navbar-bottom');
        const navbarScrolled = document.querySelector('.navbar-scrolled');

        window.onscroll = function () {
            let currentScrollPos = window.pageYOffset;

            if (currentScrollPos === 0) {
                // Khi ở đầu trang
                navbarTop.style.top = "0"; // Hiện lại navbar-top
                navbarBottom.style.top = "35px"; // Hiện lại navbar-bottom
                navbarScrolled.style.display = "none"; // Ẩn navbar-scrolled
            } else {
                // Khi không ở đầu trang
                navbarTop.style.top = "-35px"; // Ẩn navbar-top
                navbarBottom.style.top = "-60px"; // Ẩn navbar-bottom
                navbarScrolled.style.display = "block"; // Hiện navbar-scrolled
            }

            prevScrollPos = currentScrollPos;
        }




        // Card di chuyển
        const tourCardContainer = document.querySelector('.tour-card-container');
        const tourCards = document.querySelectorAll('.tour-card');
        const prevBtn = document.querySelector('.prev-btn');
        const nextBtn = document.querySelector('.next-btn');
        const bullets = document.querySelectorAll('.tp-bullet'); // Lấy tất cả các nút chỉ số
        const totalCards = tourCards.length;
        const cardsToShow = 3;
        let currentIndex = 0;

        // Clone thẻ đầu và cuối
        const firstCardClone = tourCards[0].cloneNode(true);
        const secondCardClone = tourCards[1].cloneNode(true);
        const thirdCardClone = tourCards[2].cloneNode(true);
        const lastCardClone = tourCards[totalCards - 1].cloneNode(true);
        const secondLastCardClone = tourCards[totalCards - 2].cloneNode(true);
        const thirdLastCardClone = tourCards[totalCards - 3].cloneNode(true);

        // Gắn thẻ clone vào container
        tourCardContainer.appendChild(firstCardClone);
        tourCardContainer.appendChild(secondCardClone);
        tourCardContainer.appendChild(thirdCardClone);
        tourCardContainer.insertBefore(lastCardClone, tourCards[0]);
        tourCardContainer.insertBefore(secondLastCardClone, tourCards[0]);
        tourCardContainer.insertBefore(thirdLastCardClone, tourCards[0]);

        // Cập nhật số thẻ sau khi clone
        const updatedTourCards = document.querySelectorAll('.tour-card');
        const totalUpdatedCards = updatedTourCards.length;

        // Hàm để cập nhật vị trí của các thẻ
        function updateCardPosition(transition = true) {
            const cardWidth = updatedTourCards[0].offsetWidth + 20;
            tourCardContainer.style.transition = transition ? 'transform 0.4s ease' : 'none';
            tourCardContainer.style.transform = `translateX(-${currentIndex * cardWidth}px)`;
            updateBullets(); // Cập nhật trạng thái của các nút chỉ số
        }

        // Hàm để cập nhật trạng thái của các nút chỉ số
        function updateBullets() {
            bullets.forEach((bullet, index) => {
                bullet.classList.remove('active'); // Xóa lớp active khỏi tất cả các nút
            });

            // Cập nhật trạng thái active cho nút chỉ số
            let bulletIndex = (currentIndex - cardsToShow) % totalCards; // Tính toán chỉ số của bullet
            if (bulletIndex < 0) bulletIndex += totalCards; // Đảm bảo không có chỉ số âm

            bullets[bulletIndex].classList.add('active');
        }

        // Hàm tự động chuyển card
        function autoSlide() {
            currentIndex++;
            updateCardPosition();

            // Khi đến cuối danh sách các thẻ, lặp lại từ đầu
            if (currentIndex >= totalUpdatedCards - cardsToShow) {
                setTimeout(function () {
                    currentIndex = cardsToShow;
                    updateCardPosition(false);
                }, 400);
            }
        }

        // Tự động chuyển thẻ sau mỗi 4 giây
        setInterval(autoSlide, 4000); // Chuyển động sau 4 giây

        // Sự kiện khi nhấn nút "Next"
        nextBtn.addEventListener('click', function () {
            currentIndex++;
            if (currentIndex >= totalUpdatedCards - cardsToShow) {
                currentIndex = cardsToShow;
            }
            updateCardPosition();
        });

        // Sự kiện khi nhấn nút "Prev"
        prevBtn.addEventListener('click', function () {
            currentIndex--;
            if (currentIndex < 0) {
                currentIndex = totalUpdatedCards - cardsToShow * 2;
            }
            updateCardPosition();
        });

        // Khởi tạo vị trí ban đầu là ngay sau các thẻ clone cuối cùng
        currentIndex = cardsToShow;
        updateCardPosition(false);


        


        const options = document.querySelectorAll('.search-option');
const searchContents = document.querySelectorAll('.search-content');

options.forEach(option => {
    option.addEventListener('click', () => {
        // Xóa trạng thái active từ tất cả các tab
        options.forEach(opt => opt.classList.remove('active'));
        // Hiện tab đã chọn
        option.classList.add('active');
        
        const searchType = option.getAttribute('data-search-type');
        
        searchContents.forEach(content => {
            if (content.id === `${searchType}-search`) {
                content.style.display = 'block';
            } else {
                content.style.display = 'none';
            }
        });
    });
});

        
        