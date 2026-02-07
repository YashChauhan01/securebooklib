package com.example.securebooklib.repository;

import com.example.securebooklib.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BookRepository extends JpaRepository<Book, Long> {
    // Finds all books belonging to a specific User ID
    List<Book> findByUserId(Long userId);
}
