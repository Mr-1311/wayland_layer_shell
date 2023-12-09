import 'package:flutter/services.dart';
import 'package:wayland_layer_shell/types.dart';

class WaylandLayerShell {
  final methodChannel = const MethodChannel('wayland_layer_shell');

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Returns: 'true' if the platform is Wayland and Wayland compositor supports the
  /// zwlr_layer_shell_v1 protocol. If not supported, returns 'false' and initialize
  /// gtk window as normal window
  Future<bool> isLayerShellSupported() async {
    return await methodChannel.invokeMethod('isSupported');
  }

  /// @width: The width of the surface. default is 1280
  /// @height: The height of the surface. default is 720
  ///
  /// Initialize the layer shell protocol.
  /// checks if the platform is Wayland and Wayland compositor supports the
  /// zwlr_layer_shell_v1 protocol so no need use isLayerShellSupported first.
  ///
  /// Returns: 'true' if platform is Wayland and Wayland compositor supports
  /// the zwlr_layer_shell_v1 protocol, if not supported, returns 'false' and initialize
  /// gtk window as normal window
  Future<bool> initialize([int? width, int? height]) async {
    final Map<String, dynamic> arguments = {
      'width': width ?? 1280,
      'height': height ?? 720,
    };
    return await methodChannel.invokeMethod('initialize', arguments);
  }

  /// @layer: The [ShellLayer] on which this surface appears.
  ///
  /// Set the "layer" on which the surface appears (controls if it is over top of or below other surfaces). The layer may
  /// be changed on-the-fly in the current version of the layer shell protocol, but on compositors that only support an
  /// older version the @window is remapped so the change can take effect.
  ///
  /// Default is %GTK_LAYER_SHELL_LAYER_TOP
  Future<void> setLayer(ShellLayer layer) async {
    final Map<String, dynamic> arguments = {
      'layer': layer.index,
    };
    await methodChannel.invokeMethod('setLayer', arguments);
  }

  /// Returns: the current layer as [ShellLayer].
  Future<ShellLayer> getLayer() async {
    return ShellLayer
        .values[(await methodChannel.invokeMethod('getLayer')) as int];
  }

  /// Returns: the list of all [Monitor]s connected to the computer.
  Future<List<Monitor>> getMonitorList() async {
    List<String> monitors =
        List<String>.from(await methodChannel.invokeMethod('getMonitorList'));
    return monitors.map((e) {
      final i = e.indexOf(':');
      return Monitor(int.parse(e.substring(0, i)), e.substring(i + 1));
    }).toList();
  }

  /// @monitor: The [Monitor] that this surface will be placed on.
  /// (null to let the compositor decide)
  ///
  /// Set the monitor this surface will be placed on.
  Future<void> setMonitor(Monitor? monitor) async {
    final Map<String, dynamic> arguments = {
      'id': monitor == null ? -1 : monitor.id,
    };
    await methodChannel.invokeMethod('setMonitor', arguments);
  }

  /// @edge: A [ShellEdge] this layer surface may be anchored to.
  /// @anchor_to_edge: Whether or not to anchor this layer surface to @edge.
  ///
  /// Set whether this layer surface should be anchored to @edge.
  /// - If two perpendicular edges are anchored, the surface with be anchored to that corner
  /// - If two opposite edges are anchored, the window will be stretched across the screen in that direction
  ///
  /// Default is %FALSE for each [ShellEdge]
  Future<void> setAnchor(ShellEdge edge, bool anchorToEdge) async {
    final Map<String, dynamic> arguments = {
      'edge': edge.index,
      'anchor_to_edge': anchorToEdge
    };
    await methodChannel.invokeMethod('setAnchor', arguments);
  }

  /// @edge: A [ShellEdge] this layer surface may be anchored to.
  ///
  /// Returns: if this surface is anchored to the given edge.
  Future<bool> getAnchor(ShellEdge edge) async {
    final Map<String, dynamic> arguments = {
      'edge': edge.index,
    };
    return await methodChannel.invokeMethod('getAnchor', arguments);
  }

