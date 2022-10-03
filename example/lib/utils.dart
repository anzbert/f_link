import 'package:flutter/foundation.dart';

/// Prints only in debug builds
logd(dynamic object) {
  if (kDebugMode) print(object.toString());
}
