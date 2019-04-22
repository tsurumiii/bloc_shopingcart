import 'package:flutter/material.dart';
import '../models/index.dart';
import '../widgets/cart_page.dart';
import './cart_provider.dart';

class BlocCartPage extends StatelessWidget {
  BlocCartPage();

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("カート"),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cart.items,
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? true) {
            return Center(
              child: Text('現在カートにアイテムがありません!!!!!'),
            );
          }
          return ListView(
            children:
                snapshot.data.map((item) => ItemTile(item: item)).toList(),
          );
        },
      ),
    );
  }
}
