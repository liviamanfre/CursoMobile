import 'package:flutter/material.dart';
import '../models/viagem_model.dart';
import '../controllers/viagem_controller.dart';

class PlanejarViagemScreen extends StatefulWidget {
  const PlanejarViagemScreen({super.key});

  @override
  State<PlanejarViagemScreen> createState() => _PlanejarViagemScreenstate();
  }

  class _PlanejarViagemScreenstate extends State<PlanejarViagemScreen> {
    final _formKey = GlobalKey<FormState>();
    final _controller = ViagemController();

    final TextEditingController _tituloController = textEditingController();
    final TextEditingController _destinoController = TextEditingController();
    final TextEditingController _dataInicioController = TextEditingController();
    final TextEditingController _dataFimController = TextEditingController();
    final TextEditingController _descricaoController = TextEditingController();

    void _salvarViagem() async {
      if (_formKey.currentState!.validate()) {
        final novaViagem = Viagem(
          destino: _destino,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
          descricao: _descricao,
        );
        await _controller.createViagem(novaViagem);
        Navigator.pop(context, true); 
      }
    }

    @override 
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Planejar nova Viagem"),),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(labelText: "Título"),
                  validator: (value) => value!.isEmpty ? "Preencha o título": null,
                ),
                TextFormField(
                  controller: _destinoController,
                  decoration: const InputDecoration(labelText: "Destino"),
                ),
                TextFormField(
                  controller: _dataInicioController,
                  decoration: const InputDecoration(labelText: "Data de Início"),
                ),
                TextFormField(
                  controller: _dataFimController,
                  decoration: const InputDecoration(labelText: "Data de Fim"),
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: "Descrição"), 
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevateButton(
                  onPressed: _salvarViagem,
                  child: const Text("Salvar Viagem"),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    }
  }