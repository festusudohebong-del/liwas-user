import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:liwas_user/common/widgets/custom_card.dart';
import 'package:liwas_user/features/splash/controllers/splash_controller.dart';
import 'package:liwas_user/features/notification/domain/models/notification_body_model.dart';
import 'package:liwas_user/features/chat/domain/models/conversation_model.dart';
import 'package:liwas_user/features/order/controllers/order_controller.dart';
import 'package:liwas_user/features/order/domain/models/order_model.dart';
import 'package:liwas_user/features/review/domain/models/review_model.dart';
import 'package:liwas_user/helper/auth_helper.dart';
import 'package:liwas_user/helper/date_converter.dart';
import 'package:liwas_user/helper/price_converter.dart';
import 'package:liwas_user/helper/responsive_helper.dart';
import 'package:liwas_user/helper/route_helper.dart';
import 'package:liwas_user/helper/string_extension.dart';
import 'package:liwas_user/util/app_constants.dart';
import 'package:liwas_user/util/dimensions.dart';
import 'package:liwas_user/util/images.dart';
import 'package:liwas_user/util/styles.dart';
import 'package:liwas_user/common/widgets/custom_image.dart';
import 'package:liwas_user/common/widgets/custom_snackbar.dart';
import 'package:liwas_user/common/widgets/rating_bar.dart';
import 'package:liwas_user/features/chat/widgets/image_dialog_widget.dart';
import 'package:liwas_user/features/order/widgets/delivery_details_widget.dart';
import 'package:liwas_user/features/payment/widgets/offline_info_edit_dialog_widget.dart';
import 'package:liwas_user/features/order/widgets/order_banner_view_widget.dart';
import 'package:liwas_user/features/order/widgets/order_item_widget.dart';
import 'package:liwas_user/features/parcel/widgets/details_widget.dart';
import 'package:liwas_user/features/review/widgets/review_dialog_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderInfoWidget extends StatelessWidget {
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final OrderController orderController;
  final Function timerCancel;
  final Function startApiCall;
  final bool showChatPermission;
  const OrderInfoWidget({super.key, required this.order, required this.ongoing, required this.parcel, required this.prescriptionOrder, required this.orderController,
    required this.timerCancel, required this.startApiCall, required this.showChatPermission});

  @override
  Widget build(BuildContext context) {

    ExpansibleController controller = ExpansibleController();
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();

    return Stack(children: [

      !isDesktop ? OrderBannerViewWidget(
        order: order, orderController: orderController, ongoing: ongoing,
        parcel: parcel, prescriptionOrder: prescriptionOrder,
      ) : const SizedBox(),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        !isDesktop ? SizedBox(height: DateConverter.isBeforeTime(order.scheduleAt) && Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation!
          ? (order.orderStatus != 'delivered' && order.orderStatus != 'failed'
          && order.orderStatus != 'canceled' && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
          && order.orderStatus != 'refund_request_canceled' ) ? 280 : 140 :
          parcel || prescriptionOrder || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'grocery')
          || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'ecommerce')
          || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemDetails!.moduleType == 'pharmacy')
          ? 140 : 0) : const SizedBox(),

        CustomCard(
          isBorder: false, borderRadius: isDesktop ? Dimensions.radiusDefault : 0,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

            isDesktop ? OrderBannerViewWidget(
              order: order, orderController: orderController, ongoing: ongoing,
              parcel: parcel, prescriptionOrder: prescriptionOrder,
            ) : const SizedBox(),
            isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

            Text('General info'.tr, style: ralewaySemiBold),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(parcel ? 'Delivery id'.tr : 'Order id'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Text('#${order.id}', style: ralewayBold),
            ]),
            Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

            parcel && order.orderStatus == AppConstants.canceled ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Return date and time'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Text(order.parcelCancellation?.returnDate != null ? DateConverter.dateTimeStringToDateTime(order.parcelCancellation!.returnDate!) : 'Not set yet'.tr, style: ralewayRegular),
            ]) : const SizedBox(),
            parcel && order.orderStatus == AppConstants.canceled ? Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)) : const SizedBox(),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Order date'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Text(DateConverter.dateTimeStringToDateTime(order.createdAt!), style: ralewayRegular),
            ]),
            Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

            order.scheduled == 1 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Scheduled at'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: ralewayRegular),
            ]) : const SizedBox(),
            order.scheduled == 1 ? Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)) : const SizedBox(),

            order.orderStatus != 'canceled' && Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Delivery verification code'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Text(order.otp ?? '', style: ralewayBold),
            ]) : const SizedBox(),
            order.orderStatus != 'canceled' && Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)) : const SizedBox(),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Payment method'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text( order.paymentMethod == 'cash_on_delivery' ? 'Cash on delivery'.tr
                  : order.paymentMethod == 'wallet' ? 'Wallet payment'.tr
                  : order.paymentMethod == 'partial_payment' ? 'Partial payment'.tr
                  : order.paymentMethod == 'offline_payment' ? 'Offline payment'.tr : 'Digital payment'.tr,
                  style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                ),
              ),
            ]),
            Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(parcel ? 'Charge pay by'.tr : 'Item'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(
                  parcel ? order.chargePayer!.tr : orderController.orderDetails!.length.toString(),
                  style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
                ),
              ]),
            ),
            order.orderStatus == 'delivered' ? Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)) : const SizedBox(),

            order.orderStatus == 'delivered' ? Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Delivered at'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(
                  DateConverter.dateTimeStringToDateTime(order.delivered!),
                  style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
                ),
              ]),
            ) : const SizedBox(),

            Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation! ? Column(children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Cutlery'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

                Text(
                  order.cutlery! ? 'Yes'.tr : 'No'.tr,
                  style: ralewayRegular,
                ),
              ]),
            ]) : const SizedBox(),

            order.unavailableItemNote != null ? Column(children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              Row(children: [
                Text('${'Unavailable item note'.tr}: ', style: ralewayMedium),

                Text(
                  order.unavailableItemNote ?? '',
                  style: ralewayRegular,
                ),
              ]),
            ]) : const SizedBox(),

            order.deliveryInstruction != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              RichText(
                text: TextSpan(
                  text: '${'Delivery instruction'.tr}: ',
                  style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                  children: <TextSpan>[
                    TextSpan(text: order.deliveryInstruction?.tr ?? '', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),
                  ],
                ),
              ),
            ]) : const SizedBox(),
            SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

            !parcel ? order.orderStatus == 'canceled' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              Text('${'Cancellation note'.tr}: ', style: ralewayMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              order.cancellationReason != null ? InkWell(
                onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationReason), fromOrderDetails: true)),
                child: Text(
                  order.cancellationReason ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                ),
              ) : order.cancellationNote != null ? Text(
                order.cancellationNote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
              ) : const SizedBox(),
            ]) : const SizedBox() : const SizedBox(),

            (order.orderStatus == 'refund_requested' || order.orderStatus == 'refund_request_canceled') ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              order.orderStatus == 'refund_requested' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(text: TextSpan(children: [
                  TextSpan(text: '${'Refund note'.tr}:', style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  TextSpan(text: '(${(order.refund != null) ? order.refund!.customerReason : ''})', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                ])),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                (order.refund != null && order.refund!.customerNote != null) ? InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.customerNote), fromOrderDetails: true)),
                  child: Text(
                    '${order.refund!.customerNote}', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ) : const SizedBox(),
                SizedBox(height: (order.refund != null && order.refund!.imageFullUrl != null) ? Dimensions.paddingSizeSmall : 0),

                (order.refund != null && order.refund!.imageFullUrl != null && order.refund!.imageFullUrl!.isNotEmpty) ? InkWell(
                  onTap: () => showDialog(context: context, builder: (context) {
                    return ImageDialogWidget(imageUrl: order.refund!.imageFullUrl!.isNotEmpty ? order.refund!.imageFullUrl![0] : '');
                  }),
                  child: CustomImage(
                    height: 40, width: 40, fit: BoxFit.cover,
                    image: order.refund != null ? order.refund!.imageFullUrl!.isNotEmpty ? order.refund!.imageFullUrl![0] : '' : '',
                  ),
                ) : const SizedBox(),
              ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${'Refund cancellation note'.tr}:', style: ralewayMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.adminNote), fromOrderDetails: true)),
                  child: Text(
                    '${order.refund != null ? order.refund!.adminNote : ''}', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: ralewayRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]),
            ]) : const SizedBox(),

            order.bringChangeAmount != null && order.bringChangeAmount! > 0 ? Column(children: [
              Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: const Color(0XFF009AF1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Please bring'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    TextSpan(text: ' ${PriceConverter.convertPrice(order.bringChangeAmount)}', style: ralewayMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    TextSpan(text: ' ${'In change when making the delivery'.tr}', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  ]),
                ),
              ),
            ]) : const SizedBox(),

          ]),
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),

        parcel && order.parcelCancellation != null ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            order.parcelCancellation!.returnFee != null && order.parcelCancellation!.returnFee! > 0 ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('You will pay return fee'.tr, style: ralewayRegular),

                Text(PriceConverter.convertPrice(order.parcelCancellation!.returnFee), style: ralewayBold),
              ]),
            ) : const SizedBox(),
            SizedBox(height: order.parcelCancellation!.returnFee != null && order.parcelCancellation!.returnFee! > 0 ? Dimensions.paddingSizeSmall : 0),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Canceled by'.tr, style: ralewayRegular.copyWith(color: Theme.of(context).colorScheme.error)),

                Text(order.parcelCancellation?.cancelBy?.toTitleCase() ?? '', style: ralewayRegular),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            order.parcelCancellation?.reason != null && order.parcelCancellation!.reason!.isNotEmpty ? Text('Cancellation reason'.tr, style: ralewaySemiBold) : const SizedBox(),
            SizedBox(height: order.parcelCancellation?.reason != null && order.parcelCancellation!.reason!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

            order.parcelCancellation?.reason != null && order.parcelCancellation!.reason!.isNotEmpty ? Container(
              padding: const EdgeInsets.all(12),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(order.parcelCancellation!.reason!.length, (index) {
                  return Row(children: [
                    Container(
                      height: 5, width: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Text(order.parcelCancellation!.reason?[index] ?? '', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)))),
                  ]);
                },
              ),
            )) : const SizedBox(),
            SizedBox(height: order.parcelCancellation?.reason != null && order.parcelCancellation!.reason!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

            order.parcelCancellation?.note != null ? Text('comments'.tr, style: ralewaySemiBold) : const SizedBox(),
            SizedBox(height: order.parcelCancellation?.note != null ? Dimensions.paddingSizeSmall : 0),

            order.parcelCancellation?.note != null ? Container(
              padding: const EdgeInsets.all(12),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Text(order.parcelCancellation?.note ?? '', style: ralewayRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
            ) : const SizedBox(),
          ]),
        ) : const SizedBox(),
        SizedBox(height: parcel && order.parcelCancellation != null ?  Dimensions.paddingSizeSmall : 0),

        !isDesktop ? (parcel || orderController.orderDetails!.isNotEmpty) ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: parcel ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            DetailsWidget(title: 'Sender details'.tr, address: order.deliveryAddress),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            DetailsWidget(title: 'Receiver details'.tr, address: order.receiverDetails),
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text('Item info'.tr, style: ralewaySemiBold),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderController.orderDetails!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == orderController.orderDetails!.length - 1 ? 0 : Dimensions.paddingSizeSmall),
                  child: OrderItemWidget(order: order, orderDetails: orderController.orderDetails![index]),
                );
              },
            ),
          ]),
        ) : const SizedBox() : const SizedBox(),
        SizedBox(height: !isDesktop ? (parcel || orderController.orderDetails!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0 : 0),

        (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null
          && order.orderAttachmentFullUrl!.isNotEmpty ) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

        (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null
          && order.orderAttachmentFullUrl!.isNotEmpty )  ? Text('Prescription'.tr, style: ralewayMedium) :  const SizedBox(),

        (isDesktop && Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null
          && order.orderAttachmentFullUrl!.isNotEmpty ) ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

        (Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null && order.orderAttachmentFullUrl!.isNotEmpty) ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            !isDesktop ? Text('Prescription'.tr, style: ralewaySemiBold) : const SizedBox(),
            !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

            SizedBox(child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: isDesktop ? 8 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.orderAttachmentFullUrl!.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => openDialog(context, '${order.orderAttachmentFullUrl![index]}'),
                    child: Center(child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${order.orderAttachmentFullUrl![index]}',
                        width: 100, height: 100,
                      ),
                    )),
                  ),
                );
              }),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            SizedBox(width: (Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment!
                && order.orderAttachmentFullUrl != null && order.orderAttachmentFullUrl!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

            (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Additional note'.tr, style: ralewayRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InkWell(
                onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.orderNote), fromOrderDetails: true)),
                child: Text(
                  order.orderNote!, overflow: TextOverflow.ellipsis, maxLines: 3,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]) : const SizedBox(),
          ]),
        ) : const SizedBox(),
        SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null && order.orderAttachmentFullUrl!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

        (order.orderStatus == 'delivered' && order.orderProofFullUrl != null && order.orderProofFullUrl!.isNotEmpty) ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Order proof'.tr, style: ralewayRegular),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.orderProofFullUrl!.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => openDialog(context, order.orderProofFullUrl![index]),
                    child: Center(child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: order.orderProofFullUrl![index],
                        width: 100, height: 100,
                      ),
                    )),
                  ),
                );
              },
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        ) : const SizedBox(),
        SizedBox(height: (order.orderStatus == 'delivered' && order.orderProofFullUrl != null && order.orderProofFullUrl!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

        (order.deliveryMan != null && isDesktop) ? Text('Delivery man details'.tr, style: ralewayMedium) : const SizedBox(),
        SizedBox(height: (order.deliveryMan != null && isDesktop) ? Dimensions.paddingSizeSmall : 0),

        order.deliveryMan != null ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Delivery man details'.tr, style: ralewaySemiBold),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [

              ClipOval(child: CustomImage(
                image: '${order.deliveryMan!.imageFullUrl}',
                height: 35, width: 35, fit: BoxFit.cover,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                RatingBar(
                  rating: order.deliveryMan!.avgRating, size: 10,
                  ratingCount: order.deliveryMan!.ratingCount,
                ),
              ])),

              (order.orderStatus != 'delivered' && order.orderStatus != 'failed' && order.orderStatus != 'canceled' && order.orderStatus != 'refunded') ? Row(children: [

                showChatPermission ? InkWell(
                  onTap: () async{
                    timerCancel();
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBodyModel(deliverymanId: order.deliveryMan!.id, orderId: int.parse(order.id.toString())),
                      user: User(id: order.deliveryMan!.id, fName: order.deliveryMan!.fName, lName: order.deliveryMan!.lName, imageFullUrl: order.deliveryMan!.imageFullUrl),
                    ));
                    startApiCall();
                  },
                  child: Image.asset(Images.chatOrderDetails, height: 20, width: 20),
                ) : const SizedBox(),
                SizedBox(width: showChatPermission ? Dimensions.paddingSizeSmall : 0),

                InkWell(
                  onTap: () async {
                    if(await canLaunchUrlString('tel:${order.deliveryMan!.phone}')) {
                      launchUrlString('tel:${order.deliveryMan!.phone}', mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('${'Can not launch'.tr} ${order.deliveryMan!.phone}');
                    }
                  },
                  child: Image.asset(Images.phoneOrderDetails, height: 20, width: 20),
                ),

              ]) : const SizedBox(),

            ]),
          ]),
        ) : const SizedBox(),
        SizedBox(height: order.deliveryMan != null ? Dimensions.paddingSizeSmall : 0),

        (parcel &&  isDesktop) ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            DetailsWidget(title: 'Sender details'.tr, address: order.deliveryAddress),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            DetailsWidget(title: 'Receiver details'.tr, address: order.receiverDetails),
          ]),
        ) : const SizedBox(),
        SizedBox(height: (parcel &&  isDesktop) ? Dimensions.paddingSizeSmall : 0),

        (!parcel && isDesktop) ? Text('Delivery details'.tr, style: ralewayMedium) :  const SizedBox(),
        (!parcel && isDesktop) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

        (!parcel && order.store != null) ? CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            !isDesktop ? Text('Delivery details'.tr, style: ralewaySemiBold) : const SizedBox(),
            !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            DeliveryDetailsWidget(from: true, address: order.store!.address),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            DeliveryDetailsWidget(from: false, address: order.deliveryAddress?.address),
          ]),
        ) : const SizedBox(),
        SizedBox(height: (!parcel && order.store != null) ? Dimensions.paddingSizeSmall : 0),

        isDesktop ? Text(parcel ? 'Parcel category'.tr : Get.find<SplashController>().getModuleConfig(order.moduleType).showRestaurantText! ? 'Restaurant details'.tr : 'Store details'.tr, style: ralewayMedium)  : const SizedBox(),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeSmall : 0),

        CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            !isDesktop ? Text(parcel ? 'Parcel category'.tr : Get.find<SplashController>().getModuleConfig(order.moduleType).showRestaurantText! ? 'Restaurant details'.tr : 'Store details'.tr, style: ralewaySemiBold) : const SizedBox(),
            !isDesktop ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

            (parcel && order.parcelCategory == null) ? Text(
              'No parcel category data found'.tr, style: ralewayMedium,
            ) : (!parcel && order.store == null) ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('No restaurant data found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            )) : Row(children: [
              ClipOval(child: CustomImage(
                image: parcel ? '${order.parcelCategory!.imageFullUrl}' : '${order.store!.logoFullUrl}',
                height: 35, width: 35, fit: BoxFit.cover,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  parcel ? order.parcelCategory!.name! : order.store!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                Text(
                  parcel ? order.parcelCategory!.description! : order.store?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: ralewayRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
              ])),

              (!parcel && order.orderType == 'take_away' && (order.orderStatus == 'pending' || order.orderStatus == 'accepted'
              || order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover'
              || order.orderStatus == 'picked_up')) ? TextButton.icon(onPressed: () async {
                if(!parcel) {
                  String url ='https://www.google.com/maps/dir/?api=1&destination=${order.store!.latitude}'
                      ',${order.store!.longitude}&mode=d';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  }else {
                    showCustomSnackBar('Unable to launch google map'.tr);
                  }
                }
              }, icon: const Icon(Icons.directions), label: Text('Direction'.tr),

              ) : const SizedBox(),

              (showChatPermission && AuthHelper.isLoggedIn() && !parcel && order.orderStatus != 'delivered' && order.orderStatus != 'failed' && order.orderStatus != 'canceled' && order.orderStatus != 'refunded') ? InkWell(
                onTap: () async {
                  await Get.toNamed(RouteHelper.getChatRoute(
                    notificationBody: NotificationBodyModel(orderId: order.id, restaurantId: order.store!.vendorId),
                    user: User(id: order.store!.vendorId, fName: order.store!.name, lName: '', imageFullUrl: order.store!.logoFullUrl),
                  ));
                },
                child: Image.asset(Images.chatOrderDetails, height: 20, width: 20),
              ) : const SizedBox(),

              !isGuestLoggedIn && (Get.find<SplashController>().configModel!.refundActiveStatus! && order.orderStatus == 'delivered' && !parcel
              && (parcel || (orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemCampaignId == null))) ? InkWell(
                onTap: () => Get.toNamed(RouteHelper.getRefundRequestRoute(order.id.toString())),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                  child: Text('Refund this order'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                ),
              ) : const SizedBox(),

            ]),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        isDesktop ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payment method'.tr, style: ralewayMedium),
            order.paymentMethod == 'offline_payment' ? Text(
              orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
              style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor),
            ) : const SizedBox(),
          ],
        ) : const SizedBox(),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

        CustomCard(
          borderRadius: isDesktop ? Dimensions.radiusDefault : 0, isBorder: false,
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            !isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Text('Payment method'.tr, style: ralewaySemiBold),

              order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null) ? Text(
                orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
                style: ralewayMedium.copyWith(color: (orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status.toString() == 'denied' : false) ? Colors.red : Theme.of(context).primaryColor),
              ) : const SizedBox(),

            ]) : const SizedBox(),
            (!isDesktop && order.paymentMethod != 'offline_payment') ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

            order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null)
            ? offlineView(context, orderController, controller, ongoing) : Row(children: [

              Image.asset(
                order.paymentMethod == 'cash_on_delivery' ? Images.cash
                : order.paymentMethod == 'wallet' ? Images.wallet
                : order.paymentMethod == 'partial_payment' ? Images.partialWallet
                : Images.digitalPayment,
                width: 20, height: 20,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Text(
                  order.paymentMethod == 'cash_on_delivery' ? 'Cash'.tr
                  : order.paymentMethod == 'wallet' ? 'Wallet'.tr
                  : order.paymentMethod == 'partial_payment' ? 'Partial payment'.tr : 'Digital'.tr,
                  style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
              ),

            ]),

          ]),
        ),
      ]),

    ]);
  }
}

