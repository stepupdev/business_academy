import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Ui {
  static GetSnackBar successSnackBar({String title = 'Success', required String message}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge!.merge(const TextStyle(color: Colors.white))),
      messageText: Text(message, style: Get.textTheme.bodyLarge!.merge(const TextStyle(color: Colors.white))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle_outline, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 5),
    );
  }

  static GetSnackBar notificationSnackBar({String title = 'Notification', required String message}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      titleText: Text(title.tr, style: TextStyle(color: Colors.black)),
      messageText: Text(message, style: TextStyle(color: Colors.black)),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      borderColor: Get.theme.focusColor.withOpacity(0.1),
      icon: Icon(Icons.notifications_none, size: 32, color: Get.theme.hintColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  //
  static GetSnackBar errorSnackBar({String title = 'Something went wrong!', required String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      //titleText: Text(title.tr, style: Get.textTheme.titleLarge!.merge(const TextStyle(color: Colors.white))),
      messageText: Text(message.tr, style: const TextStyle(color: Colors.white, fontSize: 16)),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.dangerous_outlined, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  //
  static GetSnackBar authenticationErrorSnackBar({required String title, required String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge!.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message.tr, style: Get.textTheme.bodyLarge!.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: Icon(Icons.remove_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 5),
    );
  }

  static bool isDarkMode (BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }
  // static GetSnackBar defaultSnackBar({String title = 'Alert', required String message}) {
  //   Get.log("[$title] $message", isError: false);
  //   return GetSnackBar(
  //     titleText: Text(title.tr, style: Get.textTheme.titleLarge!.merge(TextStyle(color: Get.theme.hintColor))),
  //     messageText: Text(message, style: Get.textTheme.bodyLarge!.merge(TextStyle(color: Get.theme.focusColor))),
  //     snackPosition: SnackPosition.BOTTOM,
  //     margin: const EdgeInsets.all(20),
  //     backgroundColor: Get.theme.primaryColor,
  //     borderColor: Get.theme.focusColor.withOpacity(0.1),
  //     icon: Icon(Icons.warning_amber_rounded, size: 32, color: Get.theme.hintColor),
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  //     borderRadius: 8,
  //     duration: const Duration(seconds: 5),
  //   );
  // }
  //
  // static GetSnackBar notificationSnackBar({String title = 'Notification', required String message}) {
  //   Get.log("[$title] $message", isError: false);
  //   return GetSnackBar(
  //     titleText: Text(title.tr, style: Get.textTheme.titleLarge!.merge(const TextStyle(color: Colors.white))),
  //     messageText: Text(message, style: Get.textTheme.bodyLarge!.merge(const TextStyle(color: Colors.white))),
  //     snackPosition: SnackPosition.TOP,
  //     margin: const EdgeInsets.all(20),
  //     backgroundColor: Get.theme.primaryColor,
  //     borderColor: Get.theme.focusColor.withOpacity(0.1),
  //     icon: const Icon(Icons.notifications_none, size: 32, color: Colors.white),
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  //     borderRadius: 8,
  //     duration: const Duration(seconds: 5),
  //   );
  // }
  //
  // static BoxDecoration getBoxDecoration({
  //   Color? color,
  //   Color? shadowColor,
  //   double? radius,
  //   Border? border,
  //   Gradient? gradient,
  // }) {
  //   return BoxDecoration(
  //     color: color ?? Get.theme.primaryColor,
  //     borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
  //     boxShadow: [
  //       BoxShadow(color: shadowColor ?? Get.theme.primaryColor.withOpacity(0.3), blurRadius: 2, offset: const Offset(0, 2)),
  //     ],
  //     border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
  //     gradient: gradient,
  //   );
  // }
  //
  // static BoxDecoration getBoxDecorationImage(
  //     {Color? color, double? radius, bool? isLocal = false, Border? border, Gradient? gradient, String image = ''}) {
  //   return BoxDecoration(
  //     color: color ?? Get.theme.backgroundColor,
  //     borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
  //     boxShadow: [
  //       BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
  //     ],
  //     border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
  //     gradient: gradient,
  //     image: DecorationImage(
  //         image: CachedNetworkImageProvider(
  //           image,
  //         ),
  //         fit: BoxFit.cover),
  //   );
  // }
  //
  // static BoxFit getBoxFit(String boxFit) {
  //   switch (boxFit) {
  //     case 'cover':
  //       return BoxFit.cover;
  //     case 'fill':
  //       return BoxFit.fill;
  //     case 'contain':
  //       return BoxFit.contain;
  //     case 'fit_height':
  //       return BoxFit.fitHeight;
  //     case 'fit_width':
  //       return BoxFit.fitWidth;
  //     case 'none':
  //       return BoxFit.none;
  //     case 'scale_down':
  //       return BoxFit.scaleDown;
  //     default:
  //       return BoxFit.cover;
  //   }
  // }
  //
  // static AlignmentDirectional getAlignmentDirectional(String alignmentDirectional) {
  //   switch (alignmentDirectional) {
  //     case 'top_start':
  //       return AlignmentDirectional.topStart;
  //     case 'top_center':
  //       return AlignmentDirectional.topCenter;
  //     case 'top_end':
  //       return AlignmentDirectional.topEnd;
  //     case 'center_start':
  //       return AlignmentDirectional.centerStart;
  //     case 'center':
  //       return AlignmentDirectional.topCenter;
  //     case 'center_end':
  //       return AlignmentDirectional.centerEnd;
  //     case 'bottom_start':
  //       return AlignmentDirectional.bottomStart;
  //     case 'bottom_center':
  //       return AlignmentDirectional.bottomCenter;
  //     case 'bottom_end':
  //       return AlignmentDirectional.bottomEnd;
  //     default:
  //       return AlignmentDirectional.bottomEnd;
  //   }
  // }
  //
  // static CrossAxisAlignment getCrossAxisAlignment(String textPosition) {
  //   switch (textPosition) {
  //     case 'top_start':
  //       return CrossAxisAlignment.start;
  //     case 'top_center':
  //       return CrossAxisAlignment.center;
  //     case 'top_end':
  //       return CrossAxisAlignment.end;
  //     case 'center_start':
  //       return CrossAxisAlignment.center;
  //     case 'center':
  //       return CrossAxisAlignment.center;
  //     case 'center_end':
  //       return CrossAxisAlignment.center;
  //     case 'bottom_start':
  //       return CrossAxisAlignment.start;
  //     case 'bottom_center':
  //       return CrossAxisAlignment.center;
  //     case 'bottom_end':
  //       return CrossAxisAlignment.end;
  //     default:
  //       return CrossAxisAlignment.start;
  //   }
  // }
  //
  // static InkWell getIconButton(
  //     {String? svgSrc,
  //       Widget? icon,
  //       double? height,
  //       double? padding = 12,
  //       double? horipadding = 0.0,
  //       double? width,
  //       double? radius = 0.0,
  //       Color? color,
  //       Color? svgColor,
  //       text,
  //       VoidCallback? press}) {
  //   return InkWell(
  //     onTap: press,
  //     child: Container(
  //       padding: EdgeInsets.all(padding!),
  //       height: height,
  //       width: width,
  //       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius!)),
  //       child: svgSrc != null
  //           ? SvgPicture.asset(svgSrc, color: svgColor!)
  //           : Center(
  //         child: icon ??
  //             Center(
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: horipadding!),
  //                 child: Text(
  //                   text,
  //                   style: TextStyle(
  //                     color: Get.theme.textTheme.bodyText1!.color,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static SizedBox customButton(
  //     {String? text,
  //       VoidCallback? press,
  //       Color? color,
  //       double width = double.infinity,
  //       double height = 56,
  //       double radius = 20,
  //       double fontSize = 18.0,
  //       Color textColor = Colors.white}) {
  //   return SizedBox(
  //     width: width,
  //     height: height,
  //     child: TextButton(
  //       style: TextButton.styleFrom(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
  //         primary: Colors.white,
  //         backgroundColor: color,
  //       ),
  //       onPressed: press,
  //       child: Text(
  //         text!,
  //         style: TextStyle(
  //           fontSize: fontSize,
  //           color: textColor,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static InputDecoration getInputDecoration({String hintText = '', String? errorText, IconData? iconData, Widget? suffixIcon, Widget? suffix}) {
  //   return InputDecoration(
  //     hintText: hintText,
  //     hintStyle: Get.textTheme.bodyLarge,
  //     prefixIcon: iconData != null ? Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 14) : const SizedBox(),
  //     prefixIconConstraints: iconData != null ? const BoxConstraints.expand(width: 38, height: 38) : const BoxConstraints.expand(width: 0, height: 0),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     contentPadding: const EdgeInsets.all(0),
  //     border: const OutlineInputBorder(borderSide: BorderSide.none),
  //     focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
  //     enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
  //     suffixIcon: suffixIcon,
  //     suffix: suffix,
  //     errorText: errorText,
  //   );
  // }
  //
  // static Widget customSuffixIcon({svgIcon}) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(
  //       0,
  //       20,
  //       20,
  //       20,
  //     ),
  //     child: SvgPicture.asset(
  //       svgIcon,
  //       height: 18,
  //     ),
  //   );
  // }
  //
  // static Widget shimmerLoader({double? width = 200, double? height = 100, double? radius, Color? baseColor, Color? highlightColor}) {
  //   return Shimmer.fromColors(
  //     baseColor: baseColor ?? Get.theme.highlightColor,
  //     highlightColor: highlightColor ?? Get.theme.splashColor,
  //     child: Container(
  //         height: height, width: width, decoration: BoxDecoration(color: Get.theme.cardColor, borderRadius: BorderRadius.circular(radius ?? 8))),
  //   );
  // }
  //
  // static customLottieLoader() {
  //   return Container(
  //     child: const Center(
  //       child: Image(
  //         image: AssetImage(
  //           'assets/loading.gif',
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static customLoader() {
  //   return SpinKitCubeGrid(
  //     // itemBuilder: (BuildContext context, int index) {
  //     //   return DecoratedBox(
  //     //     decoration: BoxDecoration(
  //     //       borderRadius: BorderRadius.circular(50),
  //     //       color: index.isEven ? Get.theme.primaryColor : Colors.black87,
  //     //     ),
  //     //   );
  //     // },
  //     color: Get.theme.primaryColor,
  //   );
  // }
  //
  // static customDialogLoader() {
  //   return Get.dialog(SpinKitCubeGrid(
  //     // itemBuilder: (BuildContext context, int index) {
  //     //   return DecoratedBox(
  //     //     decoration: BoxDecoration(
  //     //       borderRadius: BorderRadius.circular(50),
  //     //       color: index.isEven ? Get.theme.primaryColor : Colors.black87,
  //     //     ),
  //     //   );
  //     // },
  //     color: Get.theme.primaryColor,
  //   ));
  // }
  //
  // static customDialogLoaderForMap() {
  //   return unawaited(
  //     Navigator.of(Get.context!, rootNavigator: true).push(
  //       PageRouteBuilder(
  //         pageBuilder: (_, __, ___) => WillPopScope(
  //           onWillPop: () async => false,
  //           child: Scaffold(
  //             backgroundColor: Colors.transparent,
  //             body: Center(child: customLoader()),
  //           ),
  //         ),
  //         transitionDuration: Duration.zero,
  //         barrierDismissible: false,
  //         barrierColor: Colors.black45,
  //         opaque: false,
  //       ),
  //     ),
  //   );
  // }
  //
  // static Widget customBottomLoader() {
  //   return SpinKitDoubleBounce(
  //     size: 30,
  //     // itemBuilder: (BuildContext context, int index) {
  //     //   return DecoratedBox(
  //     //     decoration: BoxDecoration(
  //     //       borderRadius: BorderRadius.circular(50),
  //     //       color: index.isEven ? Colors.blue.shade500 : Colors.black87,
  //     //     ),
  //     //   );
  //     // },
  //     color: Get.theme.primaryColor,
  //   );
  // }
  //
  // static showAwesomeDialog(String title, String description, Color? color, VoidCallback? onTap,
  //     {bool showClose = false, bool isBarrierDismiss = true, String type = 'info', String okay = 'Proceed'}) {
  //   return AwesomeDialog(
  //     context: Get.context!,
  //     dialogType: type == 'info' ? DialogType.INFO_REVERSED : DialogType.NO_HEADER,
  //     borderSide: BorderSide(
  //       color: Get.theme.primaryColor,
  //       width: 1,
  //     ),
  //     btnOkColor: color ?? Colors.yellow.shade500,
  //     width: Get.size.width,
  //     buttonsBorderRadius: const BorderRadius.all(
  //       Radius.circular(25),
  //     ),
  //     dismissOnTouchOutside: isBarrierDismiss,
  //     dismissOnBackKeyPress: false,
  //     headerAnimationLoop: false,
  //     animType: AnimType.BOTTOMSLIDE,
  //
  //     title: title,
  //     titleTextStyle: const TextStyle(
  //       fontSize: 18,
  //       color: AppColors.mainBlack,
  //       fontWeight: FontWeight.normal,
  //     ),
  //     desc: description,
  //     descTextStyle: const TextStyle(
  //       fontSize: 15,
  //       color: AppColors.mainBlack,
  //       fontWeight: FontWeight.normal,
  //     ),
  //     showCloseIcon: false,
  //
  //     btnCancel: Column(
  //       children: [
  //         BlockButtonWidget(
  //           color: Get.theme.primaryColor,
  //           onPressed: onTap,
  //           text: Text(
  //             okay,
  //             style: const TextStyle(
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: size.width * .03,
  //         ),
  //         showClose
  //             ? BlockButtonWidget(
  //           color: Colors.red,
  //           hasBorder: true,
  //           onPressed: () {
  //             Get.back();
  //           },
  //           text: const Text(
  //             'No, Close',
  //             style: TextStyle(
  //               color: Colors.white,
  //             ),
  //           ),
  //         )
  //             : Wrap(),
  //         SizedBox(
  //           height: size.width * .03,
  //         ),
  //       ],
  //     ),
  //
  //     // btnCancelOnPress: () {
  //     //   Get.back();
  //     // },
  //   ).show();
  // }
  //
  // static noDataFound({String title = 'No data found', String url = 'assets/noData.json'}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         height: size.width,
  //         width: size.width,
  //         child: Lottie.asset(url),
  //       ),
  //       Center(
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Get.theme.disabledColor,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
