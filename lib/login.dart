import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final String userNotFoundText = "No user found for that email.";
  final String wrongPasswordText = "Wrong password provided for that user.";
  final String invalidCredentialsText = "Invalid credentials for that user.";

  //Login which uses firebase authentication to sign in
  Future<void> _login() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
      } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar(userNotFoundText));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar(wrongPasswordText));
      } else if (e.code == 'invalid-credential') {
        print("lol");
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar(invalidCredentialsText));

      }
    } on PlatformException catch (e){
      print(e.code);
    }
  }

  SnackBar errorSnackbar(String text) => SnackBar(content: Text(text), backgroundColor: Colors.grey);


  // Scaffold for the login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //logo goes here

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
            ),
            const SizedBox(height: 100,),
            const SizedBox(
              width: 220,
              child: Text(
                'Nutritional values shown in this application are approximations based '
                'on open data provided by Finnish Institute for Health and Welfare ' 
                '(Terveyden ja hyvinvoinnin latios), Fineli and may not be entirely accuate.', 
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.teal
                ),
              ),
            ),
            const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}