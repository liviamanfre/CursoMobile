import 'package:biblioteca_app/controllers/livro_controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/views/livros/livros_form_view.dart';
import 'package:flutter/material.dart';

class LivrosListView extends StatefulWidget {
  const LivrosListView({super.key});

  @override
  State<LivrosListView> createState() => _LivrosListViewState();
}

class _LivrosListViewState extends State<LivrosListView> {
  final _controller = LivroController();
  late Future<List<LivroModel>> _livrosFuture;

  @override
  void initState() {
    super.initState();
    _livrosFuture = _controller.fetchAll();
  }

  void _refresh() {
    setState(() {
      _livrosFuture = _controller.fetchAll();
    });
  }

  void _abrirForm([LivroModel? livro]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivrosFormView(livro: livro),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Livros")),
      body: FutureBuilder<List<LivroModel>>(
        future: _livrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar livros"));
          }
          final livros = snapshot.data ?? [];
          if (livros.isEmpty) {
            return const Center(child: Text("Nenhum livro cadastrado"));
          }
          return ListView.builder(
            itemCount: livros.length,
            itemBuilder: (context, index) {
              final l = livros[index];
              return ListTile(
                title: Text(l.titulo),
                subtitle: Text("Autor: ${l.autor}\nDisponível: ${l.disponivel ? 'Sim' : 'Não'}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _abrirForm(l),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
        tooltip: "Novo Livro",
      ),
    );
  }
}