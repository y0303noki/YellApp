import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/screen/login_check_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR');
  print('環境:$flavor');

  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const LoginCheckPage(),
        theme: ThemeData(primaryColor: Colors.blueGrey),
      ),
    ),
  );
}
