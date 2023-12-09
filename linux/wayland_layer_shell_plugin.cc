#include "include/wayland_layer_shell/wayland_layer_shell_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "wayland_layer_shell_plugin_private.h"

#include <gtk-layer-shell/gtk-layer-shell.h>
#include "iostream"

#define WAYLAND_LAYER_SHELL_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), wayland_layer_shell_plugin_get_type(), \
                              WaylandLayerShellPlugin))

struct _WaylandLayerShellPlugin
{
  GObject parent_instance;
  FlPluginRegistrar *registrar;
};

G_DEFINE_TYPE(WaylandLayerShellPlugin, wayland_layer_shell_plugin, g_object_get_type())

GtkWindow *get_window(WaylandLayerShellPlugin *self)
{
  FlView *view = fl_plugin_registrar_get_view(self->registrar);
  if (view == nullptr)
    return nullptr;

  return GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

static FlMethodResponse *is_supported(WaylandLayerShellPlugin *self)
{
  if (gtk_layer_is_supported() == 0)
  {
    GtkWindow *gtk_window = get_window(self);
    gtk_widget_show(GTK_WIDGET(gtk_window));
  }
  g_autoptr(FlValue) result =
      fl_value_new_bool(gtk_layer_is_supported());
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *initialize(WaylandLayerShellPlugin *self, FlValue *args)
{
  g_autoptr(FlValue) result;
  GtkWindow *gtk_window = get_window(self);
  if (gtk_layer_is_supported() == 0)
  {
    result = fl_value_new_bool(false);
  }
  else
  {
    int width = fl_value_get_int(fl_value_lookup_string(args, "width"));
    int height = fl_value_get_int(fl_value_lookup_string(args, "height"));
    gtk_widget_set_size_request(GTK_WIDGET(gtk_window), width, height);
    gtk_layer_init_for_window(gtk_window);
    result = fl_value_new_bool(true);
  }

  gtk_widget_show(GTK_WIDGET(gtk_window));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *set_layer(WaylandLayerShellPlugin *self, FlValue *args)
{
  int layer = fl_value_get_int(fl_value_lookup_string(args, "layer"));
  gtk_layer_set_layer(get_window(self), static_cast<GtkLayerShellLayer>(layer));
  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *get_layer(WaylandLayerShellPlugin *self)
{
  g_autoptr(FlValue) result = fl_value_new_int(gtk_layer_get_layer(get_window(self)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *get_monitor_list(WaylandLayerShellPlugin *self)
{
  GdkDisplay *display = gdk_display_get_default();
  g_autoptr(FlValue) result = fl_value_new_list();
  for (int i = 0; i < gdk_display_get_n_monitors(display); i++)
  {
    GdkMonitor *monitor = gdk_display_get_monitor(display, i);
    gchar *val = g_strdup_printf("%i:%s", i, gdk_monitor_get_model(monitor));
    fl_value_append_take(result, fl_value_new_string(val));
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *set_monitor(WaylandLayerShellPlugin *self, FlValue *args)
{
  GdkDisplay *display = gdk_display_get_default();
  int id = fl_value_get_int(fl_value_lookup_string(args, "id"));

  if (id == -1)
  {
    gtk_layer_set_monitor(get_window(self), NULL);

    g_autoptr(FlValue) result = fl_value_new_bool(true);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  }

  GdkMonitor *monitor = gdk_display_get_monitor(display, id);
  gtk_layer_set_monitor(get_window(self), monitor);

  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *set_anchor(WaylandLayerShellPlugin *self, FlValue *args)
{
  int edge = fl_value_get_int(fl_value_lookup_string(args, "edge"));
  gboolean anchor_to_edge = fl_value_get_bool(fl_value_lookup_string(args, "anchor_to_edge"));

  gtk_layer_set_anchor(get_window(self), static_cast<GtkLayerShellEdge>(edge), anchor_to_edge);
  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *get_anchor(WaylandLayerShellPlugin *self, FlValue *args)
{
  int edge = fl_value_get_int(fl_value_lookup_string(args, "edge"));
  g_autoptr(FlValue) result = fl_value_new_bool(gtk_layer_get_anchor(get_window(self), static_cast<GtkLayerShellEdge>(edge)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *set_margin(WaylandLayerShellPlugin *self, FlValue *args)
{
  int edge = fl_value_get_int(fl_value_lookup_string(args, "edge"));
  int margin_size = fl_value_get_int(fl_value_lookup_string(args, "margin_size"));

  gtk_layer_set_margin(get_window(self), static_cast<GtkLayerShellEdge>(edge), margin_size);
  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *get_margin(WaylandLayerShellPlugin *self, FlValue *args)
{
  int edge = fl_value_get_int(fl_value_lookup_string(args, "edge"));
  g_autoptr(FlValue) result = fl_value_new_int(gtk_layer_get_margin(get_window(self), static_cast<GtkLayerShellEdge>(edge)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *set_exclusive_zone(WaylandLayerShellPlugin *self, FlValue *args)
{
  int exclusive_zone = fl_value_get_int(fl_value_lookup_string(args, "exclusive_zone"));
  gtk_layer_set_exclusive_zone(get_window(self), exclusive_zone);
  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *get_exclusive_zone(WaylandLayerShellPlugin *self)
{
  g_autoptr(FlValue) result = fl_value_new_int(gtk_layer_get_exclusive_zone(get_window(self)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *enable_auto_exclusive_zone(WaylandLayerShellPlugin *self)
{
  gtk_layer_auto_exclusive_zone_enable(get_window(self));
  g_autoptr(FlValue) result = fl_value_new_bool(true);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *is_auto_exclusive_zone_enabled(WaylandLayerShellPlugin *self)
{
  g_autoptr(FlValue) result = fl_value_new_bool(gtk_layer_auto_exclusive_zone_is_enabled(get_window(self)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Called when a method call is received from Flutter.
static void wayland_layer_shell_plugin_handle_method_call(
    WaylandLayerShellPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);

  if (strcmp(method, "getPlatformVersion") == 0)
  {
    response = get_platform_version();
  }
  else if (strcmp(method, "isSupported") == 0)
  {
    response = is_supported(self);
  }
  else if (strcmp(method, "initialize") == 0)
  {
    response = initialize(self, args);
  }
  else if (strcmp(method, "setLayer") == 0)
  {
    response = set_layer(self, args);
  }
  else if (strcmp(method, "getLayer") == 0)
  {
    response = get_layer(self);
  }
  else if (strcmp(method, "getMonitorList") == 0)
  {
    response = get_monitor_list(self);
  }
  else if (strcmp(method, "setMonitor") == 0)
  {
    response = set_monitor(self, args);
  }
  else if (strcmp(method, "setAnchor") == 0)
  {
    response = set_anchor(self, args);
  }
  else if (strcmp(method, "getAnchor") == 0)
  {
    response = get_anchor(self, args);
  }
  else if (strcmp(method, "setMargin") == 0)
  {
    response = set_margin(self, args);
  }
  else if (strcmp(method, "getMargin") == 0)
  {
    response = get_margin(self, args);
  }
  else if (strcmp(method, "setExclusiveZone") == 0)
  {
    response = set_exclusive_zone(self, args);
  }
  else if (strcmp(method, "getExclusiveZone") == 0)
  {
    response = get_exclusive_zone(self);
  }
  else if (strcmp(method, "enableAutoExclusiveZone") == 0)
  {
    response = enable_auto_exclusive_zone(self);
  }
  else if (strcmp(method, "isAutoExclusiveZoneEnabled") == 0)
  {
    response = is_auto_exclusive_zone_enabled(self);
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse *get_platform_version()
{
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void wayland_layer_shell_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(wayland_layer_shell_plugin_parent_class)->dispose(object);
}

static void wayland_layer_shell_plugin_class_init(WaylandLayerShellPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = wayland_layer_shell_plugin_dispose;
}

static void wayland_layer_shell_plugin_init(WaylandLayerShellPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  WaylandLayerShellPlugin *plugin = WAYLAND_LAYER_SHELL_PLUGIN(user_data);
  wayland_layer_shell_plugin_handle_method_call(plugin, method_call);
}

void wayland_layer_shell_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  WaylandLayerShellPlugin *plugin = WAYLAND_LAYER_SHELL_PLUGIN(
      g_object_new(wayland_layer_shell_plugin_get_type(), nullptr));

  plugin->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "wayland_layer_shell",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
