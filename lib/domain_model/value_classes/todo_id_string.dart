class TodoIdString {
  static final _regexp = RegExp(
      "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}");
  final String value;
  TodoIdString(this.value) {
    if (!_regexp.hasMatch(value)) {
      throw ArgumentError("value is not a valid UUID", "value");
    }
  }

  @override
  String toString() {
    return value;
  }

  @override
  bool operator ==(Object other) {
    return other is TodoIdString &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }
  @override
  int get hashCode => Object.hash(runtimeType, value);
}
