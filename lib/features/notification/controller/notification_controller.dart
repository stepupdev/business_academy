import 'package:business_application/features/notification/data/check_notification_model.dart';
import 'package:business_application/features/notification/data/notification_models.dart';
import 'package:business_application/repository/notification_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notificationLoading = <String, bool>{}.obs; // Track loading state for individual notifications

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

  markReadNotification(String id, BuildContext context) async {
    isLoading(true);
    try {
      var response = await NotificationRep().markNotification(id, context);
      print("Notification: $response");
      fetchNotifications(); // Refresh notifications after marking as read
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  markReadUnreadNotification(String id, BuildContext context) async {
    notificationLoading[id] = true; // Set loading for the specific notification
    notificationLoading.refresh(); // Notify listeners about the change

    try {
      var response = await NotificationRep().markReadUnreadNotification(id, context);
      print("Notification: $response");

      // Update the specific notification in the list
      var notificationIndex = notifications.value.result?.data?.indexWhere((n) => n.id.toString() == id);
      if (notificationIndex != null && notificationIndex >= 0) {
        notifications.value.result?.data?[notificationIndex].isRead =
            !(notifications.value.result?.data?[notificationIndex].isRead ?? false);
        notifications.refresh(); // Notify listeners about the change
        checkNotification();
      }
    } catch (e) {
      print(e);
    } finally {
      notificationLoading[id] = false; // Reset loading for the specific notification
      notificationLoading.refresh(); // Notify listeners about the change
    }
  }

  markAllReadNotification(BuildContext context) async {
    isLoading(true);
    try {
      var response = await NotificationRep().markAllNotification(context);
      print("Notification: $response");

      notifications.refresh();
      checkNotification();
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
