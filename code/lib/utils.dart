class DateUtils {
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 12);
  }
}
