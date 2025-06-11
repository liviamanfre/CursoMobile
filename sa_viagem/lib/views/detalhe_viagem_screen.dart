import 'package:flutter/material.dart';
import 'adicionar_entrada_screen.dart';
import '../models/viagem_model.dart';
import '../models/entrada_model.dart';
import '../controllers/entrada_controller.dart';

class DetalheViagemScreen extends StatefulWidget {
  final Viagem viagem;

  const DetalheViagemScreen({super.key, required this.viagem});

  @override
  State<DetalheViagemScreen> createState() => _DetalheViagemScreenState();
}

class _DetalheViagemScreenState extends State<DetalheViagemScreen> {
  final _entradaController = EntradaController();
  List<Entrada> _entradas = [];

  Future<void> _carregarEntradas() async {
    final lista = await _entradaController.listarEntradasPorViagem(widget.viagem.id!);
    setState(() {
      _entradas = lista;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarEntradas();
  }

  void _adicionarEntrada() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdicionarEntradaScreen(viagemId: widget.viagem.id!),
      ),
    );

    if (resultado == true) {
      _carregarEntradas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.viagem;

    return Scaffold(
      appBar: AppBar(title: Text(v.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Destino: ${v.destino}", style: const TextStyle(fontSize: 16)),
            Text("Período: ${v.dataInicio} - ${v.dataFim}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Descrição:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(v.descricao),
            const Divider(),
            const Text("Entradas do Diário:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _entradas.length,
                itemBuilder: (_, index) {
                  final e = _entradas[index];
                  return ListTile(
                    title: Text(e.data),
                    subtitle: Text(e.texto),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarEntrada,
        child: const Icon(Icons.add),
      ),
    );
  }
}
