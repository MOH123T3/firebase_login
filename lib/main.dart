// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_json_schema/home/home_page.dart';
import 'package:form_json_schema/sessions/login.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 15)),
        ),
        home: AuthStateWidget());
  }
}

class AuthStateWidget extends StatefulWidget {
  const AuthStateWidget({super.key});

  @override
  State<AuthStateWidget> createState() => _AuthStateWidgetState();
}

class _AuthStateWidgetState extends State<AuthStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Todo  If Check if snapshot has data (user is signed in)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasData) {
            //Todo  If User is signed in
            return HomePage(); // Pass user data to your home page
          } else {
            //Todo  If User is not signed in
            return const Login(); // Show the sign-in screen
          }
        },
      ),
    );
  }
}
