package edu.poly.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import edu.poly.database.UserRepository;
import edu.poly.model.User;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public boolean login(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return true; // Đăng nhập thành công
        }
        return false; // Đăng nhập thất bại
    }

    public String getRole(String username) {
        User user = userRepository.findByUsername(username);
        if (user != null) {
            return user.getRole(); // Trả về vai trò của người dùng
        }
        return null; // Người dùng không tồn tại
    }
}

