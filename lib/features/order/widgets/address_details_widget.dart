import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/features/address/domain/models/address_model.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/styles.dart';

class AddressDetailsWidget extends StatelessWidget {
  final AddressModel? addressDetails;
  const AddressDetailsWidget({super.key, required this.addressDetails,});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        addressDetails!.address ?? '',
        style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 4, overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 5),

      Wrap(children: [
        (addressDetails!.streetNumber != null && addressDetails!.streetNumber!.isNotEmpty) ? Text('${'Street number'.tr}: ${addressDetails!.streetNumber!}',
          style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

        (addressDetails!.house != null && addressDetails!.house!.isNotEmpty) ? Text('${addressDetails!.streetNumber != null ? ', ' : ''}${'House'.tr}: ${addressDetails!.house!}',
          style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

        (addressDetails!.floor != null && addressDetails!.floor!.isNotEmpty) ? Text('${(addressDetails!.streetNumber != null || addressDetails!.house != null) ? ', ' : ''}${'Floor'.tr}: ${addressDetails!.floor!}' ,
          style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

      ]),
    ]);
  }
}

