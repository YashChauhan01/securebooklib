package com.example.securebooklib.service;

import com.example.securebooklib.dto.BookDTO;
import com.example.securebooklib.entity.Book;
import com.example.securebooklib.entity.User;
import com.example.securebooklib.repository.BookRepository;
import com.example.securebooklib.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;
    private final UserRepository userRepository;

    public List<BookDTO> getUserBooks(String username) {
        User user = getUserByUsername(username);
        // Requirement: Users can access only their own books
        return bookRepository.findByUserId(user.getId()).stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    public BookDTO addBook(BookDTO bookDTO, String username) {
        User user = getUserByUsername(username);

        Book book = new Book();
        book.setTitle(bookDTO.getTitle());
        book.setAuthor(bookDTO.getAuthor());
        book.setUser(user); // Link book to current user

        Book savedBook = bookRepository.save(book);
        return mapToDTO(savedBook);
    }

    // Helper method to satisfy "No entity exposure" [cite: 37]
    private BookDTO mapToDTO(Book book) {
        return new BookDTO(book.getId(), book.getTitle(), book.getAuthor());
    }

    private User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}