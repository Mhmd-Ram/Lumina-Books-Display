import '../models/book.dart';
import 'open_library_service.dart';

class BooksRepository {
  final OpenLibraryService _service;          // swap to GoogleBooksService to use the fallback
  BooksRepository(this._service);
  Future<List<Book>> search(String query) => _service.searchBooks(query);
  Future<String?> fetchDescription(String workId) => _service.fetchDescription(workId);
}
