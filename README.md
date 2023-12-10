# wayland_layer_shell

This plugin exposes the `zwlr_layer_shell_v1` protocol using the [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) library, enabling the creation of desktop components such as panels, taskbars, application launchers, etc. with Flutter on Wayland systems.

## Supported Compositors

This plugin exclusively functions on Wayland and is compatible only with Wayland compositors that support the `zwlr_layer_shell_v1` protocol. The Layer Shell protocol is supported on:

- wlroots-based compositors (such as Sway, Hyprland, etc.)
- KDE Plasma on Wayland
- Mir-based compositors (some may not enable the protocol by default and require `--add-wayland-extension zwlr_layer_shell_v1`)

Layer Shell is not supported on:

- Gnome-on-Wayland
- Any X11 desktop

## Getting Started

Using the gtk header bar and displaying the gtk window before initializing the layer surface prevents the initialization of the layer surface, hence some changes are required in Flutter's gtk window initialization code.

Update the file `linux/my_application.cc` as follows:

```diff
...

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {

  ...

- gboolean use_header_bar = TRUE;
+ gboolean use_header_bar = FALSE;

  ...
  
  gtk_window_set_default_size(window, 1280, 720);
- gtk_widget_show(GTK_WIDGET(window));
+ gtk_widget_realize(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();

...

```

## Dependencies

This plugin relies on the [gtk-layer-shell-0](https://github.com/wmww/gtk-layer-shell/tree/master) library. Ensure that it is available on the platforms where apps using this plugin are installed. The library can be found in the repositories of major distributions: [Distro packages](https://github.com/wmww/gtk-layer-shell?tab=readme-ov-file#distro-packages)

## Usage

For usage check out the example app inside `example` folder.