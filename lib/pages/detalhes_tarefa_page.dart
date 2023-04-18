import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/tarefa.dart';

class DetalhePage extends StatefulWidget {

  final Tarefa tarefa;

  const DetalhePage({Key? key, required this.tarefa}) : super(key: key);

  @override
  DetalhePageState createState() => _DetalhePageState();

  _DetalhePageState() {}

}


class DetalhePageState extends State<DetalhePage>{

  @override
  Widget build (BuildContext context){
      return Scaffold(
        appBar: AppBar(
        title: Text('Detalhes da tarefa ${widget.tarefa.id}'),
      ),
        body: _criarBody(),
    );
  }
  Widget _criarBody(){
    return Padding(
        padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(

          ),
        ],
      ),
    );
  }
}