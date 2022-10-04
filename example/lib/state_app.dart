import 'dart:async';
import 'package:f_link/f_link.dart';
import 'package:f_link_example/state_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pollingRateAppState = StateProvider<int>((ref) => 66);

final appStateStream = StreamProvider.autoDispose<SessionState>(
  (ref) async* {
    if (ref.watch(pollingRateAppState) != 0) {
      final ticker = Stream<void>.periodic(
          Duration(milliseconds: ref.watch(pollingRateAppState)));
      SessionState current = SessionState.create();

      await for (void _ in ticker) {
        if (ref.read(linkPrv).isEnabled()) {
          // print("Capturing App sessionState...");
          ref.read(linkPrv).captureAppSessionState(current);
          yield current;
        }
      }
    }
  },
);

final phasePrv = Provider.autoDispose<double>((ref) {
  final sesh = ref.watch(appStateStream).valueOrNull;
  if (sesh == null) return 0;

  return sesh.phaseAtTime(
    ref.watch(linkPrv).clockMicros(),
    ref.watch(quantumPrv).toDouble(),
  );
});
