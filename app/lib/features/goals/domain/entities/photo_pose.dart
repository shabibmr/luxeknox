enum PhotoPose {
  front,
  side,
  back;

  static PhotoPose fromWire(String? value) {
    return switch (value) {
      'side' => PhotoPose.side,
      'back' => PhotoPose.back,
      'front' => PhotoPose.front,
      _ => PhotoPose.front,
    };
  }

  String get wire => name;
}
