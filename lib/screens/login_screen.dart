// ignore_for_file: prefer_const_constructors

import 'package:chatapp/controllers/login_controller.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userForm = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/images/logo.png")),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email Is Required";
                  }
                },
                enableSuggestions: true,
                decoration: InputDecoration(label: Text("Email")),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password Is Required";
                  }
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 50),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        if (userForm.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          await LoginController.login(
                              context: context,
                              email: email.text,
                              password: password.text);
                          isLoading = false;
                          setState(() {});
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account?"),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignupScreen();
                      }));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
