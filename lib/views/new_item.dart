import 'dart:convert';
import 'dart:developer';

import 'package:demo_handling_input_forms/models/category.dart';
import 'package:demo_handling_input_forms/models/grocery_item.dart';
import 'package:flutter/material.dart';
import 'package:demo_handling_input_forms/data/categories.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // Create a global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  bool _isLoading = false;

  void _saveItem() async {
    // Su dung _formKey.currentState để truy cập vào FormState và gọi phương
    // thức validate() để kiểm tra xem form có hợp lệ không.
    // Validate returns true if the form is valid, or false otherwise
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      // Create url to post data
      final url = Uri.https(
          'shopping-list-demo-5b845-default-rtdb.asia-southeast1'
              '.firebasedatabase.app',
          'shopping_list.json');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.name,
          },
        ),
      );
      final Map<String, dynamic> restData = jsonDecode(response.body);

      // Check if the context is still mounted
      if (!context.mounted) return;

      // Use the Navigator to pop the screen and pass the data back to the previous screen
      Navigator.of(context).pop(
        GroceryItem(
          id: restData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );

      // If the form is valid, display a snackbar. In the real world, you'd save the data to a database
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  // Check validation
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  // Save the value
                  _enteredName = value!;
                  log('Name:  ${_enteredName}');
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _enteredQuantity.toString(),
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // Check validation
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // Save the value
                        log('Quantity:  ${value}');
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        // use .entries to get the key-value pairs of the map (categories)
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(category.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        // Khi onChanged được gọi, giá trị của _selectedCategory sẽ được cập nhật
                        // nen khong can goi onSave
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  // For submit form
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator())
                        : const Text('Add '
                            'Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
