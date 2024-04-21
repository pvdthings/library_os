# Librarian

## About

Librarian is the first app in **Library OS**. It is intended to be used by volunteers or employees of a lending library to record inventory, manage members, and check items in/out.

## Running the app

### Set environment variables

```
API_HOST (http://localhost:8088/lending)
API_KEY
APP_URL
SUPABASE_URL
SUPABASE_PUBLIC_KEY
```

Supabase variables are required for production environments, but not for local development.

### Launch in Chrome

```
flutter run -d chrome
```

For a better debugging experience, use the Flutter dev tools in Visual Studio Code.

## Project Structure

The repository is organized "feature-first," so things become more specific as you go down the folder hierarchy.

- `core` folders contain **Business Logic**.
- `data` folders contain **Repostories**.
- `models` contains **Models** or **ViewModels**.
- `providers` folders contain **Providers**, which maintain shared app state and notify widgets of changes.
- `widgets` folders contain **UI Widgets** (and controllers) that compose larger widgets or pages.
- `pages` folders contain UI widgets that represent pages. These are generally wrapped in a `Scaffold` widget.