import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  //print(await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

// getData() retorna os dados futuros
Future<Map> getData() async {
  http.Response response = await http.get(request); // esperando dado chegar
  return json.decode(response.body); // pega os dados json e transforma num map
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;


  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('\$Conversor \$'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              //status da conexão
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando dados...",
                        style: TextStyle(color: Colors.amber),
                        textAlign: TextAlign.center),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error ao carregar Dados :)",
                          style: TextStyle(color: Colors.amber),
                          textAlign: TextAlign.center),
                    );
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextField("Reais", "R\$",realController,_realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$",dolarController,_dolarChanged),
                          Divider(),
                          buildTextField("Euros", "&",euroController,_euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
  String label,
  String prefix,
    TextEditingController c,
    Function f
) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    controller: c,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
