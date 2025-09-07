import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_6/data/categories.dart';
import 'package:project_6/models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState () {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
      dotenv.env['FIREBASE_DOMAIN']!,
      "shopping-list.json"
    );

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere(
        (catItem) => catItem.value.title == item.value['category']
      ).value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category
        )
      );
    }
    return loadedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries')
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString())
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No items added yet.')
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => ListTile(
              title: Text(snapshot.data![index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: snapshot.data![index].category.color
              ),
              trailing: Text(snapshot.data![index].quantity.toString())
            )
          );
        }
      )
    );
  }
}