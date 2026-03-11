import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/address/domain/models/address_model.dart';
import 'package:liwas_user/features/rental_module/common/models/trip_details_model.dart';
import 'package:liwas_user/features/rental_module/custom/custom_icon_layout.dart';
import 'package:liwas_user/features/rental_module/widgets/trip_from_to_card.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
class TripDetailsWidget extends StatelessWidget {
  final TripDetailsModel tripDetailsModel;
  const TripDetailsWidget({super.key, required this.tripDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text('Trip details'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

            const SizedBox(),
          ]),
        ),
        const SizedBox(height: 8),

        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
          child: TripFromToCard(
            fromAddress: AddressModel(address: tripDetailsModel.pickupLocation?.locationName, addressType: tripDetailsModel.pickupLocation?.locationType),
            toAddress: AddressModel(address: tripDetailsModel.destinationLocation?.locationName, addressType: tripDetailsModel.destinationLocation?.locationType),
          ),
        ),

        //pickup Now
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5), width: 0.5),
            ),
            child: Row(children: [

              const CustomIconLayout(height: 32, width: 32, icon: Icons.date_range_outlined),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    'Pick time'.tr,
                    style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    DateConverter.dateTimeStringToDateTime(tripDetailsModel.scheduleAt!),
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ]),
              ),

            ]),
          ),
        ),
        const SizedBox(height: 10),

        //Rent type
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5), width: 0.5),
            ),
            child: Row(children: [

              const CustomIconLayout(height: 32, width: 32, icon: Icons.hourglass_empty_outlined),
              const SizedBox(width: 16),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('Rent type'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: 5),

                  Text(tripDetailsModel.tripType == 'hourly' ? '${tripDetailsModel.tripType!.tr} (${tripDetailsModel.estimatedHours} ${'Hrs'.tr})' : tripDetailsModel.tripType!.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),),

                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 10),

      ]),
    );
  }
}
