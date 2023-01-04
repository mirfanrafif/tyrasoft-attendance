import 'package:flutter/material.dart';
import 'package:tyrasoft_attendance/pages/home.dart';
import 'package:tyrasoft_attendance/style/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: const FlutterLogo(),
              width: double.infinity,
              padding: const EdgeInsets.all(64),
            ),
            TextField(
              maxLines: 1,
              decoration: getInputDecoration("Username"),
              controller: _usernameController,
              onChanged: (String username) {},
            ),
            const SizedBox(
              width: 16,
              height: 16,
            ),
            TextField(
              maxLines: 1,
              decoration: getInputDecoration("Password"),
              controller: _passwordController,
              obscureText: true,
              onChanged: (String password) {},
            ),
            const SizedBox(
              width: 16,
              height: 16,
            ),
            getButton("Login", login)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
