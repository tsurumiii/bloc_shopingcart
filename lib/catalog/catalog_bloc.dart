import 'dart:math';
import 'package:flutter/widgets.dart';
import './catalog_slice.dart';
import '../services/catalog.dart';
import '../services/catalog_page.dart';
import 'package:rxdart/rxdart.dart';

class CatalogBloc {
  final PublishSubject<int> _indexController = PublishSubject<int>();

  final Map<int, CatalogPage> _pages = <int, CatalogPage>{};

  final Set<int> _pagesBeingRequested = Set<int>();

  final BehaviorSubject<CatalogSlice> _sliceSubject =
      BehaviorSubject<CatalogSlice>.seeded(CatalogSlice.empty());

  final CatalogService _catalogService;

  CatalogBloc(this._catalogService) {
    _indexController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);
  }

  Sink<int> get index => _indexController.sink;

  ValueObservable<CatalogSlice> get slice => _sliceSubject.stream;

  int _getPageStartFromIndex(int index) =>
      (index ~/ CatalogService.productsPerPage) *
      CatalogService.productsPerPage;

  void _handleIndexes(List<int> indexs) {
    const maxInt = 0x7fffffff;
    final int minIndex = indexs.fold(maxInt, min);
    final int maxIndex = indexs.fold(-1, max);

    final minPageIndex = _getPageStartFromIndex(minIndex);
    final maxPageIndex = _getPageStartFromIndex(maxIndex);

    for (int i = minPageIndex;
        i <= maxPageIndex;
        i += CatalogService.productsPerPage) {
      if (_pages.containsKey(i)) continue;
      if (_pagesBeingRequested.contains(i)) continue;
      _pagesBeingRequested.add(i);
      _catalogService.requestPage(i).then((page) => _handleNewPage(page, i));
    }

    _pages.removeWhere((pageIndex, _) =>
        pageIndex < minPageIndex - CatalogService.productsPerPage ||
        pageIndex > maxPageIndex + CatalogService.productsPerPage);
  }

  void _handleNewPage(CatalogPage page, int index) {
    _pages[index] = page;
    _pagesBeingRequested.remove(index);
    _sendNewSlice();
  }

  void _sendNewSlice() {
    final pages = _pages.values.toList(growable: false);
    final slice = CatalogSlice(pages, true);
    _sliceSubject.add(slice);
  }
}

class CatalogProvider extends InheritedWidget {
  final CatalogBloc catalogBloc;

  CatalogProvider({
    Key key,
    @required CatalogBloc catalog,
    Widget child,
  })  : assert(catalog != null),
        catalogBloc = catalog,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CatalogBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CatalogProvider) as CatalogProvider)
          .catalogBloc;
}
