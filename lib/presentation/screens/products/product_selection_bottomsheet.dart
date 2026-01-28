import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/data/models/product_model.dart';
import 'package:smart_finger/data/models/selected_products.dart';
import 'package:smart_finger/presentation/cubit/products/product_cubit.dart';
import 'package:smart_finger/presentation/cubit/products/product_state.dart';

class ProductSelectionBottomSheet extends StatefulWidget {
  final Complaint complaint;
  final Function(List<SelectedProduct>) onCheckout;

  const ProductSelectionBottomSheet({
    super.key,
    required this.complaint,
    required this.onCheckout,
  });

  @override
  State<ProductSelectionBottomSheet> createState() =>
      _ProductSelectionBottomSheetState();
}

class _ProductSelectionBottomSheetState
    extends State<ProductSelectionBottomSheet> {
  final List<SelectedProduct> selectedProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  void _addProduct(Product p) {
    final index = selectedProducts.indexWhere((e) => e.productId == p.productId);

    setState(() {
      if (index == -1) {
        selectedProducts.add(
          SelectedProduct(
            productId: p.productId,
            name: p.name,
            price: p.salePrice.toDouble(),
          ),
        );
      } else {
        selectedProducts[index].quantity++;
      }
    });
  }

  void _removeProduct(SelectedProduct p) {
    setState(() {
      p.quantity--;
      if (p.quantity == 0) {
        selectedProducts.remove(p);
      }
    });
  }

  double get totalAmount => selectedProducts.fold(0, (sum, p) => sum + p.total);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9, 
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              "Select Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: "Search product",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// PRODUCT LIST
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductLoaded) {
                    final products = state.products
                        .where(
                          (p) => p.name.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ),
                        )
                        .toList();

                    if (products.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final p = products[i];
                        final cartItem = selectedProducts
                            .where((e) => e.productId == p.productId)
                            .toList();

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                /// NAME + PRICE
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${p.salePrice}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// CART ACTIONS
                                cartItem.isEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: AppColors.primary,
                                          size: 30,
                                        ),
                                        onPressed: () => _addProduct(p),
                                      )
                                    : Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () =>
                                                _removeProduct(cartItem.first),
                                          ),
                                          Text(
                                            cartItem.first.quantity.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            onPressed: () => _addProduct(p),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            /// TOTAL + CHECKOUT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₹${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: selectedProducts.isEmpty
                        ? null
                        : () => widget.onCheckout(selectedProducts),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
