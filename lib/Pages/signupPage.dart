import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/UserModel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _key = GlobalKey();

  bool passwordNotVisible = true;

  TextEditingController name_controller = TextEditingController();
  TextEditingController username_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Create a new account",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      controller: name_controller,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      controller: username_controller,
                      validator: (username) {
                        if (username!.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      controller: email_controller,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: passwordNotVisible,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(passwordNotVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                passwordNotVisible = !passwordNotVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                      controller: password_controller,
                      validator: (password) {
                        if (password!.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            bool username_exists = await UserModel.usernameExists(username_controller.text);
                            if(!username_exists){
                              var res = await Authentication.signup(
                                  name_controller.text,
                                  username_controller.text,
                                  email_controller.text,
                                  password_controller.text);
                              if (res == true) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/home', (Route<dynamic> route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(res as String)));
                              }
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Username already exists, please enter a unique username")));
                            }

                          }
                        },
                        child: const Text("Sign up"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
