import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsuarioFormView extends StatefulWidget {
  //atributos da classe
  final UsuarioModel? user; //pode ser nulo

  const UsuarioFormView({super.key, this.user}); //usuário não é obrigatório no construtor

  @override
  State<UsuarioFormView> createState() => _UsuarioFormViewState();
}

class _UsuarioFormViewState extends State<UsuarioFormView> {
  //atributos
  final _formKey = GlobalKey<FormState>(); //validações do formulário
  final _controller = UsuarioController(); //comunicação entre view e model
  final _nomeField = TextEditingController(); //controla o campo nome
  final _emailField = TextEditingController(); //controla o campo email

  @override
  void initState() {
    super.initState();
    if(widget.user != null){
      _nomeField.text = widget.user!.nome;
      _emailField.text = widget.user!.email;
    }
  }
  

  //criar novo usuário
  void _criar() async{
    if(_formKey.currentState!.validate()){
      final usuarioNovo = UsuarioModel(
        id: DateTime.now().microsecond.toString(), //criar um ID
        nome: _nomeField.text.trim(),
        email: _emailField.text.trim());
      try {
        await _controller.create(usuarioNovo);
        //mensagem de criação do usuário
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta para a tela anterior
    }
  }

  //atualizar usuário
  void _atualizar() async{
    if(_formKey.currentState!.validate()){
      final usuarioAtualizado = UsuarioModel(
        id: widget.user!.id, //criar um ID
        nome: _nomeField.text.trim(),
        email: _emailField.text.trim());
      try {
        await _controller.update(usuarioAtualizado);
        //mensagem de atualização do usuário
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta para a tela anterior
    }
  }

//build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        //operador ternário
        widget.user == null ? "Novo Usuário" : "Editar Usuário"
      ),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nomeField,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? "Informe o nome" : null,
              ),
              TextFormField(
                controller: _emailField,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Informe o email" : null,
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: widget.user == null ? _criar : _atualizar, 
                child: Text(widget.user == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}