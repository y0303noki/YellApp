import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/screen/start_my_setting_page.dart';
import 'package:yell_app/state/counter_provider.dart';

class StartPage extends ConsumerWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: bodyWidget(context),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartMySettingPage(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ButtonWidget.startMyButton(deviceSize.width),
                    Text('友達に応援してもらう'),
                  ],
                ),
              ),
              Column(
                children: [
                  ButtonWidget.startAtherButton(deviceSize.width),
                  Text('招待コードが必要'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
