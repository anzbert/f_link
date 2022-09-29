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

const String _libName = 'abl_link';

/// The dynamic library in which the symbols for [FLinkBindings] can be found.
final DynamicLibrary _dylib = () {
  // if (Platform.isMacOS || Platform.isIOS) {
  //   return DynamicLibrary.open('$_libName.framework/$_libName');
  // }
  if (Platform.isLinux || Platform.isAndroid) {
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

  ///  Construct a new abl_link instance with an initial tempo.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  AblLink(double bpm) : _link = _bindings.abl_link_create(bpm);

  // /// Returns true if the Link Object has been disposed of in memory with [destroy]. A new instance can either be created by
  // /// instancing another [AblLink] or by calling [create] on the current instance.
  // bool isDestroyed() {
  //   return _link == null ? true : false;
  // }

  // ///  Construct a new abl_link instance with an initial tempo within this instance of AblLink.
  // ///
  // ///  Thread-safe: yes
  // ///
  // ///  Realtime-safe: no
  // void create(double bpm) {
  //   if (_link == null) {
  //     _link = _bindings.abl_link_create(bpm);
  //   } else {
  //     _bindings.abl_link_destroy(_link!);
  //     _link = null;
  //     _link = _bindings.abl_link_create(bpm);
  //   }
  // }

  /// Delete an abl_link instance.
  ///
  /// Thread-safe: yes
  ///
  /// Realtime-safe: no
  void destroy() {
    if (_link != null) {
      _bindings.abl_link_destroy(_link!);
      _link = null;
    }
  }

  ///  Is Link currently enabled?
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: yes
  bool isEnabled() {
    return _link == null ? false : _bindings.abl_link_is_enabled(_link!);
  }

  ///  Enable/disable Link.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  void enable(bool enable) {
    if (_link != null) _bindings.abl_link_enable(_link!, enable);
  }

  ///  Is start/stop synchronization enabled?
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  bool isStartStopSyncEnabled() {
    return _link == null
        ? false
        : _bindings.abl_link_is_start_stop_sync_enabled(_link!);
  }

  ///  Enable start/stop synchronization.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  void enableStartStopSync(bool enabled) {
    if (_link != null) {
      _bindings.abl_link_enable_start_stop_sync(_link!, enabled);
    }
  }

  ///  How many peers are currently connected in a Link session?
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: yes
  int numPeers() {
    return _link == null ? 0 : _bindings.abl_link_num_peers(_link!);
  }

  /// Get the current link clock time in microseconds.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: yes
  int clockMicros() {
    return _link == null ? 0 : _bindings.abl_link_clock_micros(_link!);
  }

  ///  Capture the current Link Session State from the audio thread.
  ///
  ///  Thread-safe: no
  ///
  ///  Realtime-safe: yes
  ///
  ///  This function should ONLY be called in the audio thread and must not be
  ///  accessed from any other threads. After capturing the session_state holds a snapshot
  ///  of the current Link Session State, so it should be used in a local scope. The
  ///  session_state should not be created on the audio thread.
  captureAudioSessionState(SessionState sessionState) {
    if (_link != null && sessionState._sessionState != null) {
      _bindings.abl_link_capture_audio_session_state(
          _link!, sessionState._sessionState!);
    }
  }

  /// Capture the current Link Session State from an application thread.
  ///
  ///  Thread-safe: no
  ///
  ///  Realtime-safe: yes
  ///
  ///  Provides a mechanism for capturing the Link Session State from an
  ///  application thread (other than the audio thread). After capturing the session_state
  ///  contains a snapshot of the current Link state, so it should be used in a local
  ///  scope.
  captureAppSessionState(SessionState sessionState) {
    if (_link != null && sessionState._sessionState != null) {
      _bindings.abl_link_capture_app_session_state(
          _link!, sessionState._sessionState!);
    }
  }

  ///  Commit the given Session State to the Link session from the audio thread.
  ///
  ///  Thread-safe: no
  ///
  ///  Realtime-safe: yes
  ///
  ///  This function should ONLY be called in the audio thread. The given
  ///  session_state will replace the current Link state. Modifications will be
  ///  communicated to other peers in the session.
  commitAudioSessionState(SessionState sessionState) {
    if (_link != null && sessionState._sessionState != null) {
      _bindings.abl_link_commit_audio_session_state(
          _link!, sessionState._sessionState!);
    }
  }

  ///  Commit the given Session State to the Link session from an application thread.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  ///
  ///  The given session_state will replace the current Link Session State.
  ///  Modifications of the Session State will be communicated to other peers in the
  ///  session.
  commitAppSessionState(SessionState sessionState) {
    if (_link != null && sessionState._sessionState != null) {
      _bindings.abl_link_commit_app_session_state(
          _link!, sessionState._sessionState!);
    }
  }

  ///  Register a callback to be notified when the number of
  ///  peers in the Link session changes.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  ///
  ///  The callback is invoked on a Link-managed thread.
  _setNumPeersCallback(Function callback) {}

  ///  Register a callback to be notified when the session tempo changes.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  ///
  ///  The callback is invoked on a Link-managed thread.
  _setTempoCallback(Function callback) {}

  ///  Register a callback to be notified when the state of start/stop isPlaying changes.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  ///
  ///  The callback is invoked on a Link-managed thread.
  _setStartStopCallback(Function callback) {}
}

