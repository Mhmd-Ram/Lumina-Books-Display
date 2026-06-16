import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../models/book.dart';

class GoogleBooksService {
  final ApiClient _client;
  GoogleBooksService(this._client);

  Future<List<Book>> searchBooks(String query) async {
    final params = {
      'q': query.trim().isEmpty ? ApiConfig.defaultQuery : query.trim(),
      'maxResults': '${ApiConfig.maxResults}',
      'printType': 'books',
      if (ApiConfig.apiKey.isNotEmpty) 'key': ApiConfig.apiKey,
    };
    final uri = Uri.https(ApiConfig.host, ApiConfig.volumesPath, params);
    final data = await _client.getJson(uri);
    final items = (data['items'] as List?) ?? const [];
    return items.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
  }
}
