import 'package:bloc/bloc.dart';
import 'package:inventory_app/core/usecases/usecase.dart';
import 'package:inventory_app/features/products/domain/usecases/create_product.dart';
import 'package:inventory_app/features/products/domain/usecases/delete_product.dart';
import 'package:inventory_app/features/products/domain/usecases/get_all_products.dart';
import 'package:inventory_app/features/products/domain/usecases/get_product_by_id.dart';
import 'package:inventory_app/features/products/domain/usecases/get_products_by_category.dart';
import 'package:inventory_app/features/products/domain/usecases/search_products.dart'
    as usecase;
import 'package:inventory_app/features/products/domain/usecases/update_product.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_event.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetProductById getProductById;
  final GetProductsByCategory getProductsByCategory;
  final usecase.SearchProducts searchProducts;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.getProductsByCategory,
    required this.searchProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductsLoading());
    final result = await getAllProducts(NoParams());

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  void _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await getProductById(Params(id: event.id));

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (product) => emit(ProductLoaded(product: product)),
    );
  }

  void _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await getProductsByCategory(
      GetProductsByCategoryParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await searchProducts(
      usecase.SearchProductsParams(searchTerm: event.searchTerm),
    );

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(
        ProductsSearched(products: products, searchTerm: event.searchTerm),
      ),
    );
  }

  void _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await createProduct(
      CreateProductParams(product: event.product),
    );

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (product) => emit(ProductCreated(product: product)),
    );
  }

  void _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await updateProduct(
      UpdateProductParams(product: event.product),
    );

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (product) => emit(ProductUpdated(product: product)),
    );
  }

  void _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await deleteProduct(DeleteProductParams(id: event.id));

    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (success) => emit(ProductDeleted(id: event.id)),
    );
  }
}
