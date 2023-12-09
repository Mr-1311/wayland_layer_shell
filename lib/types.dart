enum ShellLayer {
  layerBackground, // The background layer.
  layerBottom, // The bottom layer.
  layerTop, // The top layer.
  layerOverlay, // The overlay layer.
  layerEntryNumber, // Should not be used except to get the number of entries. (NOTE: may change in
}

enum ShellEdge {
  edgeLeft, // The left edge of the screen.
  edgeRight, // The right edge of the screen.
  edgeTop, // The top edge of the screen.
  edgeBottom, // The bottom edge of the screen.
  edgeEntryNumber // Should not be used except to get the number of entries. (NOTE: may change in
}

enum ShellKeyboardMode {
  keyboardModeNone, // This window should not receive keyboard events.
  keyboardModeExclusive, // This window should have exclusive focus if it is on the top or overlay layer.
  keyboardModeOnDemand, // The user should be able to focus and unfocues this window in an implementation defined way.
  keyboardModeEntryNumber, // Should not be used except to get the number of entries.
}

class Monitor {
  final int id;
  final String name;

  Monitor(this.id, this.name);

  @override
  String toString() {
    return '$id: $name';
  }
}
