let login = document.querySelector(".login");
let create = document.querySelector(".create");
let forgotPassword = document.querySelector(".forgot-password");
let backToLogin = document.querySelector(".back-to-login");
let signupForm = document.querySelector(".signup");
let signinForm = document.querySelector(".signin");
let forgotPasswordForm = document.querySelector(".forgot-password-form");

// Hiển thị form đăng nhập
login.onclick = function() {
  signinForm.style.display = "flex";
  signupForm.style.display = "none";
  forgotPasswordForm.style.display = "none";
};

// Hiển thị form đăng ký
create.onclick = function() {
  signupForm.style.display = "flex";
  signinForm.style.display = "none";
  forgotPasswordForm.style.display = "none";
};

// Hiển thị form quên mật khẩu
forgotPassword.onclick = function() {
  forgotPasswordForm.style.display = "flex";
  signinForm.style.display = "none";
  signupForm.style.display = "none";
};

// Trở về form đăng nhập từ form quên mật khẩu
backToLogin.onclick = function() {
  signinForm.style.display = "flex";
  forgotPasswordForm.style.display = "none";
};

