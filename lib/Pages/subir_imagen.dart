import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        
        body: Center(
   //Aca empieza el widget card ////////////////////////////
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('Título de la Tarjeta'),
                subtitle: Text('Descripción de la tarjeta'),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text('ACCION'),
                    onPressed: () {/* Acción al presionar el botón */},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  }
