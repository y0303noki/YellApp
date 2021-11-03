import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/screen/counter_page.dart';
import 'package:yell_app/screen/start_page.dart';
import 'package:yell_app/state/counter_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: StartPage(),
      ),
    ),
  );
}
