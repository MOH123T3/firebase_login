// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, deprecated_member_use
import 'package:form_json_schema/sessions/sign_up.dart';
import 'package:form_json_schema/utils/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_json_schema/home/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1),
                ),
                const SizedBox(height: 35.0),
                const Icon(
                  Icons.login,
                  size: 40,
                ),
                const SizedBox(height: 35.0),
                TextFormField(
                    controller: emailController,
                    autofocus: false,
                    validator: (value) {
                      if (value != null) {
                        if (value.contains('@') && value.endsWith('.com')) {
                          return null;
                        }
                        return 'Enter a Valid Email Address';
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)))),
                const SizedBox(height: 25.0),
                TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    autofocus: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 8) {
                        return 'Password must be at least 8 characters in length';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ))),
                const SizedBox(height: 35.0),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No Account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          //Todo navigate to sign up screen for create new account
                          Get.to(SignUpScreen());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      )
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn() async {
//Todo sing in user
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showToastMessage(e.message.toString(), Colors.red);
    }
    Navigator.pop(context);
    Get.to(HomePage());
  }
}
