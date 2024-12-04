import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/wid_publicacion.dart';
import 'allpost.dart';

class FeedPantalla extends StatelessWidget {
  const FeedPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Publicaciones'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            'No estás autenticado. Por favor, inicia sesión.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Publicaciones'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/crearPublicaciones'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublicacionesGlobalesPantalla(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Globales'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('publicaciones')
              .where('usuarioId', isEqualTo: currentUser.uid) //filtro por usuario
              .orderBy('fecha', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            
            if (snapshot.hasError) {
              print("Error al cargar las publicaciones: ${snapshot.error}");
              return const Center(
                child: Text(
                  'Error al cargar las publicaciones.',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              );
            }

           
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Verifica si no hay datos
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes publicaciones aún.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Muestra las publicaciones
            try {
              final publicaciones = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: publicaciones.length,
                itemBuilder: (context, index) {
                  final publicacion = publicaciones[index];
                  return WidPublicacion(postData: publicacion);
                },
              );
            } catch (e) {
              print("Error procesando las publicaciones: $e");
              return const Center(
                child: Text(
                  'Error al mostrar las publicaciones.',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
