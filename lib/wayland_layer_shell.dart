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

  ///Returns: the current layer as [ShellLayer].
  Future<ShellLayer> getLayer() async {
    return ShellLayer
        .values[(await methodChannel.invokeMethod('getLayer')) as int];
  }

  /*
/**
 * gtk_layer_set_monitor:
 * @window: A layer surface.
 * @monitor: The output this layer surface will be placed on (%NULL to let the compositor decide).
 *
 * Set the output for the window to be placed on, or %NULL to let the compositor choose.
 * If the window is currently mapped, it will get remapped so the change can take effect.
 *
 * Default is %NULL
 */
void gtk_layer_set_monitor (GtkWindow *window, GdkMonitor *monitor);

/**
 * gtk_layer_get_monitor:
 * @window: A layer surface.
 *
 * NOTE: To get which monitor the surface is actually on, use
 * gdk_display_get_monitor_at_window().
 *
 * Returns: (transfer none): the monitor this surface will/has requested to be on, can be %NULL.
 *
 * Since: 0.5
 */
GdkMonitor *gtk_layer_get_monitor (GtkWindow *window);

/**
 * gtk_layer_set_anchor:
 * @window: A layer surface.
 * @edge: A #GtkLayerShellEdge this layer surface may be anchored to.
 * @anchor_to_edge: Whether or not to anchor this layer surface to @edge.
 *
 * Set whether @window should be anchored to @edge.
 * - If two perpendicular edges are anchored, the surface with be anchored to that corner
 * - If two opposite edges are anchored, the window will be stretched across the screen in that direction
 *
 * Default is %FALSE for each #GtkLayerShellEdge
 */
void gtk_layer_set_anchor (GtkWindow *window, GtkLayerShellEdge edge, gboolean anchor_to_edge);

/**
 * gtk_layer_get_anchor:
 * @window: A layer surface.
 *
 * Returns: if this surface is anchored to the given edge.
 *
 * Since: 0.5
 */
gboolean gtk_layer_get_anchor (GtkWindow *window, GtkLayerShellEdge edge);

/**
 * gtk_layer_set_margin:
 * @window: A layer surface.
 * @edge: The #GtkLayerShellEdge for which to set the margin.
 * @margin_size: The margin for @edge to be set.
 *
 * Set the margin for a specific @edge of a @window. Effects both surface's distance from
 * the edge and its exclusive zone size (if auto exclusive zone enabled).
 *
 * Default is 0 for each #GtkLayerShellEdge
 */
void gtk_layer_set_margin (GtkWindow *window, GtkLayerShellEdge edge, int margin_size);

/**
 * gtk_layer_get_margin:
 * @window: A layer surface.
 *
 * Returns: the size of the margin for the given edge.
 *
 * Since: 0.5
 */
int gtk_layer_get_margin (GtkWindow *window, GtkLayerShellEdge edge);

/**
 * gtk_layer_set_exclusive_zone:
 * @window: A layer surface.
 * @exclusive_zone: The size of the exclusive zone.
 *
 * Has no effect unless the surface is anchored to an edge. Requests that the compositor
 * does not place other surfaces within the given exclusive zone of the anchored edge.
 * For example, a panel can request to not be covered by maximized windows. See
 * wlr-layer-shell-unstable-v1.xml for details.
 *
 * Default is 0
 */
void gtk_layer_set_exclusive_zone (GtkWindow *window, int exclusive_zone);

/**
 * gtk_layer_get_exclusive_zone:
 * @window: A layer surface.
 *
 * Returns: the window's exclusive zone (which may have been set manually or automatically)
 *
 * Since: 0.5
 */
int gtk_layer_get_exclusive_zone (GtkWindow *window);

/**
 * gtk_layer_auto_exclusive_zone_enable:
 * @window: A layer surface.
 *
 * When auto exclusive zone is enabled, exclusive zone is automatically set to the
 * size of the @window + relevant margin. To disable auto exclusive zone, just set the
 * exclusive zone to 0 or any other fixed value.
 *
 * NOTE: you can control the auto exclusive zone by changing the margin on the non-anchored
 * edge. This behavior is specific to gtk-layer-shell and not part of the underlying protocol
 */
void gtk_layer_auto_exclusive_zone_enable (GtkWindow *window);

/**
 * gtk_layer_auto_exclusive_zone_is_enabled:
 * @window: A layer surface.
 *
 * Returns: if the surface's exclusive zone is set to change based on the window's size
 *
 * Since: 0.5
 */
gboolean gtk_layer_auto_exclusive_zone_is_enabled (GtkWindow *window);

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
