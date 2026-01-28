import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../../data/repositories/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({
    required this.repository,
  }) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } 
    on SocketException catch (_) {
      emit(ProductError("NO_INTERNET"));
    } 
    catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
