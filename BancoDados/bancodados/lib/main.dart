import 'package:bancodados/teste.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

//https://pub.dev/packages/sqflite

void main() {
  runApp(
    MaterialApp(
      home: TesteBd(),
    ),
  );
}

class TesteBd extends StatefulWidget {
  @override
  _TesteBdState createState() => _TesteBdState();
}

class _TesteBdState extends State<TesteBd> {
  var db;
  Database database;
  String path;
  var databasesPath;
  List listaPessoas = List();

  Teste x = new Teste();

  _pegaCaminho() async {
    // Get a location using getDatabasesPath
    databasesPath = await getDatabasesPath();
    path = databasesPath + '/banco_aula.db';
  }

  @override
  void initState() {
    _pegaCaminho();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banco de Dados'),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      color: Colors.amber,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          RaisedButton(
            child: Text('Criar Banco'),
            onPressed: () async {
              //     if (database == null) {
              //     print('criou');
              // Delete the database
              //   await deleteDatabase(path);

              // open the database
              database = await openDatabase(path, version: 1,
                  onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute(
                    'CREATE TABLE if not exists teste (codigo INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)');

                await db.execute(
                    'CREATE TABLE if not exists teste2 (codigo INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)');
              });

              //     } else {
              //       print('nao criou');
              //    }
            },
          ),
          RaisedButton(
            child: Text('Abrir Banco'),
            onPressed: () async {
              // print(path);

              database = await openDatabase(path);
            },
          ),
          RaisedButton(
            child: Text('Fechar Banco'),
            onPressed: () async {
              // Close the database
              await database.close();
            },
          ),
          RaisedButton(
            child: Text('Apagar Banco'),
            onPressed: () async {
              // Delete the database
              await deleteDatabase(path);
            },
          ),
          RaisedButton(
            child: Text('Inserir Registro'),
            onPressed: () async {
              // Insert some records in a transaction
              await database.transaction((txn) async {
                int id1 = await txn.rawInsert(
                    'INSERT INTO teste( nome) VALUES ("TESTE DE NOME")');
                print('Primeiro Registro: ' + id1.toString());

                int id2 = await txn.rawInsert(
                    'INSERT INTO teste2( nome) VALUES ("TESTE DE NOME")');
                print('teste 2 Registro: ' + id2.toString());
              });
            },
          ),
          RaisedButton(
            child: Text('Alterar registro '),
            onPressed: () async {
              // Update some record
              int count = await database.rawUpdate(
                  'UPDATE teste SET nome = ? WHERE codigo = 3', ['novo nome']);
              print('updated: $count');
            },
          ),
          RaisedButton(
            child: Text('Apagar registro '),
            onPressed: () async {
              // Update some record
              int count = await database
                  .rawDelete('delete from teste  WHERE codigo = 4');
              print('Apagado: $count');
            },
          ),
          RaisedButton(
              child: Text('Listar'),
              onPressed: () {
                listaTabela().then((list) {
                  setState(() {
                    listaPessoas = list;
                  });
                });
              }),
          Container(
            color: Colors.green,
            width: 300,
            height: 200,
            child: ListView.builder(
              padding: EdgeInsets.all(10.00),
              itemCount: listaPessoas.length,
              itemBuilder: (context, index) {
                x = Teste.fromJson(listaPessoas[index]);
                return Text(x.codigo.toString() + '  ' + x.nome);

                //   return Text(listaPessoas[index].toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List> listaTabela() async {
    // Get the records

    var lista = await database.rawQuery('SELECT * FROM teste2');
    return lista.toList();
  }
}
