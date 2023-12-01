
import 'wayland_layer_shell_platform_interface.dart';

class WaylandLayerShell {
  Future<String?> getPlatformVersion() {
    return WaylandLayerShellPlatform.instance.getPlatformVersion();
  }
}
