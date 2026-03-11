import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/home/widgets/components/review_item_card_widget.dart';
import 'package:liwas_user/features/home/widgets/web/widgets/sorting_text_button.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class BestReviewedProductView extends StatelessWidget {
  const BestReviewedProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Best reviewed products'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [
              SortingTextButton(
                title: 'All'.tr,
                onTap: () {},
              ),

              SortingTextButton(
                title: 'Beauty'.tr,
                onTap: () {},
              ),

              SortingTextButton(
                title: 'Men fashion'.tr,
                onTap: () {},
              ),

              SortingTextButton(
                title: 'Women fashion'.tr,
                onTap: () {},
              ),

              SortingTextButton(
                title: 'Electronics'.tr,
                onTap: () {},
              ),

            ]),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
            ),
            child: SizedBox(
              height: 280, width: Get.width,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                    child: const ReviewItemCard(),
                  );
                },
              ),
            ),
          ),
        ),

      ]),
    );
  }
}




