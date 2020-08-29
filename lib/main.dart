import 'package:flutter/material.dart';
import 'package:flutterandroid/root_page.dart';
import 'package:flutterandroid/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generar nombre de inicio',
      home: RootPage(auth: Auth()),
    );
  }
}
