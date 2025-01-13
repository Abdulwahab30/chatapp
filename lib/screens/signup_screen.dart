import 'package:chatapp/controllers/signup_controller.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: userForm,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/images/logo.png")),
                const SizedBox(
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
                  decoration: InputDecoration(label: const Text("Email")),
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
                  height: 40,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name Is Required";
                    }
                  },
                  enableSuggestions: true,
                  decoration: InputDecoration(label: Text("Name")),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: country,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Country Is Required";
                    }
                  },
                  enableSuggestions: true,
                  decoration: InputDecoration(label: Text("Country")),
                ),
                const SizedBox(
                  height: 40,
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
                            //create acoount
                            await SignupController.createAccount(
                                context: context,
                                email: email.text,
                                password: password.text,
                                name: name.text,
                                country: country.text);
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
