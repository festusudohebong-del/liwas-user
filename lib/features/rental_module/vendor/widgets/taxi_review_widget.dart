import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/common/widgets/readmore_widget.dart';
import 'package:liwas_user/features/rental_module/vendor/domain/models/taxi_provider_review_model.dart';
import 'package:liwas_user/features/rental_module/vendor/widgets/taxi_rating_bar.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiReviewWidget extends StatelessWidget {
  final Reviews? review;
  final bool hasDivider;
  final String? storeName;
  const TaxiReviewWidget({super.key, this.review, required this.hasDivider, this.storeName});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(review!.customerName ?? '', style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              TaxiRatingBar(rating: review?.rating?.toDouble() ?? 0, ratingCount: null, size: 15),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(DateConverter.stringToLocalDateOnly(review!.createdAt!), style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

            ]),
          ),

          Container(
            width: 140,
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Row(children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImage(
                  image: review?.vehicleImageFullUrl ?? '',
                  height: 40, width: 40, fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Expanded(
                child: Text(
                  review?.vehicleName ?? '',
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,
                ),
              )

            ]),
          ),

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        ReadMoreText(
          review!.comment ?? '',
          style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.grey),
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: Theme.of(context).primaryColor,
          lessStyle: ralewayBold.copyWith(color: Theme.of(context).primaryColor),
          trimCollapsedText: 'Show more'.tr,
          trimExpandedText: ' ${'Show less'.tr}',
          moreStyle: ralewayBold.copyWith(color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: review!.reply != null ? Dimensions.paddingSizeSmall : 0),

        review!.reply != null ? Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.only(left: 50, bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), border: Border.all(color: Colors.grey.shade200, width: 1)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Text(storeName ?? '', style: ralewayMedium),

              Text(DateConverter.stringToLocalDateOnly(review!.updatedAt!), style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            ReadMoreText(
              review!.reply ?? '',
              style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7)),
              trimMode: TrimMode.Line,
              trimLines: 3,
              colorClickableText: Theme.of(context).primaryColor,
              lessStyle: ralewayBold.copyWith(color: Theme.of(context).primaryColor),
              trimCollapsedText: 'Show more'.tr,
              trimExpandedText: ' ${'Show less'.tr}',
              moreStyle: ralewayBold.copyWith(color: Theme.of(context).primaryColor),
            ),

          ]),
        ) : const SizedBox(),

        hasDivider ? Divider(
          height: 40, thickness: 1,
          color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
        ) : const SizedBox(),

      ]),
    );
  }
}
