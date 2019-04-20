import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import '../models/index.dart';

class CartService {
  final List<CartItem> _items = <CartItem>[];

  Set<VoidCallback> _listeners = Set();

  CartService();

  int get itemCount => _items.fold(0, (sum, el) => sum + el.count);

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  void add(Product product, [int count = 1]) {
    _updateCount(product, count);
  }

  void addListener(VoidCallback listenr) => _listeners.add(listenr);

  void remove(Product product, [int count = 1]) {
    _updateCount(product, -count);
  }

  void removeListener(VoidCallback listenr) => _listeners.remove(listenr);

  @override
  String toString() => "$items";

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _updateCount(Product product, int difference) {
    if (difference == 0) return;
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          _notifyListeners();
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        _notifyListeners();
        return;
      }
    }
    if (difference < 0) return;
    _items.add(CartItem(max(difference, 0), product));
    _notifyListeners();
  }
}
