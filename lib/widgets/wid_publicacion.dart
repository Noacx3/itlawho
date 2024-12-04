import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itla_who/pantallas/editar_publicacion.dart';

class WidPublicacion extends StatelessWidget {
  final QueryDocumentSnapshot postData;

  const WidPublicacion({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenido de la publicación
            Text(
              postData['contenido'] ?? 'Contenido no disponible',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Fecha de la publicación
            Text(
              _formatFecha(postData['fecha']),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            // Opciones para el propietario
            if (currentUser != null && currentUser.uid == postData['usuarioId'])
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón de editar
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPublicacionPantalla(
                            publicacionId: postData.id, // .id para Firestore
                            contenidoActual: postData['contenido'],
                          ),
                        ),
                      );
                    },
                  ),

                  // Botón de borrar
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _eliminarPublicacion(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Elimina la publicación de Firestore
  Future<void> _eliminarPublicacion(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar esta publicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('publicaciones')
            .doc(postData.id) // Usa el ID del documento
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación eliminada')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  /// Formatea la fecha para mostrarla en un formato amigable
  String _formatFecha(dynamic fecha) {
    if (fecha == null) return 'Fecha no disponible';
    try {
      if (fecha is Timestamp) {
        final date = fecha.toDate(); // Convierte el timestamp a DateTime
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      return 'Formato de fecha inválido';
    } catch (e) {
      return 'Error al procesar la fecha';
    }
  }
}
