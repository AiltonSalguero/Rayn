import 'package:flutter/material.dart';
import 'package:rayn/page/curso_horas.dart';
import 'package:rayn/page/mis_cursos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rayn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/mis_cursos': (context) => MisCursos(),
        '/curso_horas': (context) => CursoHoras(),
      },
      initialRoute: '/mis_cursos',
    );
  }
}
