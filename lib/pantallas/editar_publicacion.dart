import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPublicacionPantalla extends StatelessWidget {
  final String publicacionId; // ID del documento en Firestore
  final String contenidoActual;

  final TextEditingController contenidoController = TextEditingController();

  EditarPublicacionPantalla({
    super.key,
    required this.publicacionId,
    required this.contenidoActual,
  });

  @override
  Widget build(BuildContext context) {
    contenidoController.text = contenidoActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Publicación'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar Contenido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              // Campo para editar contenido
              TextField(
                controller: contenidoController,
                decoration: InputDecoration(
                  labelText: 'Actualiza tu publicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 30),
              // Botón para guardar cambios
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final nuevoContenido = contenidoController.text.trim();

                    if (nuevoContenido.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El contenido no puede estar vacío'),
                        ),
                      );
                      return;
                    }

                    try {
                      // Actualizar la publicación en Firestore
                      await FirebaseFirestore.instance
                          .collection('publicaciones')
                          .doc(publicacionId)
                          .update({
                        'contenido': nuevoContenido,
                        'fecha': FieldValue.serverTimestamp(), 
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Publicación actualizada'),
                        ),
                      );
                      Navigator.pop(context); // Regresa a la pantalla anterior
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al actualizar: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
