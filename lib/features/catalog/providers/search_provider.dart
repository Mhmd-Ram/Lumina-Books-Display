import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../data/books_repository.dart';
import '../models/book.dart';

/// State for the Search tab. Kept separate from [BooksProvider] (which feeds the
/// Home sections) so a live search never disturbs the curated home catalog.
///
/// Two layers, matching the design: a **live API search** runs when the user
/// submits a query, and an **instant client-side filter** narrows the loaded
/// results as they type.
class SearchProvider extends ChangeNotifier {
  final BooksRepository _repo;
  SearchProvider(this._repo);

  /// Seed query so the screen shows a curated set before the user types.
  static const String _seedQuery = 'fantasy romance';

  List<Book> _results = [];
  bool _isLoading = false;
  String? _error;
  String _filter = '';
  bool _initialized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filter => _filter;

  /// Results after the client-side text filter is applied.
  List<Book> get results {
    if (_filter.isEmpty) return _results;
    final q = _filter.toLowerCase();
    return _results.where((b) {
      return b.title.toLowerCase().contains(q) ||
          b.authorsText.toLowerCase().contains(q) ||
          b.isbns.any((i) => i.toLowerCase().contains(q));
    }).toList();
  }

  /// Load the seed results once, the first time the tab is opened.
  void ensureLoaded() {
    if (_initialized) return;
    _initialized = true;
    _fetch(_seedQuery);
  }

  /// Instant client-side filter (called on every keystroke).
  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  /// Live API search (called when the user submits the query).
  Future<void> submit(String query) async {
    _filter = '';
    await _fetch(query.trim().isEmpty ? _seedQuery : query.trim());
  }

  Future<void> _fetch(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _results = await _repo.search(query);
    } on ApiException catch (e) {
      _error = e.message;
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
