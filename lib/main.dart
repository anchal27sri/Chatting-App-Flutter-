import 'package:flutter/material.dart';
import 'services/signin.dart';

void main() {
  runApp(MyApp());
}

// Our first page will always be the sign in page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
