import 'dart:async';
import 'package:flutter/services.dart';

enum AppodealAdType {
  AppodealAdTypeInterstitial,
  AppodealAdTypeSkippableVideo,
  AppodealAdTypeBanner,
  AppodealAdTypeNativeAd,
  AppodealAdTypeRewardedVideo,
  AppodealAdTypeMREC,
  AppodealAdTypeNonSkippableVideo,
}

enum RewardedVideoAdEvent {
  loaded,
  failedToLoad,
  failedToPresent,
  present,
  willDismiss,
  finish,
  expired,
}

typedef void RewardedVideoAdListener(RewardedVideoAdEvent event,
    {String rewardType, double rewardAmount, bool wasFullyWatched});

class FlutterAppodeal {
  bool shouldCallListener;

  final MethodChannel _channel;
  
  /// Called when the status of the video ad changes.
  RewardedVideoAdListener videoListener;
  
  static const Map<String, RewardedVideoAdEvent> _methodToRewardedVideoAdEvent =
      const <String, RewardedVideoAdEvent>{
    'rewardedVideoDidLoadAdIsPrecache': RewardedVideoAdEvent.loaded,
    'onRewardedVideoFailedToLoad': RewardedVideoAdEvent.failedToLoad,
    'onRewardedVideoDidFailToPresentWithError':
        RewardedVideoAdEvent.failedToPresent,
    'onRewardedVideoPresent': RewardedVideoAdEvent.present,
    'rewardedVideoWillDismissAndWasFullyWatched':
        RewardedVideoAdEvent.willDismiss,
    'onRewardedVideoFinished': RewardedVideoAdEvent.finish,
    'onRewardedVideoExpired': RewardedVideoAdEvent.expired,
  };

  static final FlutterAppodeal _instance = new FlutterAppodeal.private(
    const MethodChannel('flutter_appodeal'),
  );

  FlutterAppodeal.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static FlutterAppodeal get instance => _instance;

  Future setUserIdData({
    String userId,
  }) async {
    shouldCallListener = false;
    await _channel.invokeMethod('setUserIdData', <String, dynamic>{
      'userId': userId,
    });
  }

  Future setUserFullData({
    String userId,
    int age,
    int gender,
  }) async {
    shouldCallListener = false;
    await _channel.invokeMethod('setUserFullData', <String, dynamic>{
      'userId': userId,
      'age': age,
      'gender': gender,
    });
  }

  Future initialize(
      String appKey, List<AppodealAdType> types, bool hasConsent) async {
    shouldCallListener = false;
    List<int> itypes = new List<int>();
    for (final type in types) {
      itypes.add(type.index);
    }
    _channel.invokeMethod('initialize', <String, dynamic>{
      'appKey': appKey,
      'types': itypes,
      'hasConsent': hasConsent,
    });
  }

  /*
    Shows an Interstitial in the root view controller or main activity
   */
  Future showInterstitial() async {
    shouldCallListener = false;
    _channel.invokeMethod('showInterstitial');
  }

  /*
    Shows an Rewarded Video in the root view controller or main activity
   */
  Future showRewardedVideo({String placement}) async {
    shouldCallListener = true;
    _channel.invokeMethod('showRewardedVideo', <String, dynamic>{
      'placement': placement,
    });
  }

  Future<bool> isLoaded(AppodealAdType type) async {
    shouldCallListener = false;
    final bool result = await _channel
        .invokeMethod('isLoaded', <String, dynamic>{'type': type.index});
    return result;
  }

  Future sharedSdkWithApiKey({String appKey}) async {
    shouldCallListener = false;
    await _channel.invokeMethod('sharedSdkWithApiKey', <String, dynamic>{
      'appKey': appKey,
    });
  }

  Future setDisableAutoCacheOnRewardedVideo({bool isAutoCaching=false}) async {
    shouldCallListener = false;
    await _channel.invokeMethod('setDisableAutoCacheOnRewardedVideo');
  }

  Future setManualCacheOnRewardedVideo() async {
    shouldCallListener = false;
    await _channel.invokeMethod('setManualCacheOnRewardedVideo');  
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final RewardedVideoAdEvent rewardedEvent =
        _methodToRewardedVideoAdEvent[call.method];
    if (rewardedEvent != null && shouldCallListener) {
      
      if (this.videoListener != null) {
        if (rewardedEvent == RewardedVideoAdEvent.loaded) {
          print('[DEBUG] Loaded done.');
        } else if (rewardedEvent == RewardedVideoAdEvent.finish &&
            argumentsMap != null) {
          this.videoListener(rewardedEvent,
              rewardType: argumentsMap['rewardType'],
              rewardAmount: argumentsMap['rewardAmount']);

        } else if (rewardedEvent == RewardedVideoAdEvent.willDismiss &&
            argumentsMap != null) {
          this.videoListener(rewardedEvent,
              wasFullyWatched: argumentsMap['wasFullyWatched']);
        
        } else {
          this.videoListener(rewardedEvent);
        }

      }
      
    }

    return null;
  }
}
