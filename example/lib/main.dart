import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appodeal/flutter_appodeal.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String videoState;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      List<AppodealAdType> types = new List<AppodealAdType>();
      types.add(AppodealAdType.AppodealAdTypeInterstitial);
      types.add(AppodealAdType.AppodealAdTypeRewardedVideo);
      FlutterAppodeal.instance.videoListener = (RewardedVideoAdEvent event,
          {String rewardType, double rewardAmount, bool wasFullyWatched}) {
        print("RewardedVideoAd event $event");
        setState(() {
          videoState = "State $event";
        });
      };
      
      // You can set user data for better ad targeting and higher eCPM.
      // If not needed, remove or comment out below.
      await FlutterAppodeal.instance.setUserFullData(
        userId: 'XXXXX-YYYYY-ZZZZZ',
        age: 25, 
        gender: 0, // Set 0:'male', 1:'female' or 2:'other'  
      );

      // If you want to cache rewarded video manually, 
      // set auto cache disable before sdk init. 
      // In the case of the fullscreen ads, it is better to use manual caching. 
      // It also increases display rate.
      // If you do not use manual video cache, comment out below:
      await FlutterAppodeal.instance.setDisableAutoCacheOnRewardedVideo();

      // You should use here your APP Key from Appodeal
      await FlutterAppodeal.instance.initialize(
          Platform.isIOS ? 'IOSAPPKEY' : 'ANDROIDAPPKEY',
          types,
          true /* Assume GDPR consent is given for the sake of demo */,
      );
      print('[DEBUG] Initialize done');
    } on PlatformException {}
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: Text('$videoState'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.green,
                      child: FlatButton(
                        onPressed: () {
                          this.setCache();
                        },
                        child: const Text('Load and cache Rewarded video'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.green,
                      child: FlatButton(
                        onPressed: () {
                          this.isLoaded();
                        },
                        child: const Text('Check if Loaded'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.green,
                      child: FlatButton(
                        onPressed: () {
                          this.showRewarded();
                        },
                        child: const Text('Show Rewarded video'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
         ),
    ));
  }

  // If you set auto cache disabled, cache ad manually.
  // Keep in mind ads need time for loading ~0-30 sec.
  // If not, comment out or do not use this function:
  void setCache() async {
    await FlutterAppodeal.instance.setManualCacheOnRewardedVideo();
    print('[DEBUG] Set manual cache on rewarded video done');
  }

  void isLoaded() async {
    bool loaded = await FlutterAppodeal.instance
        .isLoaded(AppodealAdType.AppodealAdTypeRewardedVideo);
    if (loaded) {
      print('[DEBUG] Rewarded video Loaded');
    } else {
      print('[DEBUG] Rewarded video Loading...');
    }
  }

  void showRewarded() async {
    await FlutterAppodeal.instance.showRewardedVideo(
        placement: 'default',
      );
  }
}
