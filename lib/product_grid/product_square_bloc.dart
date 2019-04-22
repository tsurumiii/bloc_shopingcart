import 'dart:async';

import '../models/index.dart';
import 'package:rxdart/rxdart.dart';

class ProductSquareBloc {
  final _isInCartSubject = BehaviorSubject<bool>.seeded(false);

  final StreamController<List<CartItem>> _cartItemsController =
      StreamController<List<CartItem>>();

  ProductSquareBloc(Product product) {
    _cartItemsController.stream
        .map((list) => list.any((item) => item.product == product))
        .listen((isInCart) => _isInCartSubject.add(isInCart));
  }

  Sink<List<CartItem>> get cartItems => _cartItemsController.sink;

  ValueObservable<bool> get isInCart => _isInCartSubject.stream;

  void dispose() {
    _cartItemsController.close();
    _isInCartSubject.close();
  }
}
