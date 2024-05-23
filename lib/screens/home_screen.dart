import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: Text('Bienvenido a TecNM App'),
      ),
    );
  }
}
