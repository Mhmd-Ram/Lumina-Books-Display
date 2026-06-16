import 'package:booksapi/features/catalog/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Book JSON parsing', () {
    test('fromJson (Google Books) parses full JSON safely', () {
      final json = {
        'id': 'test-id',
        'volumeInfo': {
          'title': 'Test Title',
          'subtitle': 'Test Subtitle',
          'authors': ['Author One', 'Author Two'],
          'publisher': 'Test Publisher',
          'publishedDate': '2023-01-01',
          'description': '<p>A test <b>description</b></p>',
          'pageCount': 100,
          'categories': ['Fiction', 'Adventure'],
          'averageRating': 4.5,
          'ratingsCount': 10,
          'maturityRating': 'NOT_MATURE',
          'language': 'en',
          'imageLinks': {
            'thumbnail': 'http://example.com/cover.jpg',
          },
          'industryIdentifiers': [
            {'type': 'ISBN_13', 'identifier': '1234567890123'}
          ],
          'infoLink': 'http://example.com/info'
        }
      };

      final book = Book.fromJson(json);

      expect(book.id, 'test-id');
      expect(book.title, 'Test Title');
      expect(book.subtitle, 'Test Subtitle');
      expect(book.authors, ['Author One', 'Author Two']);
      expect(book.publisher, 'Test Publisher');
      expect(book.publishedDate, '2023-01-01');
      expect(book.description, 'A test description');
      expect(book.pageCount, 100);
      expect(book.categories, ['Fiction', 'Adventure']);
      expect(book.averageRating, 4.5);
      expect(book.ratingsCount, 10);
      expect(book.maturityRating, 'NOT_MATURE');
      expect(book.language, 'en');
      expect(book.thumbnail, 'https://example.com/cover.jpg');
      expect(book.isbns, ['ISBN_13: 1234567890123']);
      expect(book.infoLink, 'http://example.com/info');
    });

    test('fromJson (Google Books) parses sparse JSON safely', () {
      final json = <String, dynamic>{};
      final book = Book.fromJson(json);

      expect(book.id, '');
      expect(book.title, 'Untitled');
      expect(book.authors, isEmpty);
      expect(book.categories, isEmpty);
      expect(book.isbns, isEmpty);
      expect(book.thumbnail, isNull);
    });

    test('fromOpenLibrary parses full JSON safely', () {
      final json = {
        'key': '/works/OL12345W',
        'title': 'Test Title',
        'subtitle': 'Test Subtitle',
        'author_name': ['Author One', 'Author Two'],
        'first_publish_year': 2023,
        'cover_i': 12345,
        'ratings_average': 4.5,
        'ratings_count': 10,
        'number_of_pages_median': 100,
        'language': ['eng'],
        'subject': ['Fiction', 'Adventure'],
        'isbn': ['1234567890123'],
        'first_sentence': 'A test description',
        'publisher': ['Test Publisher']
      };

      final book = Book.fromOpenLibrary(json);

      expect(book.id, 'OL12345W');
      expect(book.title, 'Test Title');
      expect(book.subtitle, 'Test Subtitle');
      expect(book.authors, ['Author One', 'Author Two']);
      expect(book.publisher, 'Test Publisher');
      expect(book.publishedDate, '2023');
      expect(book.description, 'A test description');
      expect(book.pageCount, 100);
      expect(book.categories, ['Fiction', 'Adventure']);
      expect(book.averageRating, 4.5);
      expect(book.ratingsCount, 10);
      expect(book.language, 'eng');
      expect(book.thumbnail, 'https://covers.openlibrary.org/b/id/12345-M.jpg');
      expect(book.isbns, ['1234567890123']);
      expect(book.infoLink, 'https://openlibrary.org/works/OL12345W');
    });

    test('fromOpenLibrary parses sparse JSON safely', () {
      final json = <String, dynamic>{};
      final book = Book.fromOpenLibrary(json);

      expect(book.id, '');
      expect(book.title, 'Untitled');
      expect(book.authors, isEmpty);
      expect(book.categories, isEmpty);
      expect(book.isbns, isEmpty);
      expect(book.thumbnail, isNull);
      expect(book.infoLink, isNull);
    });

    test('cleanText strips HTML and trims', () {
      expect(Book.cleanText('<p>Hello&nbsp;<b>World</b>!</p>  '), 'Hello World!');
      expect(Book.cleanText(null), isNull);
    });
  });
}
