part of 'client.dart';

class LibraryOS {
  static LibraryOSConnection connect({
    String? key,
    String? url,
  }) {
    /**
     * FIXME: Should NOT use static singleton.
     * Need to create DioClient factory to be called here.
     */
    return const LibraryOSConnection();
  }
}
