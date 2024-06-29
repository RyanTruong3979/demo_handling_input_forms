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

  void _removeItem(String id) {
    setState(() {
      _groceryItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      alignment: Alignment.center,
      child: const Text(
        'No items added yet!',
        style: TextStyle(fontSize: 20),
      ),
    );

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
      body: _groceryItems.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                onDismissed: (direction) {
                  _removeItem(_groceryItems[index].id);
                },
                key: ValueKey(_groceryItems[index].id),
                child: ListTile(
                  title: Text(_groceryItems[index].name),
                  subtitle: Text('Quantity: ${_groceryItems[index].quantity}'),
                  // trailing: Text(item.quantity.toString()),
                  leading: CircleAvatar(
                    backgroundColor: _groceryItems[index].category.color,
                  ),
                ),
              ),
            )
          : content,
    );
  }
}
