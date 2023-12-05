class MyDateUtils {
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 12);
  }
}

extension E on DateTime {
  String toFormatString() {
    return "$day.$month.$year";
  }
}
