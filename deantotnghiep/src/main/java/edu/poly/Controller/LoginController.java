package edu.poly.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import edu.poly.Service.UserService;
import edu.poly.model.User;

@Controller
public class LoginController {
    
    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, RedirectAttributes redirectAttributes) {
        boolean isValidUser = userService.login(username, password);
        
        if (isValidUser) {
            String role = userService.getRole(username);
            if ("Admin".equals(role)) {
                return "redirect:/admin/home";  // Điều hướng đến trang Admin nếu là Admin
            } else if ("Customer".equals(role)) {
                return "redirect:/customer/home";  // Điều hướng đến trang Customer
            } else if ("ServiceProvider".equals(role)) {
                return "redirect:/service/home";  // Điều hướng đến trang Service Provider
            } else if ("Staff".equals(role)) {
                return "redirect:/staff/home";  // Điều hướng đến trang Staff
            }
        } else {
        	redirectAttributes.addFlashAttribute("error", "Invalid username or password.");
            return "redirect:/index.html";  // Trả về trang đăng nhập nếu thất bại
        }
		return password;
    }
}
