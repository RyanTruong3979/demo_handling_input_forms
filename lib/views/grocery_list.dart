import 'dart:convert';
import 'dart:developer';

import 'package:demo_handling_input_forms/data/categories.dart';
import 'package:demo_handling_input_forms/models/grocery_item.dart';
import 'package:flutter/material.dart';
import 'package:demo_handling_input_forms/views/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // get data from the server
    _fetchData();
  }

  // Get data from the server
  void _fetchData() async {
    final response = await http.get(
      Uri.parse('https://shopping-list-demo-5b845-default-rtdb'
          '.asia-southeast1.firebasedatabase.app/shopping_list.json'),
    );

    // log('_fetchData: ${response.body}');

    List<GroceryItem> _loadedItems = <GroceryItem>[];

    // Convert the response body to a list of maps
    // Exp: {"-O0cQsxkWDlJknittrqs":{"category":"Dairy","name":"Milk","quantity":11},
    // With "-O0cQsxkWDlJknittrqs" => String
    // {"category":"Dairy","name":"Milk","quantity":11} => Map<String, dynamic>
    final Map<String, dynamic> listData = jsonDecode(response.body);

    //
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((ite) => ite.value.name == item.value['category'])
          .value;
      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    log('_loadedItems: $_loadedItems');

    setState(() {
      _groceryItems = _loadedItems;
      _isLoading = false;
    });
  }

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

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
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
      body: content,
    );
  }
}
