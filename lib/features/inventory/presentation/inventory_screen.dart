import 'package:flutter/material.dart';

import 'package:crepas_admin_app/features/inventory/data/datasources/product_local_datasource.dart';
import 'package:crepas_admin_app/features/inventory/data/models/product_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ProductLocalDataSource dataSource = ProductLocalDataSource();

  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await dataSource.getProducts();

    setState(() {
      products = result;
    });
  }

  Future<void> addProduct() async {
    final product = ProductModel(
      name: 'Crepa Oreo',
      price: 85,
      category: 'Crepas',
    );

    await dataSource.insertProduct(product);

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.category),
            trailing: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}