  /// @edge: The [ShellEdge] for which to set the margin.
  /// @marginSize: The margin for @edge to be set.
  ///
  /// Set the margin for a specific @edge of a @window. Effects both surface's distance from
  /// the edge and its exclusive zone size (if auto exclusive zone enabled).
  ///
  /// Default is 0 for each [ShellEdge]
  Future<void> setMargin(ShellEdge edge, int marginSize) async {
    final Map<String, dynamic> arguments = {
      'edge': edge.index,
      'margin_size': marginSize
    };
    await methodChannel.invokeMethod('setMargin', arguments);
  }

  /// @edge: The [ShellEdge] for which to get the margin.
  ///
  /// Returns: the size of the margin for the given edge.
  Future<int> getMargin(ShellEdge edge) async {
    final Map<String, dynamic> arguments = {
      'edge': edge.index,
    };
    return await methodChannel.invokeMethod('getMargin', arguments);
  }

  /// @exclusiveZone: The size of the exclusive zone.
  ///
  /// Set the size of the exclusive zone.
  ///
  /// Has no effect unless the surface is anchored to an edge. Requests that the compositor
  /// does not place other surfaces within the given exclusive zone of the anchored edge.
  /// For example, a panel can request to not be covered by maximized windows. See
  /// wlr-layer-shell-unstable-v1.xml for details.
  ///
  /// Default is 0
  Future<void> setExclusiveZone(int exclusiveZone) async {
    final Map<String, dynamic> arguments = {'exclusive_zone': exclusiveZone};
    await methodChannel.invokeMethod('setExclusiveZone', arguments);
  }

  /// Returns: the window's exclusive zone (which may have been set manually or automatically)
  Future<int> getExclusiveZone() async {
    return await methodChannel.invokeMethod('getExclusiveZone');
  }

  /// Enable auto exclusive zone
  ///
  /// When auto exclusive zone is enabled, exclusive zone is automatically set to the
  /// size of the @window + relevant margin. To disable auto exclusive zone, just set the
  /// exclusive zone to 0 or any other fixed value.
  Future<void> enableAutoExclusiveZone() async {
    await methodChannel.invokeMethod('enableAutoExclusiveZone');
  }

  /// Returns: if the surface's exclusive zone is set to change based on the window's size
  Future<bool> isAutoExclusiveZoneEnabled() async {
    return await methodChannel.invokeMethod('isAutoExclusiveZoneEnabled');
  }

  /*


/**
 * gtk_layer_set_keyboard_mode:
 * @window: A layer surface.
 * @mode: The type of keyboard interactivity requested.
 *
 * Sets if/when @window should receive keyboard events from the compositor, see
 * GtkLayerShellKeyboardMode for details.
 *
 * Default is %GTK_LAYER_SHELL_KEYBOARD_MODE_NONE
 *
 * Since: 0.6
 */
void gtk_layer_set_keyboard_mode (GtkWindow *window, GtkLayerShellKeyboardMode mode);

/**
 * gtk_layer_get_keyboard_mode:
 * @window: A layer surface.
 *
 * Returns: current keyboard interactivity mode for @window.
 *
 * Since: 0.6
 */
GtkLayerShellKeyboardMode gtk_layer_get_keyboard_mode (GtkWindow *window);

/**
 * gtk_layer_set_keyboard_interactivity:
 * @window: A layer surface.
 * @interactivity: Whether the layer surface should receive keyboard events.
 *
 * Whether the @window should receive keyboard events from the compositor.
 *
 * Default is %FALSE
 *
 * Deprecated: 0.6: Use gtk_layer_set_keyboard_mode () instead.
 */
void gtk_layer_set_keyboard_interactivity (GtkWindow *window, gboolean interactivity);

/**
 * gtk_layer_get_keyboard_interactivity:
 * @window: A layer surface.
 *
 * Returns: if keyboard interactivity is enabled
 *
 * Since: 0.5
 * Deprecated: 0.6: Use gtk_layer_get_keyboard_mode () instead.
 */
gboolean gtk_layer_get_keyboard_interactivity (GtkWindow *window);

    */
}
