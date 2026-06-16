import 'package:booksapi/core/localization/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStrings.prettyCategory', () {
    test('rephrases awkward hyphenated/phrase subjects (overrides)', () {
      expect(AppStrings.prettyCategory('Man-woman relationships'), 'Relationships');
      expect(AppStrings.prettyCategory('self-help'), 'Self Help');
      expect(AppStrings.prettyCategory('Juvenile fiction'), 'Juvenile');
    });

    test('cleans hyphens and caps at two title-cased words', () {
      expect(AppStrings.prettyCategory('time-travel'), 'Time Travel');
      expect(AppStrings.prettyCategory('FICTION'), 'Fiction');
      expect(
        AppStrings.prettyCategory('Detective and mystery stories'),
        'Detective Mystery',
      );
    });

    test('leaves clean one/two-word categories unchanged', () {
      expect(AppStrings.prettyCategory('Fantasy'), 'Fantasy');
      expect(AppStrings.prettyCategory('Young Adult'), 'Young Adult');
      expect(AppStrings.prettyCategory('Dark Academia'), 'Dark Academia');
    });

    test('every result is at most two words', () {
      const messy = [
        'Fiction / Romance / General',
        'Bildungsromans',
        'Large type books',
        'Domestic fiction, American',
      ];
      for (final raw in messy) {
        expect(AppStrings.prettyCategory(raw).split(' ').length, lessThanOrEqualTo(2));
      }
    });
  });
}
