import "dart:async";
import "dart:io" as io;
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import 'package:sqflite/sqflite.dart';

class DataBaseDao {
  static Database instanciaDB;

  static Future<Database> get db async {
    if (instanciaDB == null) instanciaDB = await iniciarDB();
    return instanciaDB;
  }

  /// Crea una base de datos con el nombre de la app
  static iniciarDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Rayn.db");
    var db = await openDatabase(path, version: 1, onCreate: crearTablaCurso);
    return db;
  }

  static void crearTablaCurso(Database db, int version) async {
    String query =
        'CREATE TABLE Curso(codCurso INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, tiempoEstudiando INTEGER, tiempoEnseniando INTEGER, tiempoViendoVideos INTEGER, tiempoEnClase INTEGER)';
    await db.execute(query);
  }
}
