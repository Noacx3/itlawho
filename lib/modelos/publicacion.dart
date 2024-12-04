import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacion {
  final String id;
  final String contenido;
  final DateTime fecha;
  final String usuarioId;

  Publicacion({
    required this.id,
    required this.contenido,
    required this.fecha,
    required this.usuarioId,
  });

  factory Publicacion.fromMap(Map<String, dynamic> data, String id) {
    return Publicacion(
      id: id,
      contenido: data['contenido'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      usuarioId: data['usuarioId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contenido': contenido,
      'fecha': fecha,
      'usuarioId': usuarioId,
    };
  }
}
