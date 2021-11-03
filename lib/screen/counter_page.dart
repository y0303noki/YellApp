import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/state/counter_provider.dart';

final countStateProvider = StateProvider((ref) => 0);
final appNameProvider = Provider((ref) => 'AppName');

final previousCounterProvider = Provider((ref) {
  final counter = ref.watch(countStateProvider).state;
  return counter - 1;
});

class CounterPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useProvider(countStateProvider).state;
    final appName = useProvider(appNameProvider);
    final previousCount = useProvider(previousCounterProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(appName)),
        body: Center(
          child: Row(children: [
            Text('$count'),
            Text('前回の値：$previousCount'),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read(countStateProvider).state = count + 1,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
