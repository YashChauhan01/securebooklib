import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    
    // Call the API
    bool success = await _apiService.login(
      _usernameController.text, 
      _passwordController.text
    );

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      // Navigate to Home on success
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScreen())
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed! Check credentials.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Library Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}