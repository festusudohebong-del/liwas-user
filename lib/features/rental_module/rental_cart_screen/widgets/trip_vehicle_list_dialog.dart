import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/custom_button.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/features/rental_module/home/domain/models/vehicle_details_model.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/controllers/taxi_cart_controller.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/domain/models/car_cart.dart';
import 'package:liwas_user/features/rental_module/rental_cart_screen/domain/models/car_cart_model.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class TripVehicleListDialog extends StatelessWidget {
  final String rentalType;
  final CarCart cart;
  final int userId;
  final CarCart? newVehicle;
  final int? cartIndex;
  final bool? isIncrement;
  const TripVehicleListDialog({super.key, required this.rentalType, required this.cart, required this.userId, this.newVehicle, this.cartIndex, this.isIncrement});

  @override
  Widget build(BuildContext context) {
    // final tripVehicleDialog = tripVehicleDialogRepository().getTripVehicleDialog();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: GetBuilder<TaxiCartController>(
          builder: (taxiCartController) {
            return Column(mainAxisSize: MainAxisSize.min, children: [

              Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(child: Text('Trip vehicle list'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),

                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, size: Dimensions.fontSizeOverLarge, color: Colors.grey.shade400),
                  ),
                ]),
              ),

              Column(mainAxisSize: MainAxisSize.min, children: [
                ListView.builder(
                  itemCount: taxiCartController.cartList.length,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {

                    VehicleModel vehicle = taxiCartController.cartList[index].vehicle!;
                    bool isExist = false;
                    if(rentalType == 'hourly') {
                      isExist = vehicle.tripHourly!;
                    } else if(rentalType == 'day_wise') {
                      isExist = vehicle.tripDayWise!;
                    } else {
                      isExist = vehicle.tripDistance!;
                    }
                    double discount = vehicle.discountPrice ?? 0;
                    String discountType = vehicle.discountType ?? 'percent';
                    double hourlyDiscount = PriceConverter.calculation(vehicle.hourlyPrice!, discount, discountType, 1);
                    double distanceWiseDiscount = PriceConverter.calculation(vehicle.distancePrice!, discount, discountType, 1);

                    return Column(children: [
                      Row(children: [

                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),),
                          height: 60, width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(image: vehicle.thumbnailFullUrl??''),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(flex: 10,
                          child: Column(spacing: Dimensions.paddingSizeExtraSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('${vehicle.name}', style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

                            Text('${vehicle.tripHourly! ? 'Hourly'.tr : ''}, ${vehicle.tripDayWise! ? 'Day wise'.tr : ''} ${vehicle.tripDistance! ? ', ${'Distance wise'.tr}' : ''}', style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.grey.shade700),),

                            Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                              Text(
                                PriceConverter.convertPrice(vehicle.tripHourly! ? vehicle.hourlyPrice! : vehicle.tripDayWise! ? vehicle.dayWisePrice! : vehicle.distancePrice!, forTaxi: true),
                                style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, decoration: TextDecoration.lineThrough, color: Theme.of(context).disabledColor, decorationColor: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                              ),

                              Text(
                                PriceConverter.convertPrice(vehicle.tripHourly! ? (vehicle.hourlyPrice! - hourlyDiscount) : vehicle.tripDayWise! ? (vehicle.dayWisePrice! - distanceWiseDiscount) : (vehicle.distancePrice! - distanceWiseDiscount), forTaxi: true),
                                style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Container(
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: isExist ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.only(top: 2, bottom: 4, left: 2, right: 2),
                          child: Icon(isExist ? Icons.check : Icons.warning_amber_rounded, color: Colors.white, size: 16,),
                        )
                      ]),

                      const Divider(height: Dimensions.paddingSizeLarge),

                    ]);
                  },
                ),

                //warning statement
                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                  child: Wrap(children: [
                    Text(
                      'One or more of the selected vehicles does not match the chosen rental type'.tr,
                      style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    )
                  ]),
                ),

                GetBuilder<TaxiCartController>(
                  builder: (taxiCartController) {
                    return !taxiCartController.isLoading ? Row(children: [
                      Expanded(
                        flex: 3,
                        child: CustomButton(
                          buttonText: 'Cancel'.tr,
                          color: Theme.of(context).disabledColor,
                          onPressed: ()=> Get.back(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        flex: 5,
                        child: CustomButton(
                          buttonText: 'Remove and continue'.tr,
                          onPressed: () async {
                           List<int> ids = await getUnavailableVehiclesId(taxiCartController.cartList);
                           taxiCartController.clearMultipleCart(ids).then((success) {
                             if(success) {
                               // Get.back();
                               taxiCartController.updateUserData(cart: cart, userId: userId).then((success) async {
                                 if(success) {
                                   if(newVehicle != null && cartIndex == null) {
                                     await taxiCartController.addToCart(newVehicle!);
                                   } else if(cartIndex != null){
                                     taxiCartController.setQuantity(isIncrement!, cartIndex!);
                                   }
                                   await taxiCartController.getCarCartList();
                                   Get.back();
                                 }
                               });
                             }
                           });
                          },
                        ),
                      ),
                    ]) : const Center(child: CircularProgressIndicator());
                  }
                )
              ]),

            ]);
          }
        ),
      ),
    );

  }

  Future<List<int>> getUnavailableVehiclesId(List<Carts> cartList) async{
    List<int> ids = [];
    for (var cart in cartList) {
      if(rentalType == 'hourly' && !cart.vehicle!.tripHourly!) {
        ids.add(cart.id!);
      }else if(rentalType == 'day_wise' && !cart.vehicle!.tripDayWise!) {
        ids.add(cart.id!);
      } else if(!cart.vehicle!.tripDistance!){
        ids.add(cart.id!);
      }
    }
    return ids;
  }
}

