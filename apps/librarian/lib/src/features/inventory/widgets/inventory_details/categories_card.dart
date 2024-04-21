import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/widgets/details_card/card_body.dart';
import 'package:librarian_app/src/widgets/details_card/card_header.dart';
import 'package:librarian_app/src/widgets/details_card/details_card.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

import '../../providers/thing_details_provider.dart';

class CategoriesCard extends ConsumerWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(thingDetailsProvider),
      builder: (context, snapshot) {
        final List<String> categories =
            snapshot.connectionState == ConnectionState.waiting
                ? []
                : ref.watch(categoriesProvider) ?? snapshot.data!.categories;

        return DetailsCard(
          header: CardHeader(
            title: 'Categories',
            trailing: TextButton.icon(
              onPressed: () async {
                final category = await showDialog<String?>(
                  context: context,
                  builder: (context) => _CategoriesDialog(
                    existingCategories: categories.toSet(),
                  ),
                );

                if (category == null) {
                  return;
                }

                ref.read(categoriesProvider.notifier).state = [
                  ...categories,
                  category
                ];
              },
              icon: const Icon(Icons.add),
              label: const Text('Add category'),
            ),
          ),
          showDivider: categories.isNotEmpty,
          body: categories.isNotEmpty
              ? CardBody(
                  child: Row(
                    children: categories.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(c),
                          onDeleted: () {
                            ref.read(categoriesProvider.notifier).state =
                                categories.where((cat) => cat != c).toList();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _CategoriesDialog extends ConsumerWidget {
  const _CategoriesDialog({required this.existingCategories});

  final Set<String> existingCategories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder(
                future:
                    ref.read(thingsRepositoryProvider.notifier).getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<String> categories = snapshot.data!
                      .where((c) => !existingCategories.contains(c))
                      .toList();

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index]),
                        onTap: () =>
                            Navigator.of(context).pop(categories[index]),
                      );
                    },
                    controller: ScrollController(),
                    shrinkWrap: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
