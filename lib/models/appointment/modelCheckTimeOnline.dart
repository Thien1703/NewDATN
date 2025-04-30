class ModeltimecheckOnline {
  final Map<String, int> slots;

  ModeltimecheckOnline({required this.slots});

  factory ModeltimecheckOnline.fromJson(Map<String, dynamic> json) {
    return ModeltimecheckOnline(
      slots: Map<String, int>.from(json),
    );
  }
}
