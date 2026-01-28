import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/product_model.dart';
import 'package:smart_finger/presentation/cubit/products/product_cubit.dart';
import 'package:smart_finger/presentation/cubit/products/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool showSearchFilter = false;
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().loadProducts();
    });
  }

  List<Product> _applyFilter(List<Product> products) {
    return products.where((p) {
      final matchName = p.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchCategory =
          selectedCategory == 'All' || p.categoryName == selectedCategory;
      return matchName && matchCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.primary,
        elevation: 5,
        title: const Text("Products", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              color: Colors.white,
              showSearchFilter ? Icons.close : Icons.filter_list_rounded,
            ),
            onPressed: () {
              setState(() {
                showSearchFilter = !showSearchFilter;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            final categories = [
              'All',
              ...state.products.map((e) => e.categoryName).toSet(),
            ];

            final filteredProducts = _applyFilter(state.products);

            return Column(
              children: [
                _searchAndFilter(categories),

                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text("No products found"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _productCard(filteredProducts[index]);
                          },
                        ),
                ),
              ],
            );
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _searchAndFilter(List<String> categories) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: showSearchFilter ? 70 : 0,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: showSearchFilter ? 8 : 0,
      ),
      child: showSearchFilter
          ? Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() => searchQuery = value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Search product",
                        prefixIcon: Icon(Icons.search_rounded),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,

                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.tune_rounded),
                      onSelected: (value) {
                        setState(() => selectedCategory = value);
                      },
                      itemBuilder: (context) => categories
                          .map((e) => PopupMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _productCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  product.categoryName,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "₹${product.salePrice}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (product.regularPrice > product.salePrice)
                      Text(
                        "₹${product.regularPrice}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
