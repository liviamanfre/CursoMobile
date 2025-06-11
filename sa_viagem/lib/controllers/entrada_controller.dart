import '../models/entrada_model.dart';
import '../services/db_helper.dart';

class EntradaController {
  //atributo
  final _dbHelper = DbHelper();

  // métodos

  // create
  createEntrada(Entrada entrada) async{
    return _dbHelper.insertEntrada(entrada);
  }

  //readConsultaByPet
  readEntradaByViagem(int viagemId) async {
    return _dbHelper.getEntradaByViagemId(viagemId);
  }

  //deleteConsulta
  deleteEntrada(int id) async{
    return _dbHelper.deleteEntrada(id);
  }
}