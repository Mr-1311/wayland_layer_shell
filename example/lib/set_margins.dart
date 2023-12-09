import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class SetMargins extends StatefulWidget {
  const SetMargins({super.key});

  @override
  State<SetMargins> createState() => _SetMarginsState();
}

class _SetMarginsState extends State<SetMargins> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Text('Set Margins'),
              TextField(
                onSubmitted: (value) =>
                    _onMarginChanged(value, ShellEdge.edgeTop),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(labelText: 'Top'),
              ),
              TextField(
                onSubmitted: (value) =>
                    _onMarginChanged(value, ShellEdge.edgeLeft),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(labelText: 'Left'),
              ),
              TextField(
                onSubmitted: (value) =>
                    _onMarginChanged(value, ShellEdge.edgeRight),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(labelText: 'Right'),
              ),
              TextField(
                onSubmitted: (value) =>
                    _onMarginChanged(value, ShellEdge.edgeBottom),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(labelText: 'Bottom'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onMarginChanged(String value, ShellEdge edge) async {
    final waylandLayerShellPlugin = WaylandLayerShell();
    waylandLayerShellPlugin.setMargin(edge, int.parse(value));
    int margin = await waylandLayerShellPlugin.getMargin(edge);
    print('Margin setted to $edge: $margin');
  }
}
