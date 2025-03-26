import 'package:timeago/timeago.dart' as timeago;

class HelperUtils {
   static String formatTime(DateTime time) {
    final dateTime = DateTime.now().subtract(DateTime.now().difference(time));
    return timeago.format(dateTime, locale: 'en');
  }
}