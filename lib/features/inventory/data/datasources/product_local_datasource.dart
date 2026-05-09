import 'package:sqflite/sqflite.dart';

import 'package:crepas_admin_app/core/database/app_database.dart';
import 'package:crepas_admin_app/features/inventory/data/models/product_model.dart';

class ProductLocalDataSource {
  Future<void> insertProduct(ProductModel product) async {
    final Database db = await AppDatabase.database;

    await db.insert('products', product.toMap());
  }

  Future<List<ProductModel>> getProducts() async {
    final Database db = await AppDatabase.database;

    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(
      maps.length,
      (index) => ProductModel.fromMap(maps[index]),
    );
  }

  Future<void> deleteProduct(int id) async {
    final Database db = await AppDatabase.database;

    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateProduct(ProductModel product) async {
    final Database db = await AppDatabase.database;

    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}
