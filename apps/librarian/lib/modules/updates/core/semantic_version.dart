class SemanticVersion {
  const SemanticVersion({
    required this.major,
    required this.minor,
    required this.patch,
    required this.build,
  });

  final int major;
  final int minor;
  final int patch;
  final int build;

  String get text => '$major.$minor.$patch+$build';

  bool isNewerThan(SemanticVersion other) {
    if (major > other.major) {
      return true;
    }

    if (major == other.major && minor > other.minor) {
      return true;
    }

    if (major == other.major && minor == other.minor && patch > other.patch) {
      return true;
    }

    if (major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        build > other.build) {
      return true;
    }

    return false;
  }

  bool isSameAs(SemanticVersion other) {
    return major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        build == other.build;
  }

  factory SemanticVersion.from(String stringValue, String buildString) {
    final segments = stringValue.split('.');
    final numSegments = segments.length;

    return SemanticVersion(
      major: numSegments > 0 ? int.parse(segments[0]) : 0,
      minor: numSegments > 1 ? int.parse(segments[1]) : 0,
      patch: numSegments > 2 ? int.parse(segments[2]) : 0,
      build: int.parse(buildString),
    );
  }
}
