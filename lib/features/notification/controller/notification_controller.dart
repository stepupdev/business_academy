import 'package:business_application/features/notification/data/check_notification_model.dart';
import 'package:business_application/features/notification/data/notification_models.dart';
import 'package:business_application/repository/notification_rep.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;

  var notifications = NotificationResponseModel().obs;
  var hasNewNotification = false.obs; // Separate flag for new notifications

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  fetchNotifications() async {
    isLoading(true);
    try {
      var response = await NotificationRep().getNotifications();
      notifications(NotificationResponseModel.fromJson(response));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<bool> checkNotification() async {
    try {
      var response = await NotificationRep().checkNotification();
      var checkResponse = CheckNotificationResponseModel.fromJson(response);

      // Update only the `hasNewNotification` flag
      hasNewNotification.value = checkResponse.result?.hasNotifications ?? false;

      return hasNewNotification.value;
    } catch (e) {
      print(e);
      return false;
    }
  }

  markReadNotification(String id) async {
    isLoading(true);
    try {
      var response = await NotificationRep().markNotification(id);
      print("Notification: $response");
      fetchNotifications(); // Refresh notifications after marking as read
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  markAllReadNotification() async {
    isLoading(true);
    try {
      var response = await NotificationRep().markAllNotification();
      print("Notification: $response");

      fetchNotifications(); // Refresh notifications after marking all as read
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
