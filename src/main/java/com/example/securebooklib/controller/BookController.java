package com.example.securebooklib.controller;

import com.example.securebooklib.dto.BookDTO;
import com.example.securebooklib.service.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/books")
@RequiredArgsConstructor
public class BookController {

    private final BookService bookService;

    @GetMapping
    public ResponseEntity<List<BookDTO>> getAllBooks(Authentication authentication) {
        // authentication.getName() returns the username extracted from JWT
        return ResponseEntity.ok(bookService.getUserBooks(authentication.getName()));
    }

    @PostMapping
    public ResponseEntity<BookDTO> addBook(@RequestBody BookDTO bookDTO, Authentication authentication) {
        return ResponseEntity.ok(bookService.addBook(bookDTO, authentication.getName()));
    }
}
