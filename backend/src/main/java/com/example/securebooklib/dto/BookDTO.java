package com.example.securebooklib.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BookDTO {
    private Long id;
    private String title;
    private String author;
    // We intentionally DO NOT include the User object here to prevent
    // infinite recursion and expose sensitive user data.
}
