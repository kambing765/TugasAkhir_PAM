import 'package:flutter/material.dart';
import 'package:nyobatugasakhir2/pages/loginPage.dart';
import 'package:nyobatugasakhir2/services/dbHelper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and Password cannot be empty!')),
      );
      return;
    }

    if (username.length < 5 || password.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and Password must be at least 5 characters long!')),
      );
      return;
    }

    bool usernameExists = await DatabaseHelper.instance.isUsernameExists(username);

    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username already exists!')),
      );
    } else {
      await DatabaseHelper.instance.addUser(username, password); // Password otomatis di-hash

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/f1.png',
              width: 70,
              fit: BoxFit.contain,
            ),
            SizedBox( width: 10,),
            Text('Register' ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(onPressed: register, child: Text('Register')),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
