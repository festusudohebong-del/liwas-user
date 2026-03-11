import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liwas_user/features/language/controllers/language_controller.dart';
import 'package:liwas_user/features/checkout/controllers/checkout_controller.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_text_field.dart';

class GuestDeliveryAddress extends StatelessWidget {
  final CheckoutController checkoutController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const GuestDeliveryAddress({super.key, required this.checkoutController, required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController, required this.guestNumberNode, required this.guestEmailController, required this.guestEmailNode,
  });

  @override
  Widget build(BuildContext context) {
    bool takeAway = (checkoutController.orderType == 'take_away');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
      child: Column(children: [
        Row(children: [
          Image.asset(Images.truck, height: 14, width: 14, color: Theme.of(context).textTheme.bodyLarge!.color),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(takeAway ? 'Contact information'.tr : 'Delivery information'.tr, style: ralewayBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
          const Spacer(),

          takeAway ? const SizedBox() : InkWell(
            onTap: () async {
              String? previousGuestAddress = checkoutController.guestAddress?.address;
              var address = await Get.toNamed(RouteHelper.getEditAddressRoute(checkoutController.guestAddress, fromGuest: true));

              if(address != null) {
                checkoutController.setGuestAddress(address);
                if(previousGuestAddress != address.deliveryAddress) {
                  checkoutController.getDistanceInKM(
                    LatLng(double.parse(address.latitude), double.parse(address.longitude)),
                    LatLng(double.parse(checkoutController.store!.latitude!), double.parse(checkoutController.store!.longitude!)),
                  );
                }
              }
            },
            child: Image.asset(Images.editDelivery, height: 20, width: 20, color: Theme.of(context).primaryColor),
          ),
        ]),

        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Divider(color: Theme.of(context).disabledColor),
        ),

        takeAway ? Column(children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomTextField(
            labelText: 'Contact person name'.tr,
            titleText: 'Write name'.tr,
            inputType: TextInputType.name,
            controller: guestNameTextEditingController,
            nextFocus: guestNumberNode,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomTextField(
            labelText: 'Contact person number'.tr,
            titleText: 'Write number'.tr,
            controller: guestNumberTextEditingController,
            focusNode: guestNumberNode,
            nextFocus: guestEmailNode,
            inputType: TextInputType.phone,
            isPhone: true,
            onCountryChanged: (CountryCode countryCode) {
              checkoutController.countryDialCode = countryCode.dialCode;
            },
            countryDialCode: checkoutController.countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomTextField(
            titleText: 'Enter email'.tr,
            labelText: 'Email'.tr,
            controller: guestEmailController,
            focusNode: guestEmailNode,
            inputAction: TextInputAction.done,
            inputType: TextInputType.emailAddress,
            prefixIcon: Icons.mail,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

        ]) : checkoutController.guestAddress == null ? InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
            child: Column(children: [
              Image.asset(Images.truck, height: 20, width: 20, color: Theme.of(context).disabledColor),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('Please update your delivery info'.tr, style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
            ]),
          ),
        ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Image.asset(Images.guestLocationIcon, height: 15, color: Theme.of(context).primaryColor),
              Text(' ${checkoutController.guestAddress!.addressType!.tr}:', style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Flexible(child: Text(
                checkoutController.guestAddress!.address!,
                style: ralewayRegular, maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          addressInfo('Name'.tr, checkoutController.guestAddress!.contactPersonName!),
          addressInfo('Phone'.tr, checkoutController.guestAddress!.contactPersonNumber!),
          addressInfo('Email'.tr, checkoutController.guestAddress!.email!),

          Row(mainAxisSize: MainAxisSize.min, spacing: Dimensions.paddingSizeLarge, children: [
            if(checkoutController.guestAddress!.streetNumber != null && checkoutController.guestAddress!.streetNumber!.isNotEmpty)
              Flexible(child: addressInfo('Street'.tr, checkoutController.guestAddress!.streetNumber!)),
            if(checkoutController.guestAddress!.house != null && checkoutController.guestAddress!.house!.isNotEmpty)
              Flexible(child: addressInfo('House'.tr, checkoutController.guestAddress!.house!)),
            if(checkoutController.guestAddress!.floor != null && checkoutController.guestAddress!.floor!.isNotEmpty)
              Flexible(child: addressInfo('Floor'.tr, checkoutController.guestAddress!.floor!)),
          ]),

        ]),

      ]),
    );
  }

  Widget addressInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$key: ', style: ralewayRegular),
        Flexible(child: Text(value, style: ralewayRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
