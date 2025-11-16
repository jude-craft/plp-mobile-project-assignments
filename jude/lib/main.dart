import 'package:flutter/material.dart';
import 'package:jude/screens/login.dart';

void main() {
  runApp(const MoneyTransferApp());
}

class MoneyTransferApp extends StatelessWidget {
  const MoneyTransferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Transfer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}