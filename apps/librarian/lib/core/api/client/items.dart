part of 'client.dart';

class LibraryOSItems {
  LibraryOSItemReference one({required int number}) {
    return LibraryOSItemReference(number: number);
  }
}

class LibraryOSItemReference {
  const LibraryOSItemReference({required this.number});

  final int number;

  Future<ItemModel?> details() async {
    try {
      final response = await fetchInventoryItem(number: number);
      return ItemModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }
}
