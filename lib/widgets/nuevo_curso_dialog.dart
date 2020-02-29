import 'package:flutter/material.dart';

Future<String> nuevoCursoDialog(BuildContext context) async {
  // TO DO opcion para cancelar y que no permita texto vacio si le da a OK
  String nombre = "";
  return showDialog<String>(
    context: context,
    //barrierDismissible: false,nuevoCursoDialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Agregar curso"),
        content: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nombre",
                hintText: "Nombre del curso",
              ),
              onChanged: (value) {
                nombre = value;
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(nombre);
            },
          ),
        ],
      );
    },
  );
}
