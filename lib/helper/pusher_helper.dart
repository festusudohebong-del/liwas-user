// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class PusherHelper {
  static PusherChannelsClient? pusherClient;

  static Future<void> initializePusher() async {
    PusherChannelsOptions testOptions = PusherChannelsOptions.fromHost(
      host: 'liwas.ca',
      scheme: 'wss',
      key: 'qerwuioyvxcvbmntr',
      port: 6001,
    );

    // if(Get.find<SplashController>().configModel!.webSocketStatus??false) {
    pusherClient = PusherChannelsClient.websocket(
      options: testOptions,
      connectionErrorHandler: (exception, trace, refresh) async {
        log('=================$exception');
        // Get.find<SplashController>().setPusherStatus('Disconnected');
        refresh();
      },
    );

    await pusherClient?.connect();
    // }

    String? pusherChannelId =
        pusherClient?.channelsManager.channelsConnectionDelegate.socketId;
    if (pusherChannelId != null) {
      print('=================Pusher Connected');
      // Get.find<SplashController>().setPusherStatus('Connected');
    }

    pusherClient?.lifecycleStream.listen((event) {
      // Get.find<SplashController>().setPusherStatus('Disconnected');

      print('=================Pusher DisConnected');
    });
  }

  // late PrivateChannel pusherDriverLocation;
  late PublicChannel? publicChannel;

  void pusherDriverStatus(
      {required String deliverymanId,
      required Function(RecordLocationBodyModel) onLocationReceived}) {
    String channel = 'dm_location_$deliverymanId';

    log('========channel is: $channel');

    // _publicChannel = pusherClient!.publicChannel('pusher:subscribe');
    publicChannel = pusherClient!.publicChannel(channel);

    // _publicChannel.subscribe();
    publicChannel?.subscribeIfNotUnsubscribed();
    // FIX: PublicChannel uses 'pusher:subscription_succeeded' event via bind()

    publicChannel?.bind('pusher:subscription_succeeded').listen((_) {
      log('=======Public Subscribed');
    });

    publicChannel?.bind('pusher:subscription_error').listen((error) {
      log('=======Public Subscription Failed: ${error.data}');
    });

    publicChannel?.bind(channel).listen((event) {
      log('===========pusherDriverStatus bind is: ${event.data}');
      onLocationReceived(RecordLocationBodyModel(
        latitude: jsonDecode(event.data)['latitude'],
        longitude: jsonDecode(event.data)['longitude'],
        location: jsonDecode(event.data)['location'],
      ));
      // Get.find<OrderController>().setPusherLocation(RecordLocationBodyModel(
      //   latitude: jsonDecode(event.data)['latitude'],
      //   longitude: jsonDecode(event.data)['longitude'],
      //   location: jsonDecode(event.data)['location'],
      // ));
    });
  }

  void pusherDisconnectPusher() {
    publicChannel?.unsubscribe();
    pusherClient?.disconnect();
  }
}

class RecordLocationBodyModel {
  String? latitude;
  String? longitude;
  String? location;

  RecordLocationBodyModel({this.latitude, this.longitude, this.location});
}
