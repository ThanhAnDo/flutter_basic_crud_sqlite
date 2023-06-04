import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  //tạo table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT, 
        desc TEXT, 
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )""");
  }

  //tạo file chứa data
  static Future<sql.Database> db() async {
    return sql.openDatabase("database_name1.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //tạo data
  static Future<int> createData(String title, String? desc) async {
    final db = await SqlHelper.db();
    //bảng data
    final data = {
      'colTitle': title, //cot title
      'colDesc': desc, //cot desc
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //lấy list all data từ dataTable
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SqlHelper.db();
    return db.query('data', orderBy: 'id');
  }

  //lấy từng data từ dataTable
  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SqlHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //update data trong table
  static Future<int> updateData(int id, String title, String? desc) async {
    final db = await SqlHelper.db();
    final data = {
      'colTitle': title,
      'colDesc': desc,
      'createdAt': DateTime.now().toString(),
    };
    final result =
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //xóa data trong table
  static Future<void> deleteData(int id) async {
    final db = await SqlHelper.db();
   await db.delete('data', where: "id = ?", whereArgs: [id]);
  }
}
