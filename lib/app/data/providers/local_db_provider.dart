import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/currency_model.dart';

class LocalDbProvider {
  static const _dbName = 'hitung_koin.db';
  static const _dbVersion = 1;

  static final LocalDbProvider _instance = LocalDbProvider._internal();
  factory LocalDbProvider() => _instance;
  LocalDbProvider._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        balance REAL DEFAULT 0,
        icon TEXT,
        currency_code TEXT DEFAULT 'IDR'
      );
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT,
        color TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        receipt_image_path TEXT,
        FOREIGN KEY (account_id) REFERENCES accounts(id),
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE recurring_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        frequency TEXT NOT NULL,
        next_run_date TEXT NOT NULL,
        note TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (account_id) REFERENCES accounts(id),
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE currencies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE NOT NULL,
        symbol TEXT NOT NULL,
        exchange_rate REAL NOT NULL,
        is_default INTEGER DEFAULT 0
      );
    ''');
    // optional seed data can be inserted here later
  }

  // ------- Account CRUD -------
  Future<int> insertAccount(AccountModel account) async {
    final db = await database;
    return await db.insert('accounts', account.toJson());
  }

  Future<List<AccountModel>> getAllAccounts() async {
    final db = await database;
    final maps = await db.query('accounts');
    return maps.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<int> updateAccount(AccountModel account) async {
    final db = await database;
    return await db.update('accounts', account.toJson(),
        where: 'id = ?', whereArgs: [account.id]);
  }

  Future<int> deleteAccount(int id) async {
    final db = await database;
    return await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  // ------- Category CRUD -------
  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toJson());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((e) => CategoryModel.fromJson(e)).toList();
  }

  // ------- Transaction CRUD -------
  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await database;
    return await db.insert('transactions', txn.toJson());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final maps = await db.query('transactions');
    return maps.map((e) => TransactionModel.fromJson(e)).toList();
  }

  // ------- Recurring Transaction CRUD -------
  Future<int> insertRecurring(RecurringTransactionModel rt) async {
    final db = await database;
    return await db.insert('recurring_transactions', rt.toJson());
  }

  Future<List<RecurringTransactionModel>> getAllRecurring() async {
    final db = await database;
    final maps = await db.query('recurring_transactions');
    return maps.map((e) => RecurringTransactionModel.fromJson(e)).toList();
  }

  // ------- Currency CRUD -------
  Future<int> insertCurrency(CurrencyModel cur) async {
    final db = await database;
    return await db.insert('currencies', cur.toJson());
  }

  Future<List<CurrencyModel>> getAllCurrencies() async {
    final db = await database;
    final maps = await db.query('currencies');
    return maps.map((e) => CurrencyModel.fromJson(e)).toList();
  }
}
