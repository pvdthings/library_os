# Librarian

## About

Librarian is the first app in **Library OS**. It is intended to be used by volunteers or employees of a lending library to record inventory, manage members, and check items in/out.

## Running the app

### Environment variables

```
API_HOST (http://localhost:8088/lending)
API_KEY

SUPABASE_URL
SUPABASE_PUBLIC_KEY
```

Environment variables are passed in when running the app.

```
flutter run -d chrome --dart-define VAR=value
```

To simplify configuration during development, it's recommeneded to use Visual Studio Code and create a `launch.json` file at the root of the `library_os` folder.

Your configuration will look something like this:

```json
{
  "name": "librarian",
  "cwd": "apps/librarian",
  "request": "launch",
  "type": "dart",
  "args": [
    "--dart-define", "API_KEY=value",
    "--dart-define", "API_HOST=http://localhost:8088/lending",
    "--dart-define", "SUPABASE_URL=value",
    "--dart-define", "SUPABASE_PUBLIC_KEY=value"
  ]
}
```

### Launch in Chrome

Use Visual Studio's `Run and Debug` feature to launch the app in Chrome.

## Project Structure

The repository is (mostly) organized "feature-first," so things become more specific as you go down the folder hierarchy.

- `core` folders contain **Business Logic**.
- `data` folders contain **Repostories**.
- `models` contains **Models** or **ViewModels**.
- `providers` folders contain **Providers**, which maintain shared app state and notify widgets of changes.
- `widgets` folders contain **UI Widgets** (and controllers) that compose larger widgets or pages.
- `pages` folders contain UI widgets that represent pages. These are generally wrapped in a `Scaffold` widget.