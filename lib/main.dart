import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_app/screens/tela_de_listagem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo de Notas',
      theme: ThemeData(
        primarySwatch: Colors.amber,



      ),
      home:TeladeListagem() ,
    );
  }
}
