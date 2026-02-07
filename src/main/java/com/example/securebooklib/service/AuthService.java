package com.example.securebooklib.service;

import com.example.securebooklib.dto.AuthResponse;
import com.example.securebooklib.dto.LoginRequest;
import com.example.securebooklib.dto.RegisterRequest;
import com.example.securebooklib.entity.User;
import com.example.securebooklib.repository.UserRepository;
import com.example.securebooklib.utils.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already taken");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        // Mandatory: Password hashing using BCrypt
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        userRepository.save(user);

        String token = jwtUtil.generateToken(user.getUsername());
        return new AuthResponse(token);
    }

    public AuthResponse login(LoginRequest request) {
        // This validates the username/password against the DB
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        // If authentication passes, generate JWT
        String token = jwtUtil.generateToken(request.getUsername());
        return new AuthResponse(token);
    }
}