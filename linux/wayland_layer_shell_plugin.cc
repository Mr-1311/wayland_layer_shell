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
