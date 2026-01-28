import 'package:smart_finger/data/services/product_service.dart';

import '../models/product_model.dart';

class ProductRepository {
  final ProductApiService apiService;

  ProductRepository(this.apiService);

  Future<List<Product>> getProducts() async {
    try {
      final products = await apiService.fetchProducts();
      return products;
    } catch (e) {
      rethrow;
    }
  }
}
