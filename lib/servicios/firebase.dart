import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioActual => _auth.currentUser;

  Future<User?> iniciarSesionConCorreo({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }

  Future<User?> registrarConCorreo({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error al registrar usuario: $e");
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
      print("Sesión cerrada exitosamente.");
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  Future<void> enviarCorreoDeRecuperacion(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Correo de recuperación enviado a $email");
    } catch (e) {
      print("Error al enviar correo de recuperación: $e");
    }
  }
}
