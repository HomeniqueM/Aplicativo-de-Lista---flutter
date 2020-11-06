import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas_app/helpers/database_helpers.dart';
import 'package:lista_de_tarefas_app/modelos/tarefas_modelo.dart';

class TelaDeNovasTarefas extends StatefulWidget {
  final Tarefa tarefa;

  final Function updateListaDeTarefas;

  TelaDeNovasTarefas({this.tarefa, this.updateListaDeTarefas});

  @override
  _TelaDeNovasTarefasState createState() => _TelaDeNovasTarefasState();
}

class _TelaDeNovasTarefasState extends State<TelaDeNovasTarefas> {
  // Definicao
  String _title = ''; // Titulo da Tarefa
  String _prioridade; // Armazenamento de Prioridade
  DateTime _date =
      DateTime.now(); // Armazenamento da Data (Já armazenado a data do dia)
  final List<String> _prioridades = [
    'Baixa',
    'Normal',
    'Alta'
  ]; // Classificação de Prioridades
  final DateFormat _dateFormatter =
      DateFormat('dd.MM.yyyy'); // Formatação de Datas
  final _formkey = GlobalKey<FormState>();
  TextEditingController _controleDeData = TextEditingController(); // Input
//========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // para poder sair do teclado clicado fora dele
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 55.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.tarefa == null
                      ? 'Adicionar nova Tarefa'
                      : 'Atualizar a Tarefa',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      // Titulo
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Titulo',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Por favor, Defina um titulo para a tarefa'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      // Data
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          // Imposibilita o uso do teclado na data
                          controller: _controleDeData,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _handledDatePicker,
                          decoration: InputDecoration(
                            labelText: 'Data',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // Prioridade
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _prioridades.map((String prioridade) {
                            return DropdownMenuItem(
                              value: prioridade,
                              child: Text(
                                prioridade,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Prioridade',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => _prioridade == null
                              ? 'Por favor, Selecione uma prioridade'
                              : null,
                          onChanged: (value) {
                            _prioridade = value;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          child: Text(
                            widget.tarefa == null ? 'Adicionar' : 'Atualizar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.tarefa != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: FlatButton(
                                child: Text(
                                  'Apagar Tarefa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: _delete,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      print('$_title,$_date,$_prioridade');

      // Inserir um nova tarefa no banco de dado
      Tarefa tarefa =
          Tarefa(titulo: _title, data: _date, prioridade: _prioridade);
      if (widget.tarefa == null) {
        tarefa.status = 0; // como acabou de ser criada o status inicial e zero
        DataBaseHelper.instance.insertTarefa(tarefa);
      } else {
        tarefa.id = widget.tarefa.id;
        tarefa.status = widget.tarefa.status;
        DataBaseHelper.instance.updateTarefa(tarefa);
      }
      Navigator.pop(context);
    }
    // widget.updateListaDeTarefas();
  }

  _delete() {
    DataBaseHelper.instance.deleteTarefa(widget.tarefa.id);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _title = widget.tarefa.titulo;
      _date = widget.tarefa.data;
      _prioridade = widget.tarefa.prioridade;
    }
    _controleDeData.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _controleDeData.dispose();
    super.dispose();
  }

  _handledDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _controleDeData.text = _dateFormatter.format(_date);
    }
  }
}
