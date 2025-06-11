import 'package:flutter/material.dart';
import 'detalhe_viagem_screen.dart';
import 'planejar_viagem_screen.dart';
import '../controllers/viagem_controller.dart';
import '../models/viagem_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = ViagemController();
  List<Viagem> _viagens = [];

  Future<void> _carregarViagens() async {
    final lista = await _controller.listarViagens();
    setState(() {
      _viagens = lista;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarViagens();
  }

  void _irParaCadastro() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlanejarViagemScreen()),
    );
    if (resultado == true) {
      _carregarViagens();
    }
  }

  void _abrirDetalhes(Viagem viagem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheViagemScreen(viagem: viagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diário de Viagens')),
      body: ListView.builder(
        itemCount: _viagens.length,
        itemBuilder: (_, index) {
          final v = _viagens[index];
          return ListTile(
            title: Text(v.titulo),
            subtitle: Text(v.destino),
            onTap: () => _abrirDetalhes(v),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irParaCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
