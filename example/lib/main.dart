import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'dart:async';

import 'package:wayland_layer_shell/wayland_layer_shell.dart';
import 'package:wayland_layer_shell_example/set_exclusive_zone.dart';
import 'package:wayland_layer_shell_example/set_keyboard.dart';
import 'package:wayland_layer_shell_example/set_monitor.dart';
import 'package:wayland_layer_shell_example/set_anchors.dart';
import 'package:wayland_layer_shell_example/set_layer.dart';
import 'package:wayland_layer_shell_example/set_margins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final waylandLayerShellPlugin = WaylandLayerShell();
  bool isSupported = await waylandLayerShellPlugin.initialize(650, 600);
  if (!isSupported) {
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }
  await waylandLayerShellPlugin
      .setKeyboardMode(ShellKeyboardMode.keyboardModeExclusive);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wayland Layer Shell example'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SetMonitor(),
                  SizedBox(width: 40),
                  SetExclusiveZone(),
                ],
              ),
              SizedBox(height: 20),
              SetLayer(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SetKeyboard(),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      autofocus: true,
                      decoration:
                          InputDecoration(labelText: 'Test Keyboard Mode'),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SetAnchors(), SizedBox(width: 40), SetMargins()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
