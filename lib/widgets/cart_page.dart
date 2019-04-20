import 'package:flutter/material.dart';
import '../models/index.dart';
import '../utils/index.dart';

class CartPage extends StatelessWidget {
  CartPage(this.cart);
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カート一覧'),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text('現在カートに商品がありません'),
            )
          : ListView(
              children: cart.items.map((item) => ItemTile(item: item)).toList(),
            ),
    );
  }
}

class ItemTile extends StatelessWidget {
  ItemTile({this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isDark(item.product.color) ? Colors.white : Colors.black,
    );

    return Container(
      color: item.product.color,
      child: ListTile(
        title: Text(
          item.product.name,
          style: textStyle,
        ),
        trailing: CircleAvatar(
          backgroundColor: Color(0x33FFFFFF),
          child: Text(
            item.count.toString(),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
