import 'package:flutter/foundation.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../data/books_repository.dart';
import '../models/book.dart';

class BooksProvider extends ChangeNotifier {
  final BooksRepository _repo;
  BooksProvider(this._repo);

  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;
  String _query = ApiConfig.defaultQuery;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;

  Future<void> search(String query) async {
    _query = query;
    _isLoading = true; _error = null; notifyListeners();
    try {
      _books = await _repo.search(query);
    } on ApiException catch (e) {
      _error = e.message; _books = [];
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> refresh() => search(_query);   // used by pull-to-refresh
}
