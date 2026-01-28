class ProductResponse {
  final int statusCode;
  final String status;
  final String message;
  final ProductData data;

  ProductResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      statusCode: json['status_code'],
      status: json['status'],
      message: json['message'],
      data: ProductData.fromJson(json['data']),
    );
  }
}
class ProductData {
  final int totalProducts;
  final List<Product> products;

  ProductData({
    required this.totalProducts,
    required this.products,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      totalProducts: json['total_products'],
      products: (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
class Product {
  final int productId;
  final String name;
  final String description;
  final String image;
  final int categoryId;
  final String categoryName;
  final num regularPrice;
  final num salePrice;
  final int taxClass;
  final String hsnCode;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
   required this.categoryName,
    required this.regularPrice,
    required this.salePrice,
    required this.taxClass,
    required this.hsnCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id']??0,
      name: json['name']??'',
      description: json['description']??'',
      image: json['image']??'',
      categoryId: json['category_id']??0,
      categoryName: json['category_name']??'Others',
      regularPrice: json['regular_price'] ??0,
      salePrice: json['sale_price'] ??0,
      taxClass: json['tax_class'] ??0,
      hsnCode: json['hsn_code'] ??'',
    );
  }
}
