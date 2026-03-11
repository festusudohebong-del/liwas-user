import 'package:liwas_user/features/item/controllers/campaign_controller.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/common/widgets/custom_app_bar.dart';
import 'package:liwas_user/common/widgets/footer_view.dart';
import 'package:liwas_user/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liwas_user/common/widgets/menu_drawer.dart';

class ItemCampaignScreen extends StatefulWidget {
  final bool isJustForYou;
  const ItemCampaignScreen({super.key, required this.isJustForYou});

  @override
  State<ItemCampaignScreen> createState() => _ItemCampaignScreenState();
}

class _ItemCampaignScreenState extends State<ItemCampaignScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<CampaignController>().getItemCampaignList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.isJustForYou ? 'Just for you'.tr : 'Campaigns'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SingleChildScrollView(
        child: FooterView(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: GetBuilder<CampaignController>(builder: (campController) {
              return ItemsView(
                isStore: false,
                items: campController.itemCampaignList,
                stores: null,
                isCampaign: true,
                noDataText: 'No campaign found'.tr,
              );
            }),
          ),
        ),
      ),
    );
  }
}
