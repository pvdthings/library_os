import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/widgets/icons.dart';

class SuggestedThingsDialog extends ConsumerWidget {
  const SuggestedThingsDialog({
    super.key,
    required this.thingName,
    required this.thingIds,
  });

  final String thingName;
  final List<String> thingIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: const Icon(
        Icons.build,
        color: Colors.blue,
      ),
      title: const Text('Suggested Things'),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        width: 500,
        child: FutureBuilder(
            future: ref
                .read(thingsRepositoryProvider.notifier)
                .getCachedThingsById(thingIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              final things = snapshot.data
                      ?.map((t) => SuggestedThing(
                            name: t.name,
                            available: t.available > 0,
                          ))
                      .toList() ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(TextSpan(
                    children: [
                      TextSpan(
                        text: thingName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text: ' is often lent with the following things.'),
                    ],
                  )),
                  const SizedBox(height: 16),
                  ListView.builder(
                    itemCount: things.length,
                    itemBuilder: (context, index) {
                      final thing = things[index];
                      return ListTile(
                        leading:
                            thing.available ? checkedInIcon : checkedOutIcon,
                        title: Text(thing.name),
                        subtitle: thing.available
                            ? null
                            : const Text('None Available'),
                      );
                    },
                    shrinkWrap: true,
                  ),
                ],
              );
            }),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class SuggestedThing {
  const SuggestedThing({
    required this.name,
    required this.available,
  });

  final String name;
  final bool available;
}
