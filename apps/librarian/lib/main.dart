import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/modules/splash/pages/splash_page.dart';
import 'package:librarian_app/core/services/image_service.dart';
import 'package:librarian_app/theme/indigo_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublicKey,
  );

  if (supabaseUrl.isNotEmpty) {
    Library.logoUrl = ImageService().getPublicUrl('library', 'settings/logo');
  }

  runApp(const riverpod.ProviderScope(
    child: LibrarianApp(),
  ));
}

class LibrarianApp extends StatelessWidget {
  const LibrarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librarian',
      debugShowCheckedModeBanner: false,
      theme: indigoTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const LibraryExplorerPage(),
      },
    );
  }
}

class LibraryExplorerPage extends StatelessWidget {
  const LibraryExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          LibraryExplorerBreadcrumbs(),
          SizedBox(height: 16.0),
          Expanded(child: LibraryExplorer()),
        ],
      ),
    );
  }
}

class LibraryExplorerBreadcrumbs extends StatelessWidget {
  const LibraryExplorerBreadcrumbs({super.key});

  final List<String> path = const ['Categories', 'DIY', 'Power Tools'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: path.mapIndexed((i, segment) {
        final text = TextButton(onPressed: () {}, child: Text(segment));

        if (i == path.length - 1) {
          return text;
        }

        return Row(
          children: [
            text,
            const SizedBox(width: 4.0),
            const Text('/'),
            const SizedBox(width: 4.0),
          ],
        );
      }).toList(),
    );
  }
}

abstract class ExplorerEntity {
  abstract final String name;
}

class CategoryEntity implements ExplorerEntity {
  CategoryEntity({required this.name, required this.children});

  @override
  final String name;

  final Map<String, ExplorerEntity> children;
}

class ThingEntity implements ExplorerEntity {
  ThingEntity({required this.name});

  @override
  final String name;
}

class LibraryExplorer extends StatefulWidget {
  const LibraryExplorer({super.key});

  @override
  State<LibraryExplorer> createState() => _LibraryExplorerState();
}

class _LibraryExplorerState extends State<LibraryExplorer> {
  final Map<String, ExplorerEntity> data = {
    'books': CategoryEntity(name: 'Books', children: {}),
    'diy': CategoryEntity(
      name: 'DIY',
      children: {
        'powerTools': CategoryEntity(
          name: 'Power Tools',
          children: {
            'id': ThingEntity(name: 'Drill, 20V Cordless'),
          },
        ),
      },
    ),
    'games': CategoryEntity(name: 'Games', children: {}),
  };

  List<String> path = [];

  Map<String, ExplorerEntity> get directory {
    Map<String, ExplorerEntity> workingDirectory = data;

    if (path.isEmpty) {
      return workingDirectory;
    }

    for (String key in path) {
      workingDirectory = (workingDirectory[key]! as CategoryEntity).children;
    }

    return workingDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 8,
      children: directory.entries.map((entry) {
        final card = Card.outlined(
          child: Column(
            children: [
              Text(entry.value.name),
              if (entry.value is CategoryEntity)
                Text('${(entry.value as CategoryEntity).children.length} items')
            ],
          ),
        );

        if (entry.value is ThingEntity) {
          return card;
        }

        return InkWell(
          onTap: () => setState(() {
            path.add(entry.key);
          }),
          child: card,
        );
      }).toList(),
    );
  }
}
