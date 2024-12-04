import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pantallas/login.dart';
import 'pantallas/feed.dart';
import 'pantallas/crearPublicaciones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const itla_who());
}

class itla_who extends StatelessWidget {
  const itla_who({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itlayahoo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPantalla(),
        '/feed': (context) => const FeedPantalla(),
        '/crearPublicaciones': (context) => CrearPublicacionesPantalla(),
      },
    );
  }
}
