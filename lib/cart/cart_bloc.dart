import 'dart:async';

import '../models/index.dart';
import '../services/cart.dart';
import 'package:rxdart/rxdart.dart';

class CartAddition {
  final Product product;
  final int count;
  CartAddition(this.product, [this.count = 1]);
}

class CartBloc {
  final _cart = CartService();

  final BehaviorSubject<List<CartItem>> _items =
      BehaviorSubject<List<CartItem>>.seeded(const []);

  final BehaviorSubject<int> _itemCout = BehaviorSubject<int>.seeded(0);

  final StreamController<CartAddition> _cartAddtionController =
      StreamController<CartAddition>();

  CartBloc() {
    _cartAddtionController.stream.listen(_handleAddition);
  }

  Sink<CartAddition> get cartAddition => _cartAddtionController.sink;

  ValueObservable<int> get itemCount =>
      _itemCout.distinct().shareValueSeeded(0);

  ValueObservable<List<CartItem>> get items => _items.stream;

  void dispose() {
    _items.close();
    _itemCout.close();
    _cartAddtionController.close();
  }

  void _handleAddition(CartAddition addtion) {
    print("1: ${addtion.product}");
    print("2: ${addtion.count}");
    _cart.add(addtion.product, addtion.count);
    _items.add(_cart.items);
    _itemCout.add(_cart.itemCount);
  }
}
