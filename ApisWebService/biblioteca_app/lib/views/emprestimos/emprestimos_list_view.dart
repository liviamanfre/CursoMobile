import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/views/emprestimos/emprestimos_form_view.dart';
import 'package:flutter/material.dart';

class EmprestimosListView extends StatefulWidget {
  const EmprestimosListView({super.key});

  @override
  State<EmprestimosListView> createState() => _EmprestimosListViewState();
}

class _EmprestimosListViewState extends State<EmprestimosListView> {
  final _controller = EmprestimoController();
  late Future<List<EmprestimoModel>> _emprestimosFuture;

  @override
  void initState() {
    super.initState();
    _emprestimosFuture = _controller.fetchAll();
  }

  void _refresh() {
    setState(() {
      _emprestimosFuture = _controller.fetchAll();
    });
  }

  void _abrirForm([EmprestimoModel? emprestimo]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmprestimosFormView(emprestimo: emprestimo),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Empréstimos")),
      body: FutureBuilder<List<EmprestimoModel>>(
        future: _emprestimosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar empréstimos"));
          }
          final emprestimos = snapshot.data ?? [];
          if (emprestimos.isEmpty) {
            return const Center(child: Text("Nenhum empréstimo cadastrado"));
          }
          return ListView.builder(
            itemCount: emprestimos.length,
            itemBuilder: (context, index) {
              final e = emprestimos[index];
              return ListTile(
                title: Text("Usuário: ${e.usuarioId}"),
                subtitle: Text("Livro: ${e.livroId}\nEmpréstimo: ${e.dataEmprestimo}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _abrirForm(e),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
        tooltip: "Novo Empréstimo",
      ),
    );
  }
}