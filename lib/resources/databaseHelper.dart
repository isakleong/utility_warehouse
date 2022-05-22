import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  String tableName;

  SQLHelper({this.tableName});

  static Future<void> createTables(sql.Database database, {String tableName}) async {
    if(tableName.toLowerCase().contains("hk_stockopnameheader")) {
      String query = """CREATE TABLE IF NOT EXISTS HK_StockOpnameHeader(
        Id integer PRIMARY KEY ASC, TanggalTarikData date ,Cabang varchar(5) ,ProductGroupCode varchar(50) ,Jenis varchar(50) ,SuratJalanTerakhir varchar(50) ,KodeCustomer varchar(20) ,NamaCustomer varchar(100) ,
        JumlahBinTerdaftar int ,BinTepat int ,KetepatanJumlahPadaBin int ,KetepatanJumlahBin int ,JumlahPadaBin int ,ZoneShipment varchar(50) ,ZoneReceipt varchar(50) ,ZoneAdjustment varchar(50) ,
        TotalQty int ,NamaKepalaCabang varchar(100) ,NamaKepalaAdministrasi varchar(100) ,SelisihItemBinContent int , SaldoItemDesimal int,UpdateUserId varchar(50) ,UpdateTime datetime,
        Complete int, Upload int, DownloadCount int""";

      await database.execute("""CREATE TABLE hk_stockopnameheader(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    }

    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  Future<sql.Database> db() async {
    return sql.openDatabase(
      '/storage/emulated/0/Android/data/com.example.test_sqlite/files/kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database, tableName: tableName);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String descrption) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}










// class SQLHelper {
//   static Future<void> createTables(sql.Database database) async {
//     await database.execute("""CREATE TABLE Pick(
//         pickNo TEXT PRIMARY KEY NOT NULL,
//         wsNo TEXT,
//         source TEXT,
//         weight DECIMAL(38,2),
//         userId TEXT,
//         date DATE,
//         sales TEXT,
//         gudang TEXT,
//         custName TEXT,
//         contactName TEXT,
//         city TEXT,
//         postcode TEXT,
//         county TEXT,
//         province TEXT,
//         dtmCreated DATETIME
//       )
//       """);
//   }
// // id: the id of a item
// // title, description: name and description of your activity
// // created_at: the time that the item was created. It will be automatically handled by SQLite

//   static Future<sql.Database> db() async {
//     return sql.openDatabase(
//       'pick.db',
//       version: 1,
//       onCreate: (sql.Database database, int version) async {
//         await createTables(database);
//       },
//     );
//   }

//   // Create new item (journal)
//   static Future<int> createItem(String pickNo, String wsNo) async {
//     final db = await SQLHelper.db();

//     final data = {'pickNo': pickNo, 'wsNo': wsNo};
//     final id = await db.insert('items', data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getItems() async {
//     final db = await SQLHelper.db();
//     return db.query('items', orderBy: "id");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getItem(int id) async {
//     final db = await SQLHelper.db();
//     return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateItem(
//       int id, String title, String descrption) async {
//     final db = await SQLHelper.db();

//     final data = {
//       'title': title,
//       'description': descrption,
//       'createdAt': DateTime.now().toString()
//     };

//     final result =
//         await db.update('items', data, where: "id = ?", whereArgs: [id]);
//     return result;
//   }

//   // Delete
//   static Future<void> deleteItem(int id) async {
//     final db = await SQLHelper.db();
//     try {
//       await db.delete("items", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       print("Something went wrong when deleting an item: "+err);
//     }
//   }
// }
