import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/cart_button.dart';
import './widgets/theme.dart';
import './cart/bloc_cart_page.dart';
import './cart/cart_bloc.dart';
import './cart/cart_provider.dart';
import './catalog/catalog_bloc.dart';
import './product_grid/product_grid.dart';
import './services/catalog.dart';

void main() {
  final catalogService = CatalogService();
  final catalog = CatalogBloc(catalogService);
  final cart = CartBloc();
  runApp(MyApp(catalog, cart));
}

class MyApp extends StatelessWidget {
  final CatalogBloc catalog;
  final CartBloc cart;
  MyApp(this.catalog, this.cart);

  @override
  Widget build(BuildContext context) {
    return CatalogProvider(
      catalog: catalog,
      child: CartProvider(
        cartBloc: cart,
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc"),
        actions: <Widget>[
          StreamBuilder<int>(
            stream: cartBloc.itemCount,
            initialData: cartBloc.itemCount.value,
            builder: (context, snapshot) {
              return CartButton(
                itemCount: snapshot.data,
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => BlocCartPage()));
                },
              );
            },
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}
