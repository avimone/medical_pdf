import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_pdf/model/book.dart';
import 'package:http/http.dart' as http;

class Subjects extends ChangeNotifier {
  List<String> _items = [
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

  List<String> get items {
    return [..._items];
  }

  Future<void> addSubject(String name) async {
    try {
      var url =
          'https://medical-334bc-default-rtdb.firebaseio.com/subjects.json';

      final response = await http.post(url,
          body: json.encode({
            'name': name,

            //  'creatorid': userId
          }));

      _items.add(name);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetSubjects() async {
    var url = 'https://medical-334bc-default-rtdb.firebaseio.com/subjects.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      final List<String> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(prodData['name']);
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
