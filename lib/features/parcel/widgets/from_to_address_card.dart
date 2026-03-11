import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/address/domain/models/address_model.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/rental_module/custom/custom_icon_layout.dart';
import 'package:liwas_user/features/rental_module/custom/custom_vertical_dotted_line.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';

class TripFromToCard extends StatelessWidget {
  final AddressModel? pickUpAddress;
  final AddressModel? destinationAddress;
  const TripFromToCard({super.key, this.pickUpAddress, this.destinationAddress,});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text('Address information'.tr, style: ralewaySemiBold),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      Row(children: [
        Padding(
          padding: EdgeInsets.only(right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeSmall : 0 , left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
          child: const CustomIconLayout(height: 20, width: 20, iconImage: Images.gpsIcon),
        ),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              pickUpAddress?.address??'', maxLines: 2, overflow: TextOverflow.ellipsis,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault-1),
            ),
            Wrap(children: [
              (pickUpAddress!.streetNumber != null && pickUpAddress!.streetNumber!.isNotEmpty) ? Text('${'Street number'.tr}: ${pickUpAddress!.streetNumber!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (pickUpAddress!.house != null && pickUpAddress?.house != 'null' && pickUpAddress!.house!.isNotEmpty) ? Text('${'House'.tr}: ${pickUpAddress!.house!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (pickUpAddress!.floor != null && pickUpAddress!.floor!.isNotEmpty) ? Text('${'Floor'.tr}: ${pickUpAddress!.floor!}',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),
            ]),
          ]),
        ),
      ]),

      Padding(
        padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault),
        child: const CustomVerticalDottedLine(),
      ),

      Row(children: [

        Padding(
          padding: EdgeInsets.only(right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeSmall : 0 , left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
          child: const CustomIconLayout(height: 20, width: 20, iconImage: Images.directUpIcon, paddingSize: 5),
        ),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              destinationAddress?.address??'', maxLines: 2, overflow: TextOverflow.ellipsis,
              style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault - 1),
            ),
            Wrap(children: [
              (destinationAddress!.streetNumber != null && destinationAddress!.streetNumber!.isNotEmpty) ? Text('${'Street number'.tr}: ${destinationAddress!.streetNumber!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (destinationAddress!.house != null && destinationAddress?.house != 'null' && destinationAddress!.house!.isNotEmpty) ? Text('${'House'.tr}: ${destinationAddress!.house!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (destinationAddress!.floor != null && destinationAddress!.floor!.isNotEmpty) ? Text('${'Floor'.tr}: ${destinationAddress!.floor!}',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),
            ]),

          ]),
        ),

        // Expanded(
        //     child: Text(toAddress.address??'', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
        // ),
      ]),

    ]);
  }
}
