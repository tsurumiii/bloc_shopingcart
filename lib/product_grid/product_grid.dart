import 'package:flutter/material.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_bloc.dart';
import '../catalog/catalog_bloc.dart';
import '../catalog/catalog_slice.dart';
import '../product_grid/product_square.dart';
import './product_square_bloc.dart';

class ProductGrid extends StatelessWidget {
  static const _loadingSpace = 40;
  static const _gridDelegete =
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);

  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    final catalogBloc = CatalogProvider.of(context);

    return StreamBuilder<CatalogSlice>(
      stream: catalogBloc.slice,
      initialData: catalogBloc.slice.value,
      builder: (contex, snapshot) => GridView.builder(
            gridDelegate: _gridDelegete,
            itemCount: snapshot.data.endIndex + _loadingSpace,
            itemBuilder: (context, index) =>
                _createSquare(index, snapshot.data, catalogBloc, cartBloc),
          ),
    );
  }

  Widget _createSquare(int index, CatalogSlice slice, CatalogBloc catalogBloc,
      CartBloc cartBloc) {
    catalogBloc.index.add(index);
    final product = slice.elementAt(index);

    if (product == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ProductSquare(
      key: Key(product.id.toString()),
      product: product,
      itemsStream: cartBloc.items,
      onTap: () {
        print(product);
        cartBloc.cartAddition.add(CartAddition(product));
      },
    );
  }
}
