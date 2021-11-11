import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/screen/login_check_page.dart';
import 'package:yell_app/screen/start_page.dart';
import 'package:yell_app/state/counter_provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: LoginCheckPage(),
      ),
    ),
  );
}
