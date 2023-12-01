import 'package:flutter/services.dart';

class WaylandLayerShell {
  final methodChannel = const MethodChannel('wayland_layer_shell');

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<bool> isLayerShellSupported() async {
    return await methodChannel.invokeMethod('isSupported');
  }

  Future<bool> initialize([int? width, int? height]) async {
    final Map<String, dynamic> arguments = {
      'width': width ?? 1280,
      'height': height ?? 720,
    };
    return await methodChannel.invokeMethod('initialize', arguments);
  }
}
