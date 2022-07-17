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

  List<dynamic> tarefas = [];


  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _lerArquivo() async {
    try{
      final arquivo = await _getFile();
      return arquivo.readAsString();
    }catch(e){
      return null;
    }
  }

  _salvarArquivo() async{
    //determinar os itens da lista de tarefas
    Map<String,dynamic> tarefa = Map();
    File arquivo = await _getFile() as File;
    tarefa["Titulo"] = "Ir ao mercado";
    tarefa["Status"] = false;
    tarefas.add(tarefa);
    //converter para json
    String dados = json.encode(tarefas);
    arquivo.writeAsString(dados);
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados){
      setState((){
        tarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("itens: " + tarefas.toString());
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
                return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(tarefas[index]["Titulo"]), Text("outro componente")],
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
                          setState((){_salvarArquivo();});
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
