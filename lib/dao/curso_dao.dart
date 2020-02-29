import 'package:rayn/dao/db_dao.dart';
import 'package:rayn/model/curso.dart';

class CursoDao {
  static List<Curso> listaCursos = List<Curso>();

  static void initListaCursos() {
    _updateListaCursos();
  }

  /// CRUD
  /// Inserta un curso
  static Future<void> addCurso(String nombreCurso) async {
    if (nombreCurso == null || nombreCurso == "") {
      return null;
    }
    var dbConnection = await DataBaseDao.db;
    String query = '''
        INSERT INTO Curso(nombre, tiempoEstudiando, tiempoEnseniando, tiempoViendoVideos, tiempoEnClase)
        VALUES(?, ?, ?, ?, ?)
        ''';
    var values = [nombreCurso, 0, 0, 0, 0];
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query, values);
    });
    print("Curso agregado: " + nombreCurso);
    _updateListaCursos();
  }

  /// Elimina un curso
  static Future<void> deleteCurso(int codCurso) async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
      DELETE FROM Curso
      WHERE codCurso=$codCurso
      ''';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    print("Curso eliminado " + codCurso.toString());
    _updateListaCursos();
  }

  /// Actualizar un atributo de un curso
  static void updateCurso(
      String atributo, int codCurso, int nuevoTiempo) async {
    // 0: estudiando, 1: enseniando, 2: viendoVideos, 3: enClase
    var dbConnection = await DataBaseDao.db;
    String query = '''
        UPDATE Curso
        SET $atributo=?
        WHERE codCurso=?
        ''';
    var values = [nuevoTiempo, codCurso];
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query, values);
    });
    _updateListaCursos();
  }

  /// Obtiene la lista de cursos agregados a la base de datos
  static Future<List<Curso>> getCursos() async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT * FROM Curso
        ''';
    List<Map> list = await dbConnection.rawQuery(query);
    List<Curso> listaCursos = List();

    for (int i = 0; i < list.length; i++) {
      Curso curso;
      curso = Curso.fromJson(list[i]);
      listaCursos.add(curso);
    }
    return listaCursos;
  }

  static Future<Curso> getCursoByCodigo(int codCurso) async {
    Curso curso;
    // var dbConnection = await DataBaseDao.db;
    // String query = '''
    //     SELECT * FROM Curso
    //     WHERE codCurso=$codCurso
    //     ''';
    // dbConnection.rawQuery(query).then((list) {
    //   curso = Curso.fromJson(list[0]);
    //   print("lista COMPLETA: " + curso.nombre);
    // });
    for (int i = 0; i < listaCursos.length; i++) {
      if (listaCursos[i].codCurso == codCurso) {
        curso = listaCursos[i];
        break;
      }
    }
    return curso;
  }

  /// Busca un nombre en la lista de cursos
  static Future<bool> containsSentence(String busqueda) async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT * FROM Curso
        WHERE nombre='$busqueda'
        ''';
    List<Map> list = await dbConnection.rawQuery(query);
    bool found;
    list.length == 0 ? found = false : found = true;
    return found;
  }

  static void _updateListaCursos() {
    CursoDao.getCursos().then((cursos) {
      CursoDao.listaCursos = cursos;
    });
    print(" // update lista cursos");
    for (int i = 0; i < listaCursos.length; i++) {
      print(listaCursos[i].nombre);
    }
    print("//");
  }

  static Future<int> getTiempoTotalEstudiando() async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT SUM(tiempoEstudiando) FROM Curso
        ''';
    List<Map> map = await dbConnection.rawQuery(query);
    print(map[0]["SUM(tiempoEstudiando)"]);
    return map[0]["SUM(tiempoEstudiando)"];
  }

  static Future<int> getTiempoTotalEnseniando() async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT SUM(tiempoEnseniando) FROM Curso
        ''';
    List<Map> map = await dbConnection.rawQuery(query);
    print(map[0]["SUM(tiempoEnseniando)"]);
    return map[0]["SUM(tiempoEnseniando)"];
  }

  static Future<int> getTiempoTotalViendoVideos() async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT SUM(tiempoViendoVideos) FROM Curso
        ''';
    List<Map> map = await dbConnection.rawQuery(query);
    return map[0]["SUM(tiempoViendoVideos)"];
  }

  static Future<int> getTiempoTotalEnClase() async {
    var dbConnection = await DataBaseDao.db;
    String query = '''
        SELECT SUM(tiempoEnClase) FROM Curso
        ''';
    List<Map> map = await dbConnection.rawQuery(query);
    return map[0]["SUM(tiempoEnClase)"];
  }
}
