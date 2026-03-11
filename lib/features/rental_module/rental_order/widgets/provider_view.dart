import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/common/widgets/custom_ink_well.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/features/chat/domain/models/conversation_model.dart';
import 'package:liwas_user/features/notification/domain/models/notification_body_model.dart';
import 'package:liwas_user/features/rental_module/common/models/trip_details_model.dart';
import 'package:liwas_user/features/rental_module/vendor/screens/vendor_detail_screen.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
class ProviderView extends StatelessWidget {
  final Provider provider;
  final int tripId;
  const ProviderView({super.key, required this.provider, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: CustomInkWell(
        onTap: ()=> Get.to(()=> VendorDetailScreen(vendorId: provider.id)),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
        child: Row(spacing: Dimensions.paddingSizeSmall, children: [

          SizedBox(
            height: 60, width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImage(image: provider.logoFullUrl??''),
            ),
          ),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeExtraSmall, children: [

              Text('${provider.name}', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis,),

              Row(children: [
                const Icon(Icons.star, color: Colors.yellow, size: 18,),
                Text('${provider.avgRating}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                Text('(${provider.ratingCount}+)', style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
              ]),

              Text('${provider.totalVehicles} ${'Vehicles'.tr}', style: ralewayMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),

            ]),
          ),

          provider.chat! && AuthHelper.isLoggedIn() ? CustomInkWell(
            onTap: () async {
              await Get.toNamed(RouteHelper.getChatRoute(
                notificationBody: NotificationBodyModel(orderId: tripId, restaurantId: provider.id),
                user: User(id: provider.id, fName: provider.name, lName: '', imageFullUrl: provider.logoFullUrl),
              ));
            },
            child: Image.asset(Images.chatOrderDetails, height: 30, width: 30),
          ) : const SizedBox(),

          CustomInkWell(
            onTap: () async {
              if(await canLaunchUrlString('tel:${provider.phone}')) {
                launchUrlString('tel:${provider.phone}', mode: LaunchMode.externalApplication);
              }else {
                showCustomSnackBar('${'Can not launch'.tr} ${provider.phone}');
              }
              },
            child: Image.asset(Images.phoneOrderDetails, height: 30, width: 30),
          ),
        ]),
      ),
    );
  }
}
