import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wayland_layer_shell_platform_interface.dart';

/// An implementation of [WaylandLayerShellPlatform] that uses method channels.
class MethodChannelWaylandLayerShell extends WaylandLayerShellPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wayland_layer_shell');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
