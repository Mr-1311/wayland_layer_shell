import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class SetAnchors extends StatefulWidget {
  const SetAnchors({super.key});

  @override
  State<SetAnchors> createState() => _SetAnchorsState();
}

class _SetAnchorsState extends State<SetAnchors> {
  bool isSelectedTop = false,
      isSelectedLeft = false,
      isSelectedRight = false,
      isSelectedBottom = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          IconButton.outlined(
              onPressed: () => _onPressed(ShellEdge.edgeTop),
              isSelected: isSelectedTop,
              icon: const Icon(Icons.arrow_upward)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton.outlined(
                  onPressed: () => _onPressed(ShellEdge.edgeLeft),
                  isSelected: isSelectedLeft,
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(
                width: 40,
                height: 40,
              ),
              IconButton.outlined(
                  onPressed: () => _onPressed(ShellEdge.edgeRight),
                  isSelected: isSelectedRight,
                  icon: const Icon(Icons.arrow_forward)),
            ],
          ),
          IconButton.outlined(
              onPressed: () => _onPressed(ShellEdge.edgeBottom),
              isSelected: isSelectedBottom,
              icon: const Icon(Icons.arrow_downward)),
        ],
      ),
    );
  }

  _onPressed(ShellEdge edge) async {
    final waylandLayerShellPlugin = WaylandLayerShell();
    bool getEdge = await waylandLayerShellPlugin.getAnchor(edge);
    await waylandLayerShellPlugin.setAnchor(edge, !getEdge);
    setState(() {
      switch (edge) {
        case ShellEdge.edgeTop:
          isSelectedTop = !getEdge;
          break;
        case ShellEdge.edgeLeft:
          isSelectedLeft = !getEdge;
          break;
        case ShellEdge.edgeRight:
          isSelectedRight = !getEdge;
          break;
        case ShellEdge.edgeBottom:
          isSelectedBottom = !getEdge;
          break;
        default:
          break;
      }
    });
  }
}
