import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "CardOrganizer.db";
  static const _databaseVersion = 1;

  static const folderTable = 'folders';
  static const cardTable = 'cards';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnSuit = 'suit';
  static const columnImageUrl = 'image_url';
  static const columnFolderId = 'folder_id';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $folderTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $cardTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSuit TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnFolderId INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY ($columnFolderId) REFERENCES $folderTable ($columnId) ON DELETE CASCADE
      )
    ''');

    await db.insert(folderTable, {columnName: 'Hearts'});
    await db.insert(folderTable, {columnName: 'Spades'});
    await db.insert(folderTable, {columnName: 'Diamonds'});
    await db.insert(folderTable, {columnName: 'Clubs'});

    await _prepopulateCards(db);
  }

  Future<void> _prepopulateCards(Database db) async {
    List<Map<String, dynamic>> predefinedCards = [];

    List<String> suits = ['Hearts', 'Spades', 'Diamonds', 'Clubs'];
    List<String> values = [
      'Ace',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'Jack',
      'Queen',
      'King',
    ];

    for (String suit in suits) {
      for (int i = 0; i < values.length; i++) {
        predefinedCards.add({
          columnName: '${values[i]} of $suit',
          columnSuit: suit,
          columnImageUrl:
              'assets/cards/${values[i].toLowerCase()}_${suit.toLowerCase()}.png',
          columnFolderId: 0,
        });
      }
    }

    for (var card in predefinedCards) {
      await db.insert(cardTable, card);
    }
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    Database db = await database;
    return await db.query(folderTable);
  }

  Future<int> addCardToFolder(int cardId, int folderId) async {
    Database db = await database;

    int count = (await getCardsInFolder(folderId)).length;
    if (count >= 6) throw Exception("This folder can only hold 6 cards.");

    return await db.update(
      cardTable,
      {columnFolderId: folderId},
      where: '$columnId = ?',
      whereArgs: [cardId],
    );
  }

  Future<int> deleteCard(int id) async {
    Database db = await database;
    return await db.delete(cardTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCardsInFolder(int folderId) async {
    Database db = await database;
    return await db.query(
      cardTable,
      where: '$columnFolderId = ?',
      whereArgs: [folderId],
    );
  }
}
