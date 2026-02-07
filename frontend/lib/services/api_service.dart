import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/book.dart';
import '../models/book.dart';

class ApiService {
  // ✅ FOR ANDROID EMULATOR: Use 10.0.2.2
  // ❌ FOR REAL DEVICE: Use your computer's Wi-Fi IP (e.g., 192.168.x.x)
  // ❌ FOR WEB/iOS SIMULATOR: Use localhost
  static const String baseUrl = "http://10.0.2.2:8080/api"; 
  
  // Secure storage to keep the JWT token safe
  final _storage = const FlutterSecureStorage();

  // 1. Login & Save Token
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Extract token from JSON
        final token = jsonDecode(response.body)['token'];
        // Save it securely on the device
        await _storage.write(key: 'jwt_token', value: token); 
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // 2. Register New User
  Future<bool> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // 3. Get All Books (Requires Token)
  Future<List<Book>> getBooks() async {
    // Retrieve the token we saved earlier
    String? token = await _storage.read(key: 'jwt_token');
    
    final response = await http.get(
      Uri.parse('$baseUrl/books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Attach the token!
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      // Convert list of JSON objects to list of Book objects
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books. Status: ${response.statusCode}');
    }
  }

  // 4. Add a Book (Requires Token)
  Future<void> addBook(Book book) async {
    String? token = await _storage.read(key: 'jwt_token');

    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add book');
    }
  }

  // 5. Logout
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}