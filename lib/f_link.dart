import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'f_link_bindings_generated.dart';

// ///////////////////////////////////////////////////////////////////////////
// UTILS:

/// Prints only in debug builds
logd(dynamic text) {
  if (kDebugMode) print(text.toString());
}

// ///////////////////////////////////////////////////////////////////////////
// IMPORT LIB AND BINDINGS:

const String _libName = 'f_link';

/// The dynamic library in which the symbols for [FLinkBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FLinkBindings _bindings = FLinkBindings(_dylib);

// ///////////////////////////////////////////////////////////////////////////
// WRAPPER:

/// The representation of an abl_link instance.
class AblLink {
  abl_link? _link;

  AblLink(double bpm) : _link = _bindings.abl_link_create(bpm);

  bool isNull() {
    return _link == null ? true : false;
  }

  create(double bpm) {
    if (_link == null) {
      _link = _bindings.abl_link_create(bpm);
    } else {
      logd("AblLink already created");
    }
  }

  destroy() {
    if (_link != null) {
      _bindings.abl_link_destroy(_link!);
      _link = null;
    } else {
      logd("AblLink already destroyed");
    }
  }

  enable(bool enable) {
    if (_link != null) _bindings.abl_link_enable(_link!, enable);
  }
}

class SessionState {
  abl_link_session_state? _sessionState;

  SessionState() : _sessionState = _bindings.abl_link_create_session_state();
}
