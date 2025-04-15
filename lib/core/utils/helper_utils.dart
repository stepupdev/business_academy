import 'package:timeago/timeago.dart' as timeago;

class HelperUtils {
  static String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inHours < 24) {
      return "Recently";
    } else {
      return timeago.format(time, locale: 'en');
    }
  }
}
