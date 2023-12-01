import 'package:flutter_test/flutter_test.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';
import 'package:wayland_layer_shell/wayland_layer_shell_platform_interface.dart';
import 'package:wayland_layer_shell/wayland_layer_shell_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWaylandLayerShellPlatform
    with MockPlatformInterfaceMixin
    implements WaylandLayerShellPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WaylandLayerShellPlatform initialPlatform = WaylandLayerShellPlatform.instance;

  test('$MethodChannelWaylandLayerShell is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWaylandLayerShell>());
  });

  test('getPlatformVersion', () async {
    WaylandLayerShell waylandLayerShellPlugin = WaylandLayerShell();
    MockWaylandLayerShellPlatform fakePlatform = MockWaylandLayerShellPlatform();
    WaylandLayerShellPlatform.instance = fakePlatform;

    expect(await waylandLayerShellPlugin.getPlatformVersion(), '42');
  });
}
