import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

///  ローカル通知ページ
class LocalNotificationPage extends ConsumerWidget {
  const LocalNotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 10,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   margin: const EdgeInsets.only(
            //     top: 10,
            //     bottom: 5,
            //   ),
            //   child: TextWidget.headLineText5('リセットタイムを変更'),
            // ),
            // CommonWidget.descriptionWidget(
            //   CommonWidget.lightbulbIcon(),
            //   '達成してから次に達成可能になるまでの時間を設定します',
            // ),
            TextButton(
                onPressed: () {
                  setNotification();
                },
                child: Text('start!'))
          ],
        ),
      ),
    );
  }

  void setNotification() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            // sound: 'example.mp3',
            presentAlert: true,
            presentBadge: true,
            presentSound: true);
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: null,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'title', 'body', platformChannelSpecifics);
  }
}
