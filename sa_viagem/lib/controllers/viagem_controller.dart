import '../models/viagem_model.dart';
import '../services/db_helper.dart';

class ViagemController {
  final DbHelper _dbHelper = DbHelper(); //obj da classe dbhelper

  //métodos do controller - Slim (magros)
  Future<int> createViagem(Viagem viagem) async{
    return await _dbHelper.insertViagem(Viagem);
  }

  Future<List<Viagem>> readViagens() async {
    return await _dbHelper.getViagens(); 
  }

  Future<Viagem?> readViagemById(int id) async {
    return await _dbHelper.getViagemById(id);
  }

  Future<int> deleteViagem(int id) async {
    return await _dbHelper.deleteViagem(id);
  }
}