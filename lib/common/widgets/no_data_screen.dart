import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final bool showFooter;
  final String? text;
  final bool fromAddress;
  const NoDataScreen({super.key, required this.text, this.isCart = false, this.showFooter = false, this.fromAddress = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FooterView(
        visibility: showFooter,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          Center(
            child: Image.asset(
              fromAddress ? Images.address : isCart ? Images.emptyCart : Images.noDataFound,
              width: MediaQuery.of(context).size.height*0.15, height: MediaQuery.of(context).size.height*0.15,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          Text(
            isCart ? 'Cart is empty'.tr : text!,
            style: ralewayMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: fromAddress ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          fromAddress ? Text(
            'Please add your address for your better experience'.tr,
            style: ralewayMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ) : const SizedBox(),
          SizedBox(height: MediaQuery.of(context).size.height*0.05),

          fromAddress ? InkWell(
            onTap: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, false, 0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline_sharp, size: 18.0, color: Theme.of(context).cardColor),
                  Text('Add address'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).cardColor)),
                ],
              ),
            ),
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}
