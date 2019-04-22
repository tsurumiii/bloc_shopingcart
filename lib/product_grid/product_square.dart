import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../models/index.dart';
import '../utils/index.dart';
import './product_square_bloc.dart';

class ProductSquare extends StatefulWidget {
  final Product product;

  final Stream<List<CartItem>> itemsStream;

  final GestureTapCallback onTap;

  ProductSquare({
    Key key,
    @required this.product,
    @required this.itemsStream,
    this.onTap,
  }) : super(key: key);

  @override
  _ProductSquareState createState() => _ProductSquareState();
}

class _ProductSquareState extends State<ProductSquare> {
  ProductSquareBloc _bloc;
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.product.color,
      child: InkWell(
        onTap: widget.onTap,
        child: StreamBuilder<bool>(
          stream: _bloc.isInCart,
          initialData: _bloc.isInCart.value,
          builder: (context, snapshot) => _createText(snapshot.data),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ProductSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  void _createBloc() {
    _bloc = ProductSquareBloc(widget.product);
    _subscription = widget.itemsStream.listen(_bloc.cartItems.add);
  }

  void _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }

  Widget _createText(bool isInCart) {
    return Text(
      widget.product.name,
      style: TextStyle(
        color: isDark(widget.product.color) ? Colors.white : Colors.black,
        decoration: isInCart ? TextDecoration.underline : null,
      ),
    );
  }
}
