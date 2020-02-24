import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rayn/dao/curso_dao.dart';
import 'package:rayn/model/curso.dart';

class CursoHoras extends StatefulWidget {
  CursoHoras({Key key, this.codCurso}) : super(key: key);
  int codCurso;
  Curso curso;
  @override
  _CursoHorasState createState() => _CursoHorasState();
}

class _CursoHorasState extends State<CursoHoras> {
  bool contarTiempoEstudiando = false;
  bool contarTiempoEnseniando = false;
  bool contarTiempoViendoVideos = false;
  bool contarTiempoEnClase = false;

  @override
  void initState() {
    CursoDao.getCursoByCodigo(widget.codCurso).then((cur) {
      widget.curso = cur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildEncabezado(),
          _buildTiempoEstudiando(),
        ],
      ),
    );
  }

  Widget _buildEncabezado() {
    return Container();
  }

  Widget _buildTiempoEstudiando() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Tiempo Estudiando',
          ),
          Text(
            widget.curso.tiempoEstudiando.toString(),
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(Curso curso) {
    return Container(
      margin: EdgeInsets.only(
        left: 12,
        right: 16,
      ),
      child: ListTile(
        subtitle: Text("Regions: ${widget.curso.nombre}"),
        title: Container(
          child: Text(
            curso.tiempoEstudiando.toString(),
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        //trailing: _showFavIcon(sen),
      ),
    );
  }

  // Activa o desactiva el contador y actualiza el tiempo en la base de datos
  void onTiempoEstudiandoButton() {
    Timer timer;
    if (contarTiempoEstudiando) {
      timer.cancel();
      CursoDao.updateTiempoEstudiando(
          widget.curso.codCurso, widget.curso.tiempoEstudiando);
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          widget.curso.tiempoEstudiando++;
        });
      });
    }

    contarTiempoEstudiando = !contarTiempoEstudiando;
  }

  // Activa o desactiva el contador y actualiza el tiempo en la base de datos
  void onTiempoEnseniandoButton() {
    Timer timer;
    if (contarTiempoEnseniando) {
      timer.cancel();
      CursoDao.updateTiempoEnseniando(
          widget.curso.codCurso, widget.curso.tiempoEnseniando);
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          widget.curso.tiempoEnseniando++;
        });
      });
    }

    contarTiempoEnseniando = !contarTiempoEnseniando;
  }

  // Activa o desactiva el contador y actualiza el tiempo en la base de datos
  void onTiempoViendoVideosButton() {
    Timer timer;
    if (contarTiempoViendoVideos) {
      timer.cancel();
      CursoDao.updateTiempoViendoVideos(
          widget.curso.codCurso, widget.curso.tiempoViendoVideos);
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          widget.curso.tiempoViendoVideos++;
        });
      });
    }

    contarTiempoViendoVideos = !contarTiempoViendoVideos;
  }

  // Activa o desactiva el contador y actualiza el tiempo en la base de datos
  void onTiempoEnClaseButton() {
    Timer timer;
    if (contarTiempoEnClase) {
      timer.cancel();
      CursoDao.updateTiempoEnClase(
          widget.curso.codCurso, widget.curso.tiempoEnClase);
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          widget.curso.tiempoEnClase++;
        });
      });
    }

    contarTiempoEnClase = !contarTiempoEnClase;
  }
}
