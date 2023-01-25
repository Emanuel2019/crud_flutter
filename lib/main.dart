import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController classe = TextEditingController();
  TextEditingController rollno = TextEditingController();
  bool error = false;
  bool sending = false;
  bool success = false;
  String msg = "";
  String url = "http://localhost/school/write.php";
  void iniState() {
    error;
    sending;
    success;
    msg;
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(Uri.parse(url), body: {
      "name": name.text,
      "address": address.text,
      "class": classe.text,
      "rollno": rollno.text
    });
    if (res.statusCode == 200) {
      print(res.body);
      var data = jsonDecode(res.body);
      if (data['error']) {
        sending = false;
        error = true;
        msg = data['message'];
      } else {
        name.text = "";
        address.text = "";
        classe.text = "";
        rollno.text = "";
        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(() {
        error = true;
        msg = "Erro ao enviar os dados ";
        sending = false;
      });
    }
  }

  clearData() {
    name.text = "";
    address.text = "";
    classe.text = "";
    rollno.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envio de informaçções gerais'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Text(error ? msg : 'Escreva a informação do estudante'),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    labelText: "Nome completo",
                    hintText: "Escreva o nome completo"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: address,
                decoration: InputDecoration(
                    labelText: "Endereço",
                    hintText: "Escreva o endereço do estudante"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: classe,
                decoration: InputDecoration(
                    labelText: "Turma",
                    hintText: "Escreva a turma  do estudante"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: rollno,
                decoration: InputDecoration(
                    labelText: "Número de matricula",
                    hintText: "Escreva o número da matrícula"),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sending = true;
                      });
                      sendData();
                      clearData();
                    },
                    child: Text(sending ? 'Enviar...' : "Registar"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
