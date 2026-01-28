class SelectedProduct {
  final int productId;
  final String name;
  final double price;
  int quantity;

  SelectedProduct({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}
