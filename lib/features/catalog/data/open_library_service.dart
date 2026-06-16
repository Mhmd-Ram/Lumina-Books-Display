import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../models/book.dart';

class OpenLibraryService {
  final ApiClient _client;
  OpenLibraryService(this._client);

  static const _fields = 'key,title,subtitle,author_name,first_publish_year,'
      'cover_i,ratings_average,ratings_count,number_of_pages_median,language,'
      'subject,isbn,first_sentence,publisher';

  Future<List<Book>> searchBooks(String query) async {
    final q = query.trim().isEmpty ? ApiConfig.defaultQuery : query.trim();
    final uri = Uri.https(ApiConfig.openLibraryHost, ApiConfig.searchPath, {
      'q': q, 'limit': '${ApiConfig.maxResults}', 'fields': _fields,
    });
    final data = await _client.getJson(uri);
    final docs = (data['docs'] as List?) ?? const [];
    return docs
        .whereType<Map<String, dynamic>>()
        .map(Book.fromOpenLibrary)
        .where((b) => b.id.isNotEmpty)
        .toList();
  }

  /// Search returns only a first sentence; the full description is loaded
  /// lazily by the details page from the work endpoint.
  Future<String?> fetchDescription(String workId) async {
    if (workId.isEmpty) return null;
    final uri = Uri.https(ApiConfig.openLibraryHost, '/works/$workId.json');
    final data = await _client.getJson(uri);
    final d = data['description'];
    if (d is String) return Book.cleanText(d);
    if (d is Map && d['value'] is String) return Book.cleanText(d['value'] as String);
    return null;
  }
}
