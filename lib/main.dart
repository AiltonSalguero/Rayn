import 'package:flutter/material.dart';
import 'package:rayn/page/curso_horas.dart';
import 'package:rayn/page/mis_cursos.dart';
import 'package:rayn/page/test2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rayn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MisCursos(),
        '/curso_horas': (context) => CursoHoras(),
      },
      initialRoute: '/',
    );
  }
}
