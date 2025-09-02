import 'package:biblioteca_app/controllers/livro_controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:flutter/material.dart';

class LivrosFormView extends StatefulWidget {
  final LivroModel? livro;
  const LivrosFormView({super.key, this.livro});

  @override
  State<LivrosFormView> createState() => _LivrosFormViewState();
}

class _LivrosFormViewState extends State<LivrosFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivroController();
  final _tituloField = TextEditingController();
  final _autorField = TextEditingController();
  bool _disponivel = true;

  @override
  void initState() {
    super.initState();
    final l = widget.livro;
    if (l != null) {
      _tituloField.text = l.titulo;
      _autorField.text = l.autor;
      _disponivel = l.disponivel;
    }
  }

  Future<void> _salvarOuAtualizar() async {
    if (_formKey.currentState!.validate()) {
      final model = LivroModel(
        id: widget.livro?.id,
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(),
        disponivel: _disponivel,
      );
      try {
        if (widget.livro == null) {
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
        title: Text(widget.livro == null ? "Novo Livro" : "Editar Livro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloField,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (v) => v!.isEmpty ? "Informe o título" : null,
              ),
              TextFormField(
                controller: _autorField,
                decoration: const InputDecoration(labelText: "Autor"),
                validator: (v) => v!.isEmpty ? "Informe o autor" : null,
              ),
              SwitchListTile(
                title: const Text("Disponível"),
                value: _disponivel,
                onChanged: (v) => setState(() => _disponivel = v),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _salvarOuAtualizar,
                child: Text(widget.livro == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}