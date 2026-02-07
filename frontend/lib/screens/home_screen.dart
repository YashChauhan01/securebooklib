import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book.dart';
import 'add_book_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _refreshBooks() {
    setState(() {
      _booksFuture = _apiService.getBooks();
    });
  }

  void _logout() async {
    await _apiService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const LoginScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Private Library"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No books found. Add one!"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                leading: const Icon(Icons.book),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Wait for the result from AddBookScreen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookScreen()),
          );
          // If a book was added, refresh the list
          if (result == true) {
            _refreshBooks();
          }
        },
      ),
    );
  }
}