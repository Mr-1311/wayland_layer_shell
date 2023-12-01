import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wayland_layer_shell_method_channel.dart';

abstract class WaylandLayerShellPlatform extends PlatformInterface {
  /// Constructs a WaylandLayerShellPlatform.
  WaylandLayerShellPlatform() : super(token: _token);

  static final Object _token = Object();

  static WaylandLayerShellPlatform _instance = MethodChannelWaylandLayerShell();

  /// The default instance of [WaylandLayerShellPlatform] to use.
  ///
  /// Defaults to [MethodChannelWaylandLayerShell].
  static WaylandLayerShellPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WaylandLayerShellPlatform] when
  /// they register themselves.
  static set instance(WaylandLayerShellPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
