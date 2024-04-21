import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/core/file_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemManualsCard extends StatelessWidget {
  const ItemManualsCard({
    super.key,
    required this.manuals,
    this.onAdd,
    this.onRemove,
  });

  final List<ManualData> manuals;
  final void Function()? onAdd;
  final void Function(int index)? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Resources'),
            subtitle: const Text('Attach helpful PDFs for borrowers.'),
            trailing: IconButton.outlined(
              onPressed: () => onAdd?.call(),
              icon: const Icon(Icons.add),
              // label: const Text('Add resource'),
            ),
            visualDensity: VisualDensity.comfortable,
          ),
          const Divider(height: 1),
          if (manuals.isEmpty)
            const ListTile(
              title: Text('No resources attached'),
              dense: true,
            ),
          ...manuals.mapIndexed((i, manual) {
            final bytes = manual.data?.bytes;
            final url = bytes != null
                ? Uri.dataFromBytes(bytes, mimeType: manual.data!.type)
                : Uri.parse(manual.url!);

            return ListTile(
              title: Text(manual.name),
              trailing: IconButton(
                onPressed: () => onRemove?.call(i),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
              onTap: () async => await launchUrl(url),
            );
          }),
        ],
      ),
    );
  }
}

class ManualData {
  final String name;
  final FileData? data;
  final String? url;

  const ManualData({required this.name, this.data, this.url});

  factory ManualData.fromFile(FileData data) {
    return ManualData(name: data.name, data: data);
  }
}
