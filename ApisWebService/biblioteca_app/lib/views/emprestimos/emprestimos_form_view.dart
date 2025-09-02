import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:flutter/material.dart';

class EmprestimosFormView extends StatefulWidget {
  final EmprestimoModel? emprestimo;
  const EmprestimosFormView({super.key, this.emprestimo});

  @override
  State<EmprestimosFormView> createState() => _EmprestimosFormViewState();
}

class _EmprestimosFormViewState extends State<EmprestimosFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EmprestimoController();
  final _usuarioIdField = TextEditingController();
  final _livroIdField = TextEditingController();
  final _dataEmprestimoField = TextEditingController();
  final _dataDevolucaoField = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.emprestimo;
    if (e != null) {
      _usuarioIdField.text = e.usuarioId;
      _livroIdField.text = e.livroId;
      _dataEmprestimoField.text = e.dataEmprestimo;
      _dataDevolucaoField.text = e.dataDevolucao ?? "";
    }
  }

  Future<void> _salvarOuAtualizar() async {
    if (_formKey.currentState!.validate()) {
      final model = EmprestimoModel(
        id: widget.emprestimo?.id,
        usuarioId: _usuarioIdField.text.trim(),
        livroId: _livroIdField.text.trim(),
        dataEmprestimo: _dataEmprestimoField.text.trim(),
        dataDevolucao: _dataDevolucaoField.text.trim().isEmpty ? null : _dataDevolucaoField.text.trim(),
      );
      try {
        if (widget.emprestimo == null) {
          await _controller.create(model);
        } else {
          await _controller.update(model);
        }
      } catch (e) {}
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emprestimo == null ? "Novo Empréstimo" : "Editar Empréstimo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usuarioIdField,
                decoration: const InputDecoration(labelText: "ID do Usuário"),
                validator: (v) => v!.isEmpty ? "Informe o ID do usuário" : null,
              ),
              TextFormField(
                controller: _livroIdField,
                decoration: const InputDecoration(labelText: "ID do Livro"),
                validator: (v) => v!.isEmpty ? "Informe o ID do livro" : null,
              ),
              TextFormField(
                controller: _dataEmprestimoField,
                decoration: const InputDecoration(labelText: "Data do Empréstimo"),
                validator: (v) => v!.isEmpty ? "Informe a data do empréstimo" : null,
              ),
              TextFormField(
                controller: _dataDevolucaoField,
                decoration: const InputDecoration(labelText: "Data da Devolução (opcional)"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _salvarOuAtualizar,
                child: Text(widget.emprestimo == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}