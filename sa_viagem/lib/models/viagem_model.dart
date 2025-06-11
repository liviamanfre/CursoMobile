class Viagem {
  //atributos ->
  final String id;
  final String destino;
  final String dataInicio;
  final String dataFim;
  final string descricao;

//métodos -> construtor
  Viagem({
    required this.id,
    required this.destino,
    required this.dataInicio,
    required this.dataFim,
    required this.descricao,
  }); 

  //método toMap() -> obj => Map
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'destino': destino,
      'datainicio': dataInicio,
      'dataFim': dataFim,
      'descricao': descricao,
    };
  }

  //método fromMap() -> Map => obj
  factory Viagem.fromMap(Map<string, dynamic> map) {
    return Viagem(
      id: map['id'] as int, 
      destino: map['destino'] as String,
      dataInicio: map['datainicio'] as String,
      dataFim: map['dataFim'] as String,
      descricao: map['descricao'] as String); 
  }
}