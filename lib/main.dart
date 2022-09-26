import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getJokes();
  }

  Future<List<Product>> _getJokes() async {
    var res = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/product/all_products'));
    print(res.body);

    List<Product> products = [];
    products = productFromJson(res.body);

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: FutureBuilder(
        future: _getJokes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data[index].image),
                  ),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].description),
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
    );
  }
}

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.weight,
    required this.price,
    required this.description,
    required this.image,
  });

  final int id;
  final Category category;
  final String name;
  final int weight;
  final int price;
  final String description;
  final String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    category: Category.fromJson(json["category"]),
    name: json["name"],
    weight: json["weight"],
    price: json["price"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category.toJson(),
    "name": name,
    "weight": weight,
    "price": price,
    "description": description,
    "image": image,
  };
}

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.name,
    required this.description,
    required this.image,
    required this.isActive,
    required this.children,
  });

  final String name;
  final String description;
  final String image;
  final bool? isActive;
  final List<dynamic> children;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    description: json["description"],
    image: json["image"],
    isActive: json["is_active"],
    children: List<dynamic>.from(json["children"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "image": image,
    "is_active": isActive,
    "children": List<dynamic>.from(children.map((x) => x)),
  };
}
