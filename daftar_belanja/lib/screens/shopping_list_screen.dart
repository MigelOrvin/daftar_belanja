import 'package:daftar_belanja/services/shopping_service.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ShoppingService _shoppingService = ShoppingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children:[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nama barang',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _shoppingService.addShoppingItem(_controller.text);
                    _controller.clear();
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _shoppingService.getShoppingList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Map<String, dynamic> items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final String key = items.keys.elementAt(index);
                      final String value = items[key] as String;
                      return ListTile(
                        title: Text(value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _shoppingService.removeShoppingItem(key);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}