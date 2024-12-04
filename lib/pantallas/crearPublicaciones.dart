import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrearPublicacionesPantalla extends StatelessWidget {
  final TextEditingController contenidoController = TextEditingController();

  CrearPublicacionesPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
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
                'Comparte tu logro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Campo para el contenido
              TextField(
                controller: contenidoController,
                decoration: InputDecoration(
                  labelText: '¿Qué lograste hoy?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 30),

              // Botón para publicar
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final contenido = contenidoController.text.trim();

                    // Validación del contenido
                    if (contenido.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El contenido no puede estar vacío'),
                        ),
                      );
                      return;
                    }

                    // Validación de usuario autenticado
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Usuario no autenticado'),
                        ),
                      );
                      return;
                    }

                    try {
                      // Guardar publicación en Firestore
                      await FirebaseFirestore.instance.collection('publicaciones').add({
                        'contenido': contenido,
                        'fecha': FieldValue.serverTimestamp(),
                        'usuarioId': user.uid,
                        'usuarioCorreo': user.email, // Incluye el correo del usuario
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Publicación creada exitosamente'),
                        ),
                      );

                      Navigator.pop(context); 
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al publicar: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Publicar',
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



