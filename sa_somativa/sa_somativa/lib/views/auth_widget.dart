//widget de autenticação de usuario =-> direcionar o usuário logado para as telas de navegação

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sa_somativa/views/login_view.dart';
import 'package:sa_somativa/views/ponto_view.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<User?>(
      
      stream: FirebaseAuth.instance
          .authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PontoView();
        }
        return LoginView();
      },
    );
  }
}
