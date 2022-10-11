import 'dart:async';
import 'package:f_link/f_link.dart';
import 'package:f_link_example/state_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Polling rate in milliseconds of [appStateStreamPrv].
final pollingRateAppStatePrv = StateProvider<int>((ref) => 66);

/// Self-updating stream of the current App [SessionState]. The update frequency
/// is defined in the [pollingRateAppStatePrv]
final appStateStreamPrv = StreamProvider.autoDispose<SessionState>(
  (ref) async* {
    final ticker = Stream<void>.periodic(
        Duration(milliseconds: ref.watch(pollingRateAppStatePrv)));
    SessionState current = SessionState.create();

    await for (void _ in ticker) {
      if (ref.read(linkPrv).isEnabled()) {
        // print("Capturing App sessionState...");
        ref.read(linkPrv).captureAppSessionState(current);
        yield current;
      }
    }
  },
);

/// Provides the current Phase based on the App State. The update frequency
/// is defined in the [pollingRateAppStatePrv]
final phasePrv = Provider.autoDispose<double>((ref) {
  final sesh = ref.watch(appStateStreamPrv).valueOrNull;
  if (sesh == null) return 0;

  return sesh.phaseAtTime(
    ref.watch(linkPrv).clockMicros(),
    ref.watch(quantumPrv).toDouble(),
  );
});
