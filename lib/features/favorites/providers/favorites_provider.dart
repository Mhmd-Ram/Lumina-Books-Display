import 'package:flutter/foundation.dart';

import '../../catalog/models/book.dart';

/// Global app state (the Provider requirement): the set of favorited books,
/// keyed by book id. In-memory only — see docs/05-favorites.md for the
/// persistence stretch goal.
class FavoritesProvider extends ChangeNotifier {
  final Map<String, Book> _items = {};

  int get count => _items.length;

  List<Book> get items => _items.values.toList(growable: false);

  bool isFavorite(String bookId) => _items.containsKey(bookId);

  void toggle(Book book) {
    if (_items.containsKey(book.id)) {
      _items.remove(book.id);
    } else {
      _items[book.id] = book;
    }
    notifyListeners();
  }
}
