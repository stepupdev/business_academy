import 'package:business_application/features/community/data/community_model.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController{
  @override
  void onInit() {
    Get.find<AuthService>().getCurrentUser();
    super.onInit();

  }
    static const imageLink =
      'https://s3-alpha-sig.figma.com/img/f8a3/11ee/624d5c6c6457029c05e89e81ac6882ab?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hScOEIqEn5wtub6NMJ849GdedyxVifSWD6fHLLn3qrc2E0eDGI7p~onPifLf0OAu29CzZTAYLhj4E8LDFs~koGpLUjNuqqsX4KJEpYFzSTL19RPR479kqW~i4SjjGuSviyb-I-6lQPC2imp7wZjtaobMqDT55ZO-eZaqb67d0qRBhR19vtIKgBRxkks3sSyNguPn3ZYCdUUa5VgUcyhGB2TDiei5~9zO211VLyEKu5uy5~~5-zpXPCdxuLUs0o8VFy65DTgbGfl1oB1r5snWHbPr~c4a32iSA9QvBWTzOf25b~jQnYrGddqxolA1z62I-3ueLavcGkacHO26W8GZjQ__';
  var communities =
      <Community>[
        Community(id: '1', name: 'Tech Enthusiasts', newPosts: 5, totalMembers: 120, imageUrl: imageLink),
        Community(id: '2', name: 'Fitness Freaks', newPosts: 2, totalMembers: 80, imageUrl: imageLink),
        Community(id: '3', name: 'Book Lovers', newPosts: 10, totalMembers: 200, imageUrl: imageLink),
      ].obs;

  var selectedCommunityId = '1'.obs;

  void changeCommunity(String communityId) {
    selectedCommunityId.value = communityId;
  }
  }