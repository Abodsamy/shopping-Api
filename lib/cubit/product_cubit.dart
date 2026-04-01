import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../http.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());

      final products =
      await ApiService.fetchProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(
        const ProductError(
          "Failed to load products",
        ),
      );
    }
  }
}