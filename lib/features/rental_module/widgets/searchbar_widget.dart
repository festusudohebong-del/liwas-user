import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/controllers/theme_controller.dart';
import 'package:liwas_user/features/rental_module/rental_location_screen/taxi_location_suggestion_screen.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';


class SearchbarWidget extends StatelessWidget {
  const SearchbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
        color: Get.find<ThemeController>().darkTheme ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withValues(alpha: 0.1),
      ),
      height: 50,
      child: InkWell(
        onTap: ()=> Get.to(()=> const TaxiLocationSuggestionScreen()),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(
            child: Text('Where to go'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.7))),
          ),

          Image.asset(Images.searchIconNewHome, height: 25, width: 25,),
        ]),
      ),
    );
  }
}
