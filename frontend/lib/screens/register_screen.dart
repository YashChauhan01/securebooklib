import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    bool success = await _apiService.register(
      _usernameController.text, 
      _passwordController.text
    );
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Please Login.')),
      );
      Navigator.pop(context); // Go back to Login Screen
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Failed. Try a different username.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Choose Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Choose Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
          ],
        ),
      ),
    );
  }
}