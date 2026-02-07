package com.example.securebooklib.repository;

import com.example.securebooklib.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    // Used to find a user during Login to verify password
    Optional<User> findByUsername(String username);

    // Check if user exists before registering (prevent duplicates)
    Boolean existsByUsername(String username);
}
