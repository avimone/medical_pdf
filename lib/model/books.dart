import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_pdf/model/book.dart';
import 'package:http/http.dart' as http;

class Books extends ChangeNotifier {
  List<Book> _items = [
    /*   Book(
        "APLEY & SOLOMON'S System of Orthopaedics and Trauma",
        "1",
        "gadgetspidy.com",
        "assets/Apley_solomon_system_of_orthopaedics_and_trauma.jpeg"),
    Book("Textbook of Orthopaedics", "2", "gadgetspidy.com",
        "assets/Textbook_of_Orthopedics.jpeg"),
    Book("Textbook of Anatomy ABDOMEN AND LOWER LIMB", "3", "gadgetspidy.com",
        "assets/Textbook_of_Anatomy_Abdomen_LowerLimb.jpeg"),
    Book("Essentials of medical pharmacology", "4", "gadgetspidy.com",
        "assets/Essentials_Medical_pharmacology.jpeg"),
    Book("pathophysiology", "5", "gadgetspidy.com",
        "assets/pathophysiology.jpeg"),
    Book("General Surgery", "6", "gadgetspidy.com",
        "assets/general_surgery.jpeg"),
    Book("Basic Principle of Surgery", "7", "gadgetspidy.com",
        "assets/basic_principle_of_surgery.jpeg"),
    Book("Pharmacology", "8", "gadgetspidy.com",
        "assets/pharmacology_sarah.jpeg"),
    Book("Fundamentals of Pathology", "9", "gadgetspidy.com",
        "assets/fundamentals_of_pathology.jpeg"),
    Book("Essentials of Medical Physiology", "10", "gadgetspidy.com",
        "assets/essentials_of_medical_physiology.jpeg") */
  ];

  List<Book> get items {
    return [..._items];
  }

  Future<void> addBook(
      String id, String name, String link, String imageUrl) async {
    try {
      var url = 'https://medical-334bc-default-rtdb.firebaseio.com/books.json';
      print("adding");
      final response = await http.post(url,
          body: json.encode({
            'id': "All",
            'name': name,
            'link': link,
            'imageUrl': imageUrl,
            //  'creatorid': userId
          }));

      final newProduct = Book(
        name: name,
        link: link,
        imageUrl: imageUrl,
        //     imageUrl: imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addBookRequest(
      String id, String name, String link, String imageUrl) async {
    try {
      var url = 'https://medical-334bc-default-rtdb.firebaseio.com/bookrq.json';
      print("adding request");
      final response = await http.post(url,
          body: json.encode({
            'id': "All",
            'name': name,
            'link': link,
            'imageUrl': imageUrl,
            //  'creatorid': userId
          }));

      final newProduct = Book(
        name: name,
        link: link,
        imageUrl: imageUrl,
        //     imageUrl: imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetBooks() async {
    var url = 'https://medical-334bc-default-rtdb.firebaseio.com/books.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      final List<Book> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Book(
          id: prodData['id'],
          name: prodData['name'],
          link: prodData['link'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
/*
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
           'https://medical-334bc-default-rtdb.firebaseio.com/books/$id.json';
      await http.patch(url,
          body: json.encode({
            'name': newProduct.name,
            'amount': newProduct.amount,
            //    'imageurl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
*/

}
