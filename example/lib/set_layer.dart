import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class SetLayer extends StatefulWidget {
  const SetLayer({super.key});

  @override
  State<SetLayer> createState() => _SetLayerState();
}

class _SetLayerState extends State<SetLayer> {
  ShellLayer layer = ShellLayer.layerTop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Set Layer: ${layer.name}'),
        SegmentedButton(
          segments: const <ButtonSegment<ShellLayer>>[
            ButtonSegment<ShellLayer>(
              value: ShellLayer.layerBackground,
              label: Text('Background'),
            ),
            ButtonSegment<ShellLayer>(
              value: ShellLayer.layerBottom,
              label: Text('Bottom'),
            ),
            ButtonSegment<ShellLayer>(
              value: ShellLayer.layerTop,
              label: Text('Top'),
            ),
            ButtonSegment<ShellLayer>(
              value: ShellLayer.layerOverlay,
              label: Text('Overlay'),
            ),
          ],
          selected: <ShellLayer>{layer},
          onSelectionChanged: (val) => _onSelectionChanged(val),
        ),
      ],
    );
  }

  _onSelectionChanged(Set<ShellLayer> layer) async {
    WaylandLayerShell waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.setLayer(layer.first);
    print('layer: ${await waylandLayerShellPlugin.getLayer()}');
    setState(() {
      this.layer = layer.first;
    });
  }
}
