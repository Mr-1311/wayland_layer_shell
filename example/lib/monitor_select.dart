import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class MonitorSelect extends StatefulWidget {
  const MonitorSelect({super.key});

  @override
  State<MonitorSelect> createState() => _MonitorSelectState();
}

class _MonitorSelectState extends State<MonitorSelect> {
  List<Monitor> items = [];
  final _waylandLayerShellPlugin = WaylandLayerShell();

  @override
  void initState() {
    super.initState();
    setItems();
  }

  Future<void> setItems() async {
    final mons = await _waylandLayerShellPlugin.getMonitorList();
    setState(() {
      items = mons;
    });
  }

  setMonitor(int id) {
    if (id == -1) {
      _waylandLayerShellPlugin.setMonitor(null);
      return;
    }
    _waylandLayerShellPlugin.setMonitor(items.firstWhere((m) => m.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        onSelected: (value) => setMonitor(int.parse(value!)),
        initialSelection: '-1',
        dropdownMenuEntries: items.map<DropdownMenuEntry<String>>((mon) {
          return DropdownMenuEntry(
              value: mon.id.toString(), label: mon.toString());
        }).toList()
          ..add(const DropdownMenuEntry(value: '-1', label: 'default')));
  }
}
