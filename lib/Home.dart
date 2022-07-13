import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {

  List tarefas = [];
  List<bool> tarefasResult = [false, false, false];

  _salvarArquivo() async{
    final diretorio = await getApplicationDocumentsDirectory();
    var arquivo = File("${diretorio.path}/dados.json");

    //determinar os itens da lista de tarefas
    Map<String,dynamic> tarefa = Map();
    tarefa["Titulo"] = "Ir ao mercado";
    tarefa["Status"] = false;
    tarefas.add(tarefa);

    //converter para json
    String dados = jsonEncode(tarefas);
    arquivo.writeAsString(dados);
  }

  @override
  Widget build(BuildContext context) {
    _salvarArquivo();
    Color corPrincipal = Colors.purple;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrincipal,
        title: Text("Lista de tarefas"),
      ),
      body: Container(
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: tarefas.length,
              itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(tarefas[index]), Checkbox(
                          value: tarefasResult[index],
                          onChanged: (bool? value){
                            setState((){tarefasResult[index] = value!;});
                          })],
                    ),
                  );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite a sua tarefa"
                    ),
                    onChanged: (text){},
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")
                    ),
                    FlatButton(
                        onPressed: (){
                          //salvar
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")
                    )
                  ],
                );
              }
          );
        },
        backgroundColor: corPrincipal,
        icon: Icon(Icons.add),
        label: Text("Adicionar nova tarefa"),
      ),
    );
  }
}
