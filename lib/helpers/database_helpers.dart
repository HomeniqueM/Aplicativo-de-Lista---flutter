import 'dart:io';
import 'package:lista_de_tarefas_app/modelos/tarefas_modelo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._instance();

  static Database _db; // Baco de dados

  DataBaseHelper._instance();

  String tabelaDeTarefas = 'tabela_de_tarefas';
  String colId = 'id';
  String colTitulo = 'titulo';
  String colData = 'data';
  String colprioridade = 'prioridade';
  String colStratus = 'status';

  // Tabela de Tarefa
  // Id | titulo | Data | Prioridade | Status

  Future<Database> get db async {
    // Caso não exista um banco de dados ele cria um
    if (_db == null) {
      _db = await __iniciarBancoDeDados();
    }
    return _db;
  }

  Future<Database> __iniciarBancoDeDados() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'tabela_de_tarefas.db';
    final toDoListDb =
        await openDatabase(path, version: 1, onCreate: _createDancobeDados);
    return toDoListDb;
  }

  void _createDancobeDados(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tabelaDeTarefas($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitulo TEXT, $colData TEXT, $colprioridade TEXT, $colStratus INTEGER)');
  }

  // Retorna toda a tabela em List Map
  Future<List<Map<String, dynamic>>> getTabelaMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tabelaDeTarefas);
    return result;
  }

  // Converte o list de maps do banco de dados em uma lista de objetos Tarefa
  Future<List<Tarefa>> getTarefaList() async {
    final List<Map<String, dynamic>> tarefaMapLis = await getTabelaMapList();
    final List<Tarefa> tarefaList = [];
    tarefaMapLis.forEach((tarefaMap) {
      tarefaList.add(Tarefa.fromMap(tarefaMap));
    });
    tarefaList.sort((tarefaA, tarefaB) => tarefaA.data.compareTo(tarefaB.data));
    return tarefaList;
  }

  // Insere uma tarefa no banco de dados
  Future<int> insertTarefa(Tarefa tarefa) async {
    Database db = await this.db;
    final int result = await db.insert(tabelaDeTarefas, tarefa.toMap());
    return result;
  }

  //Atualiza uma tarefa dentro de obanco de dados
  Future<int> updateTarefa(Tarefa tarefa) async {
    Database db = await this.db;
    final int result = await db.update(tabelaDeTarefas, tarefa.toMap(),
        where: '$colId = ?', whereArgs: [tarefa.id]);
    return result;
  }

  //Deleta apatir de uma ID
  Future<int> deleteTarefa(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tabelaDeTarefas,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
