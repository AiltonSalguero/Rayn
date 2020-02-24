import 'package:rayn/dao/db_dao.dart';
import 'package:rayn/model/curso.dart';

class CursoDao {
  static List<Curso> listaCursos;

  CursoDao() {
    _updateListaCursos();
  }

  /// CRUD
  /// Inserta un curso
  static void addCurso(Curso curso) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'INSERT INTO Curso(nombre, tiempoEstudiando) VALUES(\'$curso.nombre\', \'$curso.tiempoEstudiando\')';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
    _updateListaCursos();
  }

  /// Elimina un curso
  static void deleteCurso(int codCurso) async {
    var dbConnection = await DataBaseDao.db;
    String query = 'DELETE FROM Curso WHERE codCurso=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  /// Actualizar nombre de un curso
  static void updateNombre(int codCurso, String nuevoNombre) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'UPDATE Curso SET nombre=\'$nuevoNombre\' WHERE id=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  /// Actualizar tiempoEstudiando de un curso
  static void updateTiempoEstudiando(int codCurso, int nuevoTiempo) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'UPDATE Curso SET tiempoEstudiando=$nuevoTiempo WHERE id=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  static void updateTiempoEnseniando(int codCurso, int nuevoTiempo) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'UPDATE Curso SET tiempoEnseniando=$nuevoTiempo WHERE id=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  static void updateTiempoViendoVideos(int codCurso, int nuevoTiempo) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'UPDATE Curso SET tiempoViendoVideos=$nuevoTiempo WHERE id=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  static void updateTiempoEnClase(int codCurso, int nuevoTiempo) async {
    var dbConnection = await DataBaseDao.db;
    String query =
        'UPDATE Curso SET tiempoEnClase=$nuevoTiempo WHERE id=$codCurso';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
    _updateListaCursos();
  }

  /// Obtiene la lista de cursos agregados a la base de datos
  static Future<List<Curso>> getCursos() async {
    var dbConnection = await DataBaseDao.db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM Curso');
    List<Curso> listaCursos = List();

    for (int i = 0; i < listaCursos.length; i++) {
      Curso curso = Curso();
      curso.codCurso = list[i]['codCurso'];
      curso.nombre = list[i]['nombre'];
      curso.tiempoEstudiando = list[i]['tiempoEstudiando'];

      listaCursos.add(curso);
    }
    return listaCursos;
  }

  static Future<Curso> getCursoByCodigo(int codCurso) async {
    Curso curso = Curso();
    var dbConnection = await DataBaseDao.db;
    List<Map> list = await dbConnection
        .rawQuery('SELECT * FROM Curso WHERE codCurso=$codCurso');
    curso.codCurso = codCurso;
    curso.nombre = list[0]['nombre'];
    curso.tiempoEstudiando = list[0]['tiempoEstudiando'];

    return curso;
  }

  /// Busca un nombre en la lista de cursos
  static Future<bool> containsSentence(String busqueda) async {
    var dbConnection = await DataBaseDao.db;
    List<Map> list = await dbConnection
        .rawQuery('SELECT * FROM Curso WHERE nombre=\'$busqueda\'');
    bool found;
    list.length == 0 ? found = false : found = true;
    return found;
  }

  static void _updateListaCursos() {
    CursoDao.getCursos().then((cursos) {
      CursoDao.listaCursos = cursos;
    });
  }
}
