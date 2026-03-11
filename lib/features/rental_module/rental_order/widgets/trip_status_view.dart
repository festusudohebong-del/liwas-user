import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/rental_module/common/enums/trip_status_enum.dart';
import 'package:liwas_user/features/rental_module/common/models/trip_details_model.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
class TripStatusView extends StatelessWidget {
  final TripDetailsModel tripDetailsModel;
  const TripStatusView({super.key, required this.tripDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Column(spacing: tripDetailsModel.tripStatus == TripStatusEnum.canceled.name ? 0 : Dimensions.paddingSizeLarge, children: [
      const SizedBox(),

      tripDetailsModel.tripStatus == TripStatusEnum.pending.name || tripDetailsModel.tripStatus == TripStatusEnum.confirmed.name
          || tripDetailsModel.tripStatus == TripStatusEnum.ongoing.name ?
      Image.asset(Images.taxiPending, height: 80) : const SizedBox(),

      tripDetailsModel.tripStatus == TripStatusEnum.pending.name ? RichText(textAlign: TextAlign.center, text: TextSpan(children: <TextSpan>[

        TextSpan(text: 'Your booking is'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),

        TextSpan(text: ' ${'Pending'.tr},\n', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),

        TextSpan(text: 'Please wait for vendor confirmation'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor))

      ])) : tripDetailsModel.tripStatus == TripStatusEnum.confirmed.name ? RichText(textAlign: TextAlign.center, text: TextSpan(children: <TextSpan>[

        TextSpan(text: 'Your booking is'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),

        TextSpan(text: ' ${'Confirmed'.tr},\n', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),

        TextSpan(text: 'Driver will arrive soon to the pickup location'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor))

      ])) : tripDetailsModel.tripStatus == TripStatusEnum.ongoing.name ? Column(spacing: Dimensions.paddingSizeSmall, children: [
        RichText(textAlign: TextAlign.center, text: TextSpan(children: <TextSpan>[

          TextSpan(text: 'Your trip is'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),

          TextSpan(text: ' ${'Ongoing'.tr},\n', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),

          TextSpan(text: 'You will be reached your destination approximately'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor))

        ])),
        // Text('You will be reached your destination approximately'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.grey.shade500), textAlign: TextAlign.center,),

        Text(
          tripDetailsModel.tripType == 'hourly' ?
          DateConverter.durationFromNow(tripDetailsModel.estimatedTripEndTime!) < 20
              ? DateConverter.durationFromNow(tripDetailsModel.estimatedTripEndTime!) > 0
              ? '${DateConverter.durationFromNow(tripDetailsModel.estimatedTripEndTime!) - 5} - ${DateConverter.durationFromNow(tripDetailsModel.estimatedTripEndTime!)}'
              : '1 - 5 ${'Min'.tr}'
              : DateConverter.dateTimeStringToDateTime(tripDetailsModel.estimatedTripEndTime!)
          : DateConverter.dateTimeStringToDateTime(tripDetailsModel.estimatedTripEndTime!),
          style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),

      ]) : (tripDetailsModel.tripStatus == TripStatusEnum.completed.name && tripDetailsModel.paymentStatus != 'paid') ? Column(children: [

        RichText(textAlign: TextAlign.center, text: TextSpan(children: <TextSpan>[
          TextSpan(text: 'Your trip has been'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5))),
          TextSpan(text: ' ${'Completed'.tr}', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
        ])),

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
          child: Text('Total trip cost'.tr,
            style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ),

        Text(PriceConverter.convertPrice(tripDetailsModel.tripAmount), style: ralewayBold.copyWith(fontSize: 26, color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),

        Container(
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
          child: Text(
            '${DateConverter.dateTimeStringToDateTime(tripDetailsModel.scheduleAt!)} - ${DateConverter.dateTimeStringToDateTime(tripDetailsModel.completed!)}',
            style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
          ),
        ),

        tripDetailsModel.tripType == 'hourly' ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Icon(Icons.hourglass_empty_outlined, size: Dimensions.fontSizeExtraLarge, color: Colors.grey.shade600),

          Text('Total hour'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6))),

          Text(' - ${tripDetailsModel.estimatedHours}', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black))

        ]) : tripDetailsModel.tripType == 'day_wise' ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Icon(Icons.calendar_view_day, size: Dimensions.fontSizeExtraLarge, color: Colors.grey.shade600),

          Text('Total'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6))),

          Text(' - ${((tripDetailsModel.estimatedHours ?? 0) / 24).toStringAsFixed(0)} ${'Day'.tr}', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black))

        ]) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Icon(Icons.social_distance, size: Dimensions.fontSizeExtraLarge, color: Colors.grey.shade600),

          Text('Total distance'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.grey.shade600)),

          Text(' - ${tripDetailsModel.distance?.toStringAsFixed(2)} ${'Km'.tr}', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black))

        ]),
      ]) : tripDetailsModel.tripStatus == TripStatusEnum.completed.name && tripDetailsModel.paymentStatus == 'paid' ?  Column(children: [
        Image.asset(Images.taxiCompletedGif, height: 150),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RichText(textAlign: TextAlign.center, text: TextSpan(children: <TextSpan>[
          TextSpan(text: 'Your payment'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5))),
          TextSpan(text: ' ${'Completed successfully'.tr}', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
        ])),
      ]) : const SizedBox(),

    ]);
  }
}
