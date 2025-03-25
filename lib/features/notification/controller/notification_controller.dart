import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/notification/data/check_notification_model.dart';
import 'package:business_application/features/notification/data/notification_models.dart';
import 'package:business_application/repository/notification_rep.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;

  var notifications = NotificationResponseModel().obs;

  var notificationCheck = CheckNotificationResponseModel().obs;

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
    isLoading(true);
    try {
      var response = await NotificationRep().checkNotification();
      notificationCheck(CheckNotificationResponseModel.fromJson(response));
      return notificationCheck.value.result!.hasNotifications!;
    } catch (e) {
      print(e);
      return notificationCheck.value.result!.hasNotifications!;
    } finally {
      isLoading(false);
    }
  }

  markReadNotification(String id) async {
    isLoading(true);
    try {
      var response = await NotificationRep().markNotification(id);
      print("Notification: $response");
      Ui.successSnackBar(message: "Notification marked as read");
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
      Ui.successSnackBar(message: "All notifications marked as read");
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
