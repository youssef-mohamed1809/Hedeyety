import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyety/Authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to Hedeyety!"),
            Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "email"),
                      controller: email_controller,
                      validator: (email){},
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "password"),
                      controller: password_controller,
                      validator: (password){},
                    ),
                    ElevatedButton(
                        onPressed: () async {
                            if(_key.currentState!.validate()){
                                bool res = await Authentication.login(email_controller.text, password_controller.text);
                                if(res == true){
                                  Navigator.pushReplacementNamed(context, '/');
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
                                }
                            }
                        },
                        child: Text("Login")
                    )
                  ],
            ))
          ],
        ),
      ),
    );
  }
}

