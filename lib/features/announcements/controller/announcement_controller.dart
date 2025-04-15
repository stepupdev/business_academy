import 'package:business_application/features/announcements/data/announcements_data.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  var isLoading = false.obs;
  var announcements = AnnouncementPostResponseModel().obs;

  Future<bool> fetchAnnouncements() async {
    isLoading.value = true;
    try {
      final response = await CommunityRep().fetchAnnouncements();
      if (response != null) {
        announcements.value = response;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
