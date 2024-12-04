import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

/// Función para iniciar sesión con Google
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      print("El usuario canceló el inicio de sesión.");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      print("Inicio de sesión exitoso:");
      print("Nombre: ${user.displayName}");
      print("Correo: ${user.email}");
      print("UID: ${user.uid}");
    } else {
      print("Error: No se pudo obtener información del usuario.");
    }

    return user;
  } catch (e) {
    print("Error al iniciar sesión con Google: $e");
    return null;
  }
}



/// Función para cerrar sesión
Future<void> signOut() async {
  try {
    await googleSignIn.signOut(); 
    await FirebaseAuth.instance.signOut(); 
    print("Sesión cerrada exitosamente.");
  } catch (e) {
    print("Error al cerrar sesión: $e");
  }
}

