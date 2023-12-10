import 'package:flutter/material.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class SetKeyboard extends StatefulWidget {
  const SetKeyboard({super.key});

  @override
  State<SetKeyboard> createState() => _SetKeyboardState();
}

class _SetKeyboardState extends State<SetKeyboard> {
  ShellKeyboardMode kbMode = ShellKeyboardMode.keyboardModeNone;

  @override
  void initState() {
    super.initState();
    setCurrentKeyboardMode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Set Keyboard Mode: ${kbMode.name}'),
        SegmentedButton(
          segments: const <ButtonSegment<ShellKeyboardMode>>[
            ButtonSegment<ShellKeyboardMode>(
              value: ShellKeyboardMode.keyboardModeNone,
              label: Text('None'),
            ),
            ButtonSegment<ShellKeyboardMode>(
              value: ShellKeyboardMode.keyboardModeExclusive,
              label: Text('Exclusive'),
            ),
            ButtonSegment<ShellKeyboardMode>(
              value: ShellKeyboardMode.keyboardModeOnDemand,
              label: Text('OnDemand'),
            ),
          ],
          selected: {kbMode},
          onSelectionChanged: (val) => _onSelectionChanged(val),
        ),
      ],
    );
  }

  void _onSelectionChanged(Set<ShellKeyboardMode> kbMode) async {
    WaylandLayerShell waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.setKeyboardMode(kbMode.first);
    print('keyboard mode: ${await waylandLayerShellPlugin.getKeyboardMode()}');
    setState(() {
      this.kbMode = kbMode.first;
    });
  }

  void setCurrentKeyboardMode() async {
    WaylandLayerShell waylandLayerShellPlugin = WaylandLayerShell();
    final kbMode = await waylandLayerShellPlugin.getKeyboardMode();
    setState(() {
      this.kbMode = kbMode;
    });
  }
}
