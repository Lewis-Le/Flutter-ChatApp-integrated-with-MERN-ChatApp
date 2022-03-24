import 'package:flutter/material.dart';
import './login_screen.dart';
import './home_screen.dart';


class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      initialRoute: '/home',
    );
  }

}
