import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wayland_layer_shell/wayland_layer_shell.dart';
import 'package:wayland_layer_shell_example/monitor_select.dart';
import 'package:wayland_layer_shell_example/set_anchors.dart';
import 'package:wayland_layer_shell_example/set_layer.dart';
import 'package:wayland_layer_shell_example/set_margins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final waylandLayerShellPlugin = WaylandLayerShell();
  bool isSupported = await waylandLayerShellPlugin.initialize(600, 500);
  if (!isSupported) {
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }
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
              MonitorSelect(),
              SizedBox(height: 20),
              SetLayer(),
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
