class Curso {
  int codCurso;
  String nombre;
  int tiempoEstudiando;
  int tiempoEnseniando;
  int tiempoViendoVideos;
  int tiempoEnClase;

  Curso.fromJson(Map<String, dynamic> cur) {
    codCurso = cur['codCurso'];
    nombre = cur['nombre'].toString();
    tiempoEstudiando = cur['tiempoEstudiando'];
    tiempoEnseniando = cur['tiempoEnseniando'];
    tiempoViendoVideos = cur['tiempoViendoVideos'];
    tiempoEnClase = cur['tiempoEnClase'];
  }
}