///  The representation of the current local state of a client in a Link Session.
///
///  A session state represents a timeline and the start/stop
///  state. The timeline is a representation of a mapping between time and
///  beats for varying quanta. The start/stop state represents the user
///  intention to start or stop transport at a specific time. Start stop
///  synchronization is an optional feature that allows to share the user
///  request to start or stop transport between a subgroup of peers in a
///  Link session. When observing a change of start/stop state, audio
///  playback of a peer should be started or stopped the same way it would
///  have happened if the user had requested that change at the according
///  time locally. The start/stop state can only be changed by the user.
///  This means that the current local start/stop state persists when
///  joining or leaving a Link session. After joining a Link session
///  start/stop change requests will be communicated to all connected peers.
class SessionState {
  abl_link_session_state? _sessionState;

  /// Create a new session_state instance.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  ///
  ///  The session_state is to be used with the abl_link_capture... and
  ///  abl_link_commit... functions to capture snapshots of the current link state and pass
  ///  changes to the link session.
  SessionState() : _sessionState = _bindings.abl_link_create_session_state();

  /// Delete a session_state instance.
  ///
  ///  Thread-safe: yes
  ///
  ///  Realtime-safe: no
  void destroySessionState() {
    if (_sessionState != null) {
      _bindings.abl_link_destroy_session_state(_sessionState!);
      _sessionState = null;
    }
  }

  /// The tempo of the timeline, in Beats Per Minute.
  ///
  ///  This is a stable value that is appropriate for display to the user. Beat
  ///  time progress will not necessarily match this tempo exactly because of clock drift
  ///  compensation.
  double tempo() {
    return _sessionState == null
        ? 0.0
        : _bindings.abl_link_tempo(_sessionState!);
  }

  ///  Set the timeline tempo to the given bpm value, taking effect at the given time.
  void setTempo(double bpm, int atTime) {
    if (_sessionState != null) {
      _bindings.abl_link_set_tempo(_sessionState!, bpm, atTime);
    }
  }

  ///  Get the beat value corresponding to the given time for the given quantum.
  ///
  ///  The magnitude of the resulting beat value is unique to this Link
  ///  client, but its phase with respect to the provided quantum is shared among all
  ///  session peers. For non-negative beat values, the following property holds:
  ///  ```fmod(beatAtTime(t, q), q) == phaseAtTime(t, q)```
  double beatAtTime(int time, double quantum) {
    return _sessionState == null
        ? 0.0
        : _bindings.abl_link_beat_at_time(_sessionState!, time, quantum);
  }

  /// Get the session phase at the given time for the given quantum.
  ///
  ///  The result is in the interval ```[0, quantum]```. The result is equivalent to
  ///  ```fmod(beatAtTime(t, q), q)``` for non-negative beat values. This function is convenient
  ///  if the client application is only interested in the phase and not the beat
  ///  magnitude. Also, unlike fmod, it handles negative beat values correctly.
  double phaseAtTime(int time, double quantum) {
    return _sessionState == null
        ? 0.0
        : _bindings.abl_link_phase_at_time(_sessionState!, time, quantum);
  }

