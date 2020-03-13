import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rayn/dao/curso_dao.dart';
import 'package:rayn/model/curso.dart';
import 'package:rayn/util/curso_seleccionado.dart';
import 'package:rayn/util/util.dart';

class CursoHoras extends StatefulWidget {
  @override
  _CursoHorasState createState() => _CursoHorasState();
}

class _CursoHorasState extends State<CursoHoras> {
  Curso curso;
  Timer temporizador;
  int tiempo;
  bool contarTiempoEstudiando = false;
  bool contarTiempoEnseniando = false;
  bool contarTiempoViendoVideos = false;
  bool contarTiempoEnClase = false;

  @override
  void initState() {
    CursoDao.getCursoByCodigo(CursoSeleccionado.codCurso).then((cur) {
      curso = cur;
      setState(() {});
      print("Curso seleccionado es :" + cur.nombre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        elevation: 0.0,
        title: Text(
          curso.nombre,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            curso == null
                ? Text("wait")
                : Center(
                    child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Card(
                      elevation: 10.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: _buildTiempo(),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildTiempo() {
    // TODO Muestra tiempo en horas, boton para parar, renaurar,mostrar puntaje
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTime("Tiempo estudiando", curso.tiempoEstudiando),
            Switch(
              value: contarTiempoEstudiando,
              onChanged: (value) {
                setState(() {
                  pausarTodosLosContadores();
                  contarTiempoEstudiando = value;
                  onTiempoSwitchButton(
                      "tiempoEstudiando", contarTiempoEstudiando);
                });
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildTime("Tiempo enseñando", curso.tiempoEnseniando),
            Switch(
              value: contarTiempoEnseniando,
              onChanged: (value) {
                setState(() {
                  pausarTodosLosContadores();
                  contarTiempoEnseniando = value;

                  onTiempoSwitchButton(
                      "tiempoEnseniando", contarTiempoEnseniando);
                });
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildTime("Tiempo viendo videos", curso.tiempoViendoVideos),
            Switch(
              value: contarTiempoViendoVideos,
              onChanged: (value) {
                setState(() {
                  pausarTodosLosContadores();
                  contarTiempoViendoVideos = value;
                  onTiempoSwitchButton(
                      "tiempoViendoVideos", contarTiempoViendoVideos);
                });
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildTime("Tiempo en clase", curso.tiempoEnClase),
            Switch(
              value: contarTiempoEnClase,
              onChanged: (value) {
                pausarTodosLosContadores();
                setState(() {
                  contarTiempoEnClase = value;
                  onTiempoSwitchButton("tiempoEnClase", contarTiempoEnClase);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  //Widget _buildTiempoRow(String titulo, int tiempo, bool contarTiempo) {
  // Hacer una sola fucion para todos
  Widget _buildTime(String tipoTiempo, int tiempo) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            tipoTiempo,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            Util.segundosToReloj(tiempo),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Activa o desactiva el contador y actualiza el tiempo en la base de datos
  void onTiempoSwitchButton(String tipoTiempo, bool contarTiempo) {
    if (contarTiempo) {
      temporizador = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          switch (tipoTiempo) {
            case "tiempoEstudiando":
              curso.tiempoEstudiando++;
              tiempo = curso.tiempoEstudiando;
              break;
            case "tiempoEnseniando":
              curso.tiempoEnseniando++;
              tiempo = curso.tiempoEnseniando;
              break;
            case "tiempoViendoVideos":
              curso.tiempoViendoVideos++;
              tiempo = curso.tiempoViendoVideos;
              break;
            case "tiempoEnClase":
              curso.tiempoEnClase++;
              tiempo = curso.tiempoEnClase;
              break;
          }
        });
      });
    } else {
      temporizador.cancel();
      CursoDao.updateCurso(tipoTiempo, curso.codCurso, tiempo);
    }
  }

  void pausarTodosLosContadores() {
    if (temporizador != null) {
      temporizador.cancel();
    }

    if (contarTiempoEstudiando) {
      contarTiempoEstudiando = false;
      onTiempoSwitchButton("tiempoEstudiando", contarTiempoEstudiando);
    }
    if (contarTiempoEnseniando) {
      contarTiempoEnseniando = false;
      onTiempoSwitchButton("tiempoEnseniando", contarTiempoEnseniando);
    }
    if (contarTiempoViendoVideos) {
      contarTiempoViendoVideos = false;
      onTiempoSwitchButton("tiempoViendoVideos", contarTiempoViendoVideos);
    }
    if (contarTiempoEnClase) {
      contarTiempoEnClase = false;
      onTiempoSwitchButton("tiempoEnClase", contarTiempoEnClase);
    }
  }
}