Widget offlineView(BuildContext context, OrderController orderController, ExpansibleController controller, bool ongoing) {
  return ListTileTheme(
    contentPadding: const EdgeInsets.all(0),
    dense: true,
    horizontalTitleGap: 5.0,
    minLeadingWidth: 0,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: controller,
        leading: Image.asset(
          Images.cash, width: 20, height: 20,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'Offline payment'.tr,
          style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        trailing: Icon(!orderController.isExpanded ? Icons.expand_more : Icons.expand_less, size: 18),
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        onExpansionChanged: (value) => orderController.expandedUpdate(value),

        children: [
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Seller payment info'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor)),
            const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.methodFields!.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputName.toString().replaceAll('_', ' ')} : ', style: ralewayRegular),
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputData}', style: ralewayRegular),
                ]),
              );
            },
          ) : Text('No data found'.tr),
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('My payment info'.tr, style: ralewayMedium.copyWith(color: Theme.of(context).primaryColor)),

            (ongoing && orderController.trackModel!.offlinePayment != null && orderController.trackModel!.offlinePayment!.data!.status != 'verified') ? InkWell(
              onTap: (){
                Get.dialog(OfflineInfoEditDialogWidget(offlinePayment: orderController.trackModel!.offlinePayment!, orderId: orderController.trackModel!.id!), barrierDismissible: true);
              },
              child: Text('Edit details'.tr, style: ralewayBold.copyWith(color: Theme.of(context).primaryColor)),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.input!.length,
            itemBuilder: (context, index){
              Input data = orderController.trackModel!.offlinePayment!.input![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${data.userInput.toString().replaceAll('_', ' ')}: ', style: ralewayRegular),
                  Text(data.userData.toString(), style: ralewayRegular),
                ]),
              );
            },
          ) : const SizedBox(),
          // const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    ),
  );
}

void openDialog(BuildContext context, String imageUrl) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          child: PhotoView(
            tightMode: true,
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          ),
        ),

        Positioned(top: 0, right: 0, child: IconButton(
          splashRadius: 5,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel, color: Colors.red),
        )),

      ]),
    );
  },
);
