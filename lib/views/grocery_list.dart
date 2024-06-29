import 'dart:developer';

import 'package:demo_handling_input_forms/models/grocery_item.dart';
import 'package:flutter/material.dart';
import 'package:demo_handling_input_forms/data/dummy_items.dart';
import 'package:demo_handling_input_forms/views/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          final item = _groceryItems[index];
          log('_groceryItems: $_groceryItems');

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
