import 'package:flutter/material.dart';
import '../models/entrada_model.dart';
import '../controllers/entrada_controller.dart';

class AdicionarEntradaScreen extends StatefulWidget {
  final int viagemId;

  const AdicionarEntradaScreen({super.key, required this.viagemId});

  @override
  State<AdicionarEntradaScreen> createState() => _AdicionarEntradaScreenState();
}

class _AdicionarEntradaScreenState extends State<AdicionarEntradaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();
  final _textoController = TextEditingController();

  final _controller = EntradaController();

  void _salvarEntrada() async {
    if (_formKey.currentState!.validate()) {
      final novaEntrada = Entrada(
        viagemId: widget.viagemId,
        data: _dataController.text,
        texto: _textoController.text,
      );

      await _controller.inserirEntrada(novaEntrada);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Entrada no Diário")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(labelText: "Data"),
                validator: (value) => value!.isEmpty ? "Informe a data" : null,
              ),
              TextFormField(
                controller: _textoController,
                decoration: const InputDecoration(labelText: "Texto"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Escreva algo no diário" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarEntrada,
                child: const Text("Salvar Entrada"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
