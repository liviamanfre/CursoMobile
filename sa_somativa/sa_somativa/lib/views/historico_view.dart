import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoricoView extends StatelessWidget {
  const HistoricoView({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid; //* pega o UID do usuário logado
    final pontos = FirebaseFirestore.instance
        .collection('pontos') // acessa a coleção
        .where('uid', isEqualTo: uid) // filtra
        .orderBy('data', descending: true) // ordena
        .snapshots(); // cria um stream para atualizar em tempo real

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pontos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: pontos, // conecta o streambuilder ao stream de pontos
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('Nenhum registro encontrado.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i]['data'] as Timestamp;
              final tipo = docs[i]['tipo'];
              final distancia = (docs[i]['distancia'] as num).toStringAsFixed(1);
              return ListTile(
                title: Text('${tipo.toUpperCase()} - ${DateFormat('dd/MM/yyyy HH:mm').format(data.toDate())}'),
                subtitle: Text('Distância: $distancia m'),
              );
            },
          );
        },
      ),
    );
  }
}
