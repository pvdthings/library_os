# Librarian

## About

Librarian is the first app in **Library OS**. It is intended to be used by volunteers or employees of a lending library to record inventory, manage members, and check items in/out.

## Running the app

### Environment variables

```
SUPABASE_URL
SUPABASE_KEY
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
    "--dart-define", "SUPABASE_URL=value",
    "--dart-define", "SUPABASE_PUBLIC_KEY=value"
  ]
}
```

### Launch in Chrome

Use Visual Studio's `Run and Debug` feature to launch the app in Chrome.

## Project structure

The repository is (mostly) organized "feature-first," so things become more specific as you go down the folder hierarchy.
