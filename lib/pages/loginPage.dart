import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/homePage.dart';
import 'package:nyobatugasakhir2/services/dbHelper.dart';
import 'registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    bool isAuthenticated = await DatabaseHelper.instance.authenticate(username, password);

    if (isAuthenticated) {
      // Simpan username ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(currentUser: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding( 
        padding: EdgeInsets.all(16.0),
        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/f1.png',
              height: 70,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle obscure text
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
