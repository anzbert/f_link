import 'package:flutter/foundation.dart';

/// Print only in debug mode
logd(dynamic object) {
  if (kDebugMode) print(object.toString());
}
