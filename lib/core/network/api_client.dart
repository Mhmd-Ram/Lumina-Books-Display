import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Thin wrapper around [http.Client]: performs a GET, decodes the JSON body, and
/// converts every possible failure into an [ApiException]. Kept web-safe by not
/// importing `dart:io` (so `flutter run -d chrome` also works).
class ApiClient {
  final http.Client _client;

  ApiClient([http.Client? client]) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getJson(Uri uri) async {
    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      if (response.statusCode == 429) {
        // Too many requests in a short window. Open Library is key-less, so the
        // fix is simply to wait a moment and retry. (If the optional Google
        // Books fallback is wired in, a real key via --dart-define=BOOKS_API_KEY
        // raises its quota.)
        throw const ApiException(
          'Too many requests right now. Please wait a moment and try again.',
          statusCode: 429,
        );
      }
      throw ApiException(
        'Request failed (${response.statusCode}). Please try again.',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on FormatException {
      throw const ApiException('Unexpected response from the server.');
    } on http.ClientException {
      throw const ApiException('Network error. Please check your connection.');
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }

  void dispose() => _client.close();
}
