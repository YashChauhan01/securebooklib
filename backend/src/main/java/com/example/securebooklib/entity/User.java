package com.example.securebooklib.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "users")
@Data // Lombok
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password; // Will store BCrypt hash [cite: 20]

    // One user can have many books
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Book> books;
}
