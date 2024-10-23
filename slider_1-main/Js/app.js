//step 1: get DOM
let nextDom = document.getElementById('next');
let prevDom = document.getElementById('prev');

let carouselDom = document.querySelector('.carousel');
let SliderDom = carouselDom.querySelector('.carousel .list');
let thumbnailBorderDom = document.querySelector('.carousel .thumbnail');
let thumbnailItemsDom = thumbnailBorderDom.querySelectorAll('.item');
let timeDom = document.querySelector('.carousel .time');

thumbnailBorderDom.appendChild(thumbnailItemsDom[0]);
let timeRunning = 3000;
let timeAutoNext = 7000;

nextDom.onclick = function(){
    showSlider('next');    
}

prevDom.onclick = function(){
    showSlider('prev');    
}
let runTimeOut;
let runNextAuto = setTimeout(() => {
    next.click();
}, timeAutoNext)
function showSlider(type){
    let  SliderItemsDom = SliderDom.querySelectorAll('.carousel .list .item');
    let thumbnailItemsDom = document.querySelectorAll('.carousel .thumbnail .item');
    
    if(type === 'next'){
        SliderDom.appendChild(SliderItemsDom[0]);
        thumbnailBorderDom.appendChild(thumbnailItemsDom[0]);
        carouselDom.classList.add('next');
    }else{
        SliderDom.prepend(SliderItemsDom[SliderItemsDom.length - 1]);
        thumbnailBorderDom.prepend(thumbnailItemsDom[thumbnailItemsDom.length - 1]);
        carouselDom.classList.add('prev');
    }
    clearTimeout(runTimeOut);
    runTimeOut = setTimeout(() => {
        carouselDom.classList.remove('next');
        carouselDom.classList.remove('prev');
    }, timeRunning);

    clearTimeout(runNextAuto);
    runNextAuto = setTimeout(() => {
        next.click();
    }, timeAutoNext)
}


/* xong phần header */


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











let carouselIndex = 0;
const cards = document.getElementById('hotelCards');
const prevArrow = document.querySelector('.prev-arrow');
const nextArrow = document.querySelector('.next-arrow');

function filterHotels(category) {
    const hotelCards = document.getElementsByClassName('hotel-card');
    let visibleCardCount = 0;

    // Lọc thẻ khách sạn dựa trên danh mục đã chọn
    for (let i = 0; i < hotelCards.length; i++) {
        if (category === 'all' || hotelCards[i].classList.contains(category)) {
            hotelCards[i].style.display = 'block';
            visibleCardCount++;
        } else {
            hotelCards[i].style.display = 'none';
        }
    }

    // Cập nhật nút lọc đang hoạt động
    const filterButtons = document.getElementsByClassName('filter-btn');
    for (let j = 0; j < filterButtons.length; j++) {
        filterButtons[j].classList.remove('active');
    }
    // Thêm lớp đang hoạt động vào nút đã nhấp
    event.target.classList.add('active');

    // Đặt lại vị trí carousel sau khi lọc
    carouselIndex = 0;
    scrollCarousel(0);

    // Kiểm tra và cập nhật hiển thị của các nút điều hướng
    updateArrowsVisibility(visibleCardCount);
}

function scrollCarousel(direction) {
    const cardWidth = 670; // Chiều rộng của 4 thẻ cộng với khoảng cách
    const maxScroll = cards.scrollWidth - cards.clientWidth;

    // Điều chỉnh carouselIndex dựa trên hướng
    carouselIndex += direction * cardWidth;

    // Giữ chỉ mục vòng quay trong giới hạn
    if (carouselIndex < 0) {
        carouselIndex = 0;
    } else if (carouselIndex > maxScroll) {
        carouselIndex = maxScroll;
    }

    // Cuộn carousel đến vị trí mới
    cards.scrollLeft = carouselIndex;

    // Cập nhật hiển thị của các nút điều hướng
    updateArrowsVisibility(getVisibleCardCount());
}

function updateArrowsVisibility(visibleCardCount) {
    // Chỉ hiển thị nút điều hướng khi có nhiều hơn 4 thẻ hiển thị
    if (visibleCardCount > 4) {
        prevArrow.style.visibility = carouselIndex > 0 ? 'visible' : 'hidden';
        nextArrow.style.visibility = carouselIndex < cards.scrollWidth - cards.clientWidth ? 'visible' : 'hidden';
    } else {
        prevArrow.style.visibility = 'hidden';
        nextArrow.style.visibility = 'hidden';
    }
}

// Hàm để đếm số thẻ đang hiển thị
function getVisibleCardCount() {
    const hotelCards = document.getElementsByClassName('hotel-card');
    let count = 0;

    for (let i = 0; i < hotelCards.length; i++) {
        if (hotelCards[i].style.display === 'block') {
            count++;
        }
    }
    return count;
}

// Gọi hàm filterHotels với tham số 'all' để hiển thị tất cả thẻ khi trang được tải
window.onload = function() {
    filterHotels('all');
};

// Thêm trình lắng nghe sự kiện cho các nút mũi tên
prevArrow.addEventListener('click', () => scrollCarousel(-1));
nextArrow.addEventListener('click', () => scrollCarousel(1));









  