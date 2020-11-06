import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas_app/helpers/database_helpers.dart';
import 'package:lista_de_tarefas_app/modelos/tarefas_modelo.dart';
import 'package:lista_de_tarefas_app/screens/tela_de_adicionar_novas_tarefas.dart';

class TeladeListagem extends StatefulWidget {
  @override
  _TeladeListagem createState() => _TeladeListagem();
}

class _TeladeListagem extends State<TeladeListagem> {
  // Definições
  Future<List<Tarefa>> _tarefaList;
  final DateFormat _dateFormatter =
      DateFormat('dd.MM.yyyy'); // Formatação de Datas
  //================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TelaDeNovasTarefas(
              updateListaDeTarefas: _updateListadeTarefas(),
            ),
          ),
        ).then((value) => _updateListadeTarefas()),
      ),
      body: FutureBuilder(
        future: _tarefaList,
        builder: (context, snapshot) {
          // Verificado se ah dados
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final int tarefasCompletas = snapshot.data
              .where((Tarefa tarefa) => tarefa.status == 1)
              .toList()
              .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Minhas Notas',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      ),
                      // Titulo da Pagina
                      SizedBox(
                        height: 10.0,
                      ),
                      // Subtitulo, contado de tarefas feitas
                      Text(
                        '${tarefasCompletas} de ${snapshot.data.length}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }
              return _constutorDeTarefas(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // You can call setState from here
    _updateListadeTarefas();
  }

  _updateListadeTarefas() {
    Future.delayed(
      Duration.zero,
      () => setState(
        () {
          _tarefaList = DataBaseHelper.instance.getTarefaList();
        },
      ),
    );
    /*
    setState(() {
      _tarefaList = DataBaseHelper.instance.getTarefaList();
    });
    */
  }

  //================================================
  // Construtor das Caixas de tarefas
  Widget _constutorDeTarefas(Tarefa tarefa) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              tarefa.titulo,
              style: TextStyle(
                  fontSize: 20.0,
                  decoration: tarefa.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormatter.format(tarefa.data)} - ${tarefa.prioridade}',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                tarefa.status = value ? 1 : 0;
                DataBaseHelper.instance.updateTarefa(tarefa);
                _updateListadeTarefas();
              },
              activeColor: Theme.of(context).primaryColor,
              value: tarefa.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaDeNovasTarefas(
                  tarefa: tarefa,
                  //   updateListaDeTarefas: _updateListadeTarefas(),
                ),
              ),
            ).then((value) => _updateListadeTarefas()),
          ),
          Divider(),
        ],
      ),
    );
  }

//================================================
}
