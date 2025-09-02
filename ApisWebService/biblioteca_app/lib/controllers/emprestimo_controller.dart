import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {
  // métodos

  // GET - All
  Future<List<EmprestimoModel>> fetchAll() async {
    final list = await ApiService.getList("emprestimos?_sort=dataEmprestimo"); // ordenado pela data do empréstimo
    return list.map<EmprestimoModel>((item) => EmprestimoModel.fromJson(item)).toList();
  }

  // GET - One
  Future<EmprestimoModel> fetchOne(String id) async {
    final emprestimo = await ApiService.getOne("emprestimos", id);
    return EmprestimoModel.fromJson(emprestimo);
  }

  // POST
  Future<EmprestimoModel> create(EmprestimoModel e) async {
    final created = await ApiService.post("emprestimos", e.toJson());
    return EmprestimoModel.fromJson(created);
  }

  // PUT
  Future<EmprestimoModel> update(EmprestimoModel e) async {
    final updated = await ApiService.put("emprestimos", e.toJson(), e.id!);
    return EmprestimoModel.fromJson(updated);
  }

  // DELETE
  Future<void> delete(String id) async {
    await ApiService.delete("emprestimos", id);
  }
}