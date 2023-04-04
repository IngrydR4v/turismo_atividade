class CadastroModel {
  int? index;
  String nome;
  String descricao;
  String data;
  int tipo;

  CadastroModel({
    this.index,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });

  factory CadastroModel.fromJson(Map<String, dynamic> json) => CadastroModel(
        index: json['index'] as int,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String,
        data: json['data'] as String,
        tipo: json['tipo'] as int,
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        'nome': nome,
        'descricao': descricao,
        'data': data,
        'tipo': tipo,
      };
}
