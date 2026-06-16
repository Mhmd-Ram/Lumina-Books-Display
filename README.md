# BooksAPI

A Flutter app that searches the [Open Library](https://openlibrary.org/developers/api) API and
displays books in a clean, scrollable list. Tap a book to open its details (cover, rating,
description, and metadata) and tap the heart to save it to your favorites.

The app only displays book information; it does not read or open books.

## What it does

- Search books by title or author (live API search plus instant client-side filtering)
- Browse a list of book cards showing cover, title, author, rating, and year
- View a details page with cover, rating, description, publisher, page count, language,
  categories, and ISBN
- Save favorites with a live count badge and a dedicated favorites screen
- Loading indicator, error view with retry, and pull-to-refresh

## Tech

- Flutter / Dart (SDK `^3.11.4`)
- `http` for networking
- `provider` for state management
- [Open Library](https://openlibrary.org/developers/api) API: free, no API key, no quota

## Run it

```bash
flutter pub get
flutter run            # pick a device, or: flutter run -d chrome
```

No API key is required.

A Google Books fallback is also included. To use it, supply a free key at run time
(never commit it):

```bash
flutter run --dart-define=BOOKS_API_KEY=<your_key>
```

## Project structure

```
lib/
  core/                 # shared: http client, theme, routing, shared widgets
  features/
    catalog/            # Book model, Open Library service, repository, provider
    home/               # list page, book card, search bar
    details/            # details page and widgets
    favorites/          # favorites provider, heart button, favorites page
```
