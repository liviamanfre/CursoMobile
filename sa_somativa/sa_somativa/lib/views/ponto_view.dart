import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'historico_view.dart';

class PontoView extends StatefulWidget {
  const PontoView({super.key});

  @override
  State<PontoView> createState() => _PontoViewState();
}

class _PontoViewState extends State<PontoView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _carregando = false;
  String? _ultimoTipo; // "entrada" ou "saida"

  @override
  void initState() {
    super.initState();
    _buscarUltimoRegistro();
  }

  Future<void> _buscarUltimoRegistro() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final snapshot = await _db
        .collection('pontos')
        .where('uid', isEqualTo: user.uid)
        .orderBy('data', descending: true)
        .limit(1) // pega o mais recente
        .get();

    if (snapshot.docs.isNotEmpty) {
      _ultimoTipo = snapshot.docs.first['tipo']; // salva o tipo do ultimo registo (saida ou entrada)
      setState(() {}); // atualiza
    }
  }

  Future<void> _baterPonto(String tipo) async {
    setState(() => _carregando = true);
    final user = _auth.currentUser;
    if (user == null) return;

    // solicita senha antes de registrar
    final senhaValida = await _confirmarSenha();
    if (!senhaValida) {
      setState(() => _carregando = false);
      return;
    }

    //*
    bool servicoHabilitado;
    LocationPermission permissao;

    // verifica se serviço de localização está habilitado
    servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ative o serviço de localização!')),
      );
      return;
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de localização negada!')),
        );
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de localização permanentemente negada!')),
      );
      return;
    }


    // pegar localização atual
    final posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    const latTrabalho = -22.571053;
    const lonTrabalho = -47.403930;
    final distancia = Geolocator.distanceBetween(
      latTrabalho, lonTrabalho, posicao.latitude, posicao.longitude);

    // verifica se a distância está dentro do limite
    if (distancia > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você está fora do limite de 100 metros!')));
      setState(() => _carregando = false);
      return;
    }

    await _db.collection('pontos').add({
      'uid': user.uid,
      'data': Timestamp.now(),
      'tipo': tipo,
      'latitude': posicao.latitude,
      'longitude': posicao.longitude,
      'distancia': distancia,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ponto de $tipo registrado!')));
    
    _ultimoTipo = tipo;
    setState(() => _carregando = false);
  }

  Future<bool> _confirmarSenha() async {
    final TextEditingController senhaController = TextEditingController();
    bool confirmado = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar senha'),
        content: TextField(
          controller: senhaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Senha'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                final cred = EmailAuthProvider.credential(
                  email: _auth.currentUser!.email!,
                  password: senhaController.text,
                );
                await _auth.currentUser!.reauthenticateWithCredential(cred);
                confirmado = true;
                Navigator.pop(context);
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Senha incorreta.')));
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    return confirmado;
  }

  @override
  Widget build(BuildContext context) {
    final podeEntrar = _ultimoTipo == 'saida' || _ultimoTipo == null;
    final podeSair = _ultimoTipo == 'entrada';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Ponto'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: _carregando
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: podeEntrar ? () => _baterPonto('entrada') : null,
                    child: const Text('Registrar Entrada'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: podeSair ? () => _baterPonto('saida') : null,
                    child: const Text('Registrar Saída'),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HistoricoView()));
                    },
                    child: const Text('Ver Histórico'),
                  ),
                ],
              ),
      ),
    );
  }
}