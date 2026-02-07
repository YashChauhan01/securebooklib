import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _saveBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
      );
      await _apiService.addBook(newBook);
      if (!mounted) return;
      Navigator.pop(context, true); // Return "true" to refresh the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding book: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Book Title"),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: "Author Name"),
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _saveBook,
                  child: const Text("Save Book"),
                ),
          ],
        ),
      ),
    );
  }
}