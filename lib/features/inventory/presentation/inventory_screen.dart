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

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  List<ProductModel> products = [];
  ProductModel? editingProduct;

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
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty) {
      return;
    }

    final product = ProductModel(
      id: editingProduct?.id,
      name: nameController.text,
      price: double.parse(priceController.text),
      category: categoryController.text,
    );

    if (editingProduct == null) {
      await dataSource.insertProduct(product);
    } else {
      await dataSource.updateProduct(product);
    }

    editingProduct = null;

    nameController.clear();
    priceController.clear();
    categoryController.clear();

    if (!mounted) return;

    Navigator.pop(context);

    loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await dataSource.deleteProduct(id);

    loadProducts();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product deleted')));
  }

  void showAddProductDialog() {
    editingProduct = null;

    nameController.clear();
    priceController.clear();
    categoryController.clear();

    showProductDialog();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(editingProduct == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: addProduct,
              child: Text(editingProduct == null ? 'Save' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void showProductDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(editingProduct == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: addProduct,
              child: Text(editingProduct == null ? 'Save' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void editProduct(ProductModel product) {
    editingProduct = product;

    nameController.text = product.name;
    priceController.text = product.price.toString();
    categoryController.text = product.category;

    showProductDialog();
  }

  void showDeleteDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await deleteProduct(product.id!);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProductDialog,
        child: const Icon(Icons.add, size: 30),
      ),
      body: products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No products yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add products',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      editProduct(product);
                    },
                    onLongPress: () {
                      showDeleteDialog(product);
                    },
                    leading: CircleAvatar(
                      radius: 24,
                      child: Text(product.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            color: Colors.pink.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    trailing: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
