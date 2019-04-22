import 'dart:math';

import '../models/index.dart';
import '../services/catalog_page.dart';

class CatalogSlice {
  final List<CatalogPage> _pages;

  final int startIndex;

  final bool hasNext;

  CatalogSlice(this._pages, this.hasNext)
      : startIndex = _pages.map((f) => f.startIndex).fold(0x7FFFFFFF, min);

  const CatalogSlice.empty()
      : _pages = const [],
        startIndex = 0,
        hasNext = true;

  int get endIndex =>
      startIndex + _pages.map((page) => page.endIndex).fold(-1, max);

  Product elementAt(int index) {
    for (final page in _pages) {
      if (index >= page.startIndex && index <= page.endIndex) {
        return page.products[index - page.startIndex];
      }
    }
    return null;
  }
}
