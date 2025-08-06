//Teste de Conversão Json <-> Dart
import 'dart:convert'; //nativa -> não precisa baixar para o pubspec

void main(){
  //tenho um texto em formarto de JSON
  String UsuarioJson = '''{
                            "id": "1ab2",
                            "user": "usuario1",
                            "nome": "Pedro",
                            "idade": 25,
                            "cadastrado": true
                      }''';
  // para manipular o texto
  // converter(decode) JSON em MAP
  Map<String,dynamic> usuario = json.decode(UsuarioJson);
  // manipulando informações do JSON -> MAP 
  print(usuario["idade"]);
  usuario["idade"] = 26;
  // converter(encode) de Map -> JSON
  UsuarioJson = json.encode(usuario);
  //tenho novamente um JSON em formato de Texto
  print(UsuarioJson);

  
}