  ///  Get the time at which the given beat occurs for the given quantum.
  ///
  ///   The inverse of beatAtTime, assuming a constant tempo.
  ///  ```beatAtTime(timeAtBeat(b, q), q) === b```
  int timeAtBeat(double beat, double quantum) {
    return _sessionState == null
        ? 0
        : _bindings.abl_link_time_at_beat(_sessionState!, beat, quantum);
  }

  /// Attempt to map the given beat to the given time in the context of the given quantum.
  ///
  /// This function behaves differently depending on the state of the
  ///  session. If no other peers are connected, then this abl_link instance is in a
  ///  session by itself and is free to re-map the beat/time relationship whenever it
  ///  pleases. In this case, ```beatAtTime(time, quantum) == beat``` after this funtion has been
  ///  called.
  ///
  ///  If there are other peers in the session, this abl_link instance should not abruptly
  ///  re-map the beat/time relationship in the session because that would lead to beat
  ///  discontinuities among the other peers. In this case, the given beat will be mapped
  ///  to the next time value greater than the given time with the same phase as the given
  ///  beat.
  ///
  ///  This function is specifically designed to enable the concept of "quantized launch"
  ///  in client applications. If there are no other peers in the session, then an event
  ///  (such as starting transport) happens immediately when it is requested. If there are
  ///  other peers, however, we wait until the next time at which the session phase matches
  ///  the phase of the event, thereby executing the event in-phase with the other peers in
  ///  the session. The client application only needs to invoke this function to achieve
  ///  this behavior and should not need to explicitly check the number of peers.
  void requestBeatAtTime(double beat, int time, double quantum) {
    if (_sessionState != null) {
      _bindings.abl_link_request_beat_at_time(
          _sessionState!, beat, time, quantum);
    }
  }

  /// Rudely re-map the beat/time relationship for all peers in a session.
  ///
  ///  DANGER: This function should only be needed in certain special
  ///  circumstances. Most applications should not use it. It is very similar to
  ///  requestBeatAtTime except that it does not fall back to the quantizing behavior when
  ///  it is in a session with other peers. Calling this function will unconditionally map
  ///  the given beat to the given time and broadcast the result to the session. This is
  ///  very anti-social behavior and should be avoided.
  ///
  ///  One of the few legitimate uses of this function is to synchronize a Link session
  ///  with an external clock source. By periodically forcing the beat/time mapping
  ///  according to an external clock source, a peer can effectively bridge that clock into
  ///  a Link session. Much care must be taken at the application layer when implementing
  ///  such a feature so that users do not accidentally disrupt Link sessions that they may
  ///  join.
  void forceBeatAtTime(double beat, int time, double quantum) {
    if (_sessionState != null) {
      _bindings.abl_link_force_beat_at_time(
          _sessionState!, beat, time, quantum);
    }
  }

  /// Set if transport should be playing or stopped, taking effect at the given time.
  void setIsPlaying(bool isPlaying, int time) {
    if (_sessionState != null) {
      _bindings.abl_link_set_is_playing(_sessionState!, isPlaying, time);
    }
  }

  /// Is transport playing?
  bool isPlaying() {
    return _sessionState == null
        ? false
        : _bindings.abl_link_is_playing(_sessionState!);
  }

  /// Get the time at which a transport start/stop occurs
  int timeForisPlaying() {
    return _sessionState == null
        ? 0
        : _bindings.abl_link_time_for_is_playing(_sessionState!);
  }

  /// Convenience function to attempt to map the given beat to the time
  /// when transport is starting to play in context of the given quantum.
  /// This function evaluates to a no-op if abl_link_is_playing equals false.
  void requestBeatAtStartPlayingTime(double beat, double quantum) {
    if (_sessionState != null) {
      _bindings.abl_link_request_beat_at_start_playing_time(
          _sessionState!, beat, quantum);
    }
  }

  /// Convenience function to start or stop transport at a given time and attempt
  /// to map the given beat to this time in context of the given quantum.
  void setIsPlayingAndRequestBeatAtTime(
      bool isPlaying, int time, double beat, double quantum) {
    if (_sessionState != null) {
      _bindings.abl_link_set_is_playing_and_request_beat_at_time(
          _sessionState!, isPlaying, time, beat, quantum);
    }
  }
}
