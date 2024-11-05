import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shoplistofficial/models/shopping_list.dart';
import 'package:shoplistofficial/models/list_items.dart';

class DbHelper{
  Database? db;
  final int version = 1;

  //codigo para que se llame una sola instancia de la BD
  static final DbHelper dbHelper = DbHelper.internal();
  DbHelper.internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async{
    if(db == null){
      db = await openDatabase(join(await getDatabasesPath(),
          'myshoppingv333.db'),
          onCreate: (database, version){
            database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');

            database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, '
                'quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
          },
          version: version);
      //creo y devuelvo la BD
    }
    return db!; //devuelvo la BD
  }

/*
  Future testDB() async{
    db = await openDb();

    await db!.execute('INSERT INTO lists VALUES(0, "CPUs", 2)');
    await db!.execute('INSERT INTO items VALUES(0, 0, "CPUs v1", "3 unds", "Que sea a colores")');

    List list = await db!.rawQuery('SELECT * FROM lists');
    List item = await db!.rawQuery('SELECT * FROM items');

    print(list[0].toString());
    print(item[0].toString());
  }
*/

  //C R U D
  //insert - update "lists"
  Future<int> insertList(ShoppingList list) async{
    int id = await this.db!.insert('lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); //linea fundamental!!

    return id;
  }

  //insert - update "lists"
  Future<int> insertItem(ListItems item) async{
    int id = await this.db!.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); //linea fundamental!!

    return id;
  }

  //mostrar "lists"
  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }
}