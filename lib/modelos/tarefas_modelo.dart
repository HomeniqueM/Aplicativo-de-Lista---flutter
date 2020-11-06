class Tarefa {
  int id;
  String titulo;
  DateTime data;
  String prioridade;
  int status; // 0 - Inconpleto ,1 Finalizado
  Tarefa({this.titulo, this.data, this.prioridade, this.status});

  Tarefa.withId(
      {this.id, this.titulo, this.data, this.prioridade, this.status});

  // Serializar o objeto
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if( id != null) {
      map['id'] = id;
    }
    map['titulo'] = titulo;
    map['data'] = data.toIso8601String();
    map['prioridade'] = prioridade;
    map['status'] = status;
    return map;
  }

  // Deserializar o objeto
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa.withId(
      id: map['id'],
      titulo: map['titulo'],
      data: DateTime.parse(map['data']),
      prioridade: map['prioridade'],
      status: map['status'],
    );
  }
}
