import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rayn/dao/curso_dao.dart';
import 'package:rayn/model/curso.dart';
import 'package:rayn/util/curso_seleccionado.dart';
import 'package:rayn/util/util.dart';
import 'package:rayn/widgets/borrar_curso_dialog.dart';
import 'package:rayn/widgets/loader.dart';
import 'package:rayn/widgets/nuevo_curso_dialog.dart';

class MisCursos extends StatefulWidget {
  @override
  _MisCursosState createState() => _MisCursosState();
}

class _MisCursosState extends State<MisCursos> {
  int tiempoTotalEstudiando;
  int tiempoTotalEnseniando;
  int tiempoTotalViendoVideos;
  int tiempoTotalEnClase;
  @override
  void initState() {
    CursoDao.getCursos().then((cursos) {
      setState(() {
        CursoDao.listaCursos = cursos;
      });
    });
    CursoDao.getTiempoTotalEstudiando().then((tiempo) {
      setState(() {
        tiempoTotalEstudiando = tiempo;
      });
    });
    CursoDao.getTiempoTotalEnseniando().then((tiempo) {
      setState(() {
        tiempoTotalEnseniando = tiempo;
      });
    });
    CursoDao.getTiempoTotalViendoVideos().then((tiempo) {
      setState(() {
        tiempoTotalViendoVideos = tiempo;
      });
    });
    CursoDao.getTiempoTotalEnClase().then((tiempo) {
      setState(() {
        tiempoTotalEnClase = tiempo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Rayn",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          child: CursoDao.listaCursos == null
              ? Text("waitings")
              : _buildListTest()),

      floatingActionButton: FloatingActionButton(
        onPressed: _openNuevoCursoDialog,
        tooltip: 'Agregar curso',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildEncabezado() {
    return Container(
      child: Text("Kyssnar"),
    );
  }

  Widget _buildListTest() {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0.0, MediaQuery.of(context).size.height * 0.1050),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            primary: true,
            itemCount: CursoDao.listaCursos.length,
            itemBuilder: (BuildContext content, int index) {
              return _buildCursoListItem(CursoDao.listaCursos[index],
                  Util.colores[Random().nextInt(4)], CursoDao.listaCursos[index].codCurso);
            },
          ),
        ),
        Transform.translate(
          offset: Offset(0.0, -56.0),
          child: Container(
            child: ClipPath(
              clipper: MyClipper(),
              child: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.2,
                    child: Container(color: Colors.red),
                  ),
                  Transform.translate(
                    offset: Offset(0.0, 50.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[200],
                      ),
                      title: Text(
                        "Mis cursos",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            letterSpacing: 2.0),
                      ),
                      subtitle: tiempoTotalEnClase == null
                          ? Text("...")
                          : Text(
                              "Tiempo total: " +
                                  Util.segundosToReloj(tiempoTotalEstudiando +
                                      tiempoTotalEnseniando +
                                      tiempoTotalViendoVideos +
                                      tiempoTotalEnClase),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  letterSpacing: 2.0),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCargando() {
    return Container(
      child: ColorLoader(
        radius: 15,
        dotRadius: 6,
      ),
    );
  }

  Widget _buildListaCursos() {
    return GridView.count(
      crossAxisCount: 1,
      children: CursoDao.listaCursos
          .map((curso) => _buildCursoListItem(curso, Colors.blue, 200))
          .toList(),
    );
  }

  Widget _buildTest(curso) {
    return Card(
      color: Colors.red,
      elevation: 5.0,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(curso.nombre),
          Text("Tiempo total: " +
              Util.segundosToReloj(curso.tiempoEstudiando +
                  curso.tiempoEnseniando +
                  curso.tiempoViendoVideos +
                  curso.tiempoEnClase)),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _openBorrarCursoDialog(curso.codCurso),
                child: Icon(Icons.delete),
              ),
              FlatButton(
                onPressed: () => _openCursoHorasPage(curso.codCurso),
                child: Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _openNuevoCursoDialog() async {
    print("/// nuevo curso dialog");
    String nombre = await nuevoCursoDialog(context);
    CursoDao.addCurso(nombre).then((val) {
      setState(() {});
    });
  }

  void _openBorrarCursoDialog(int codCurso) async {
    print("presioando");
    final ConfirmAction action = await borrarCursoDialog(context);
    if (action == ConfirmAction.ACCEPT) {
      CursoDao.deleteCurso(codCurso).then((val) {
        setState(() {});
      });
    }
  }

  void _openCursoHorasPage(int codCurso) {
    CursoSeleccionado.codCurso = codCurso;
    Navigator.of(context).pushNamed('/curso_horas');
  }

  Widget _buildCursoListItem(Curso curso, Color color, int puntaje) {
    return Row(
      children: <Widget>[
        Container(
          width: 10.0,
          height: 200.0,
          color: color,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  curso.nombre,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Estudiando: " +
                        "\n" +
                        Util.segundosToReloj(curso.tiempoEstudiando),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Enseñando: " +
                        "\n" +
                        Util.segundosToReloj(curso.tiempoEnseniando),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Tiempo viendo videos: " +
                        "\n" +
                        Util.segundosToReloj(curso.tiempoViendoVideos),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Tiempo en clase: " +
                        "\n" +
                        Util.segundosToReloj(curso.tiempoEnClase),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => _openBorrarCursoDialog(curso.codCurso),
                      child: Icon(Icons.delete),
                    ),
                    FlatButton(
                      onPressed: () => _openCursoHorasPage(curso.codCurso),
                      child: Icon(Icons.send),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          height: 130.0,
          width: 130.0,
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(50.0, 0.0),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: color,
                ),
              ),
              Transform.translate(
                offset: Offset(10.0, 20.0),
                child: Card(
                  elevation: 20.0,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 10.0,
                          color: Colors.white,
                          style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                        puntaje.toString(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
