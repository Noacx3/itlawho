class Usuario {
  final String id;
  final String email;

  Usuario({required this.id, required this.email});

  factory Usuario.fromFirebaseUser(dynamic user) {
    return Usuario(
      id: user.uid,
      email: user.email,
    );
  }
}
