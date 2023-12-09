import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class SetExclusiveZone extends StatefulWidget {
  const SetExclusiveZone({super.key});

  @override
  State<SetExclusiveZone> createState() => _SetExclusiveZoneState();
}

class _SetExclusiveZoneState extends State<SetExclusiveZone> {
  bool isExculiveZone = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Exclusive Zone'),
        Switch(
            value: isExculiveZone,
            onChanged: (val) => _onSelectionChanged(val)),
      ],
    );
  }

  _onSelectionChanged(bool val) async {
    WaylandLayerShell waylandLayerShellPlugin = WaylandLayerShell();
    if (val == true) {
      await waylandLayerShellPlugin.enableAutoExclusiveZone();
      // exclusive zone can be set to any fixed value too.
      // await waylandLayerShellPlugin.setExclusiveZone(200);
    } else {
      await waylandLayerShellPlugin.setExclusiveZone(0);
    }

    print('exculive zone: ${await waylandLayerShellPlugin.getExclusiveZone()}');
    print(
        'isExculiveZoneEnabled : ${await waylandLayerShellPlugin.isAutoExclusiveZoneEnabled()}');

    setState(() {
      isExculiveZone = val;
    });
  }
}
