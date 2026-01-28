import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/models/product_model.dart';

class ProductApiService {
  Future<List<Product>> fetchProducts() async {
    final token = await SharedPrefsHelper.getToken();

    final response = await http.get(
      Uri.parse('https://sfadmin.in/app/technician/ledger/view.php'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        final productResponse = ProductResponse.fromJson(jsonData);
        return productResponse.data.products;
      } else {
        throw Exception(jsonData['message'] ?? 'Something went wrong');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
