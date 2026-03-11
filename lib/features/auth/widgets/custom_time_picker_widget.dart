import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/auth/controllers/store_registration_controller.dart';
import 'package:liwas_user/features/auth/widgets/min_max_time_picker_widget.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';

class CustomTimePickerWidget extends StatelessWidget {
  const CustomTimePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> time = [];
    for(int i = 1; i <= 60 ; i++){
      time.add(i.toString());
    }
    List<String> unit = ['minute', 'hours', 'days'];

    StoreRegistrationController storeRegController = Get.find<StoreRegistrationController>();

    bool isRental = storeRegController.moduleList != null && storeRegController.selectedModuleIndex != -1 &&
        storeRegController.moduleList![storeRegController.selectedModuleIndex!].moduleType == AppConstants.taxi;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: GetBuilder<StoreRegistrationController>(
          builder: (storeRegController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isRental ? 'Estimated pickup time time'.tr : 'Estimated delivery time'.tr , style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(
                    'This item will be shown in the user app website'.tr,
                    style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      'Minimum'.tr,
                      style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(),

                  SizedBox(
                    width: 70,
                    child: Text(
                      'Maximum'.tr,
                      style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Text(
                      'unit'.tr,
                      style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                  MinMaxTimePickerWidget(
                    times: time, onChanged: (int index)=> storeRegController.minTimeChange(time[index]),
                    initialPosition: 10,
                  ),

                  Text(':', style: ralewayBold),

                  MinMaxTimePickerWidget(
                    times: time, onChanged: (int index)=> storeRegController.maxTimeChange(time[index]),
                    initialPosition: 10,
                  ),

                  MinMaxTimePickerWidget(
                    times: unit, onChanged: (int index) => storeRegController.timeUnitChange(unit[index]),
                    initialPosition: 1,
                  ),

                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                  child: Text(
                    '${storeRegController.storeMinTime} - ${storeRegController.storeMaxTime} ${storeRegController.storeTimeUnit}',
                    style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),

                CustomButton(
                  width: 200,
                  buttonText: 'Save'.tr,
                  onPressed: (){
                    int? min;
                    int? max;
                    try{
                     min = int.parse(storeRegController.storeMinTime);
                     max = int.parse(storeRegController.storeMaxTime);
                    }catch(e){
                      log(e.toString());
                    }

                    if(min == null){
                      showCustomSnackBar(isRental ? 'minimum_pickup_time_can_not_be_empty' : 'Minimum delivery time can not be empty'.tr);
                    }else if(max == null){
                      showCustomSnackBar(isRental ? 'maximum_pickup_time_can_not_be_empty' : 'Maximum delivery time can not be empty'.tr);
                    }else if(storeRegController.storeTimeUnit.isEmpty){
                      showCustomSnackBar('Time unit can not be empty'.tr);
                    }else if(min < max){
                      Get.back();
                    }else{
                      showCustomSnackBar(isRental ? 'maximum_pickup_time_can_not_be_smaller_then_minimum_pickup_time' : 'Maximum delivery time can not be smaller then minimum delivery time'.tr);
                    }
                  },
                ),

              ],
            );
          }
        ),
      ),
    );
  }
}
