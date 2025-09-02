class EmprestimoModel {

  // As Strings com "?" indicam que o campo é opcional (pode ser nulo)
  final String? id;
  final String usuarioId;
  final String livroId;
  final String dataEmprestimo;
  final String? dataDevolucao;
  final String? devolvido;

  EmprestimoModel({
    // Não temos o "required" no id, pois ele é gerado automaticamente pelo banco
    // E no dataDevolucao, pois o empréstimo pode ainda não ter sido devolvido
    this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    this.dataDevolucao,
    this.devolvido,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuarioId": usuarioId,
        "livroId": livroId,
        "dataEmprestimo": dataEmprestimo,
        "dataDevolucao": dataDevolucao,
        "devolvido": devolvido,
      };

  factory EmprestimoModel.fromJson(Map<String, dynamic> json) => EmprestimoModel(
        id: json["id"]?.toString(),
        usuarioId: json["usuarioId"].toString(),
        livroId: json["livroId"].toString(),
        dataEmprestimo: json["dataEmprestimo"].toString(),
        dataDevolucao: json["dataDevolucao"]?.toString(),
        devolvido: json["devolvido"]?.toString(),
  );
}