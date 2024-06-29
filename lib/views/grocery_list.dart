import 'package:flutter/material.dart';
import 'package:demo_handling_input_forms/data/dummy_items.dart';
import 'package:demo_handling_input_forms/views/new_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    void _addItem() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const NewItem(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return ListTile(
              title: Text(item.name),
              subtitle: Text('Quantity: ${item.quantity}'),
              // trailing: Text(item.quantity.toString()),
              leading: CircleAvatar(
                backgroundColor: item.category.color,
              ));
        },
      ),
    );
  }
}
