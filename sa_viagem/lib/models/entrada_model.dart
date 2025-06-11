class Entrada{
  final String id;
  final String viagemId; 
  final String dataHora;
  final String descricao;

  Entrada({
    this.id,
    required this.viagemId,
    required this.dataHora,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagemId': viagemId,
      'dataHora': dataHora,
      'descricao': descricao,
    };

    factory Entrada.fromMap(Map<String, dynamic> map) {
      return Entrada(
        id: map['id'] as int,
        viagemId: map['viagemId'] as String,
        dataHora: map['dataHora'] as String,
        descricao: map['descricao'] as String, 
      );
    }
  }
}