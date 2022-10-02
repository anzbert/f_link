import 'dart:async';
import 'package:f_link/f_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkPrv = Provider.autoDispose((_) => AblLink.create(120.0));

final quantum = StateProvider<int>((ref) => 4);

final pollAppState = StateProvider<int>((ref) => 66);
final pollNumPeers = StateProvider<int>((ref) => 500);
// final pollAudioState = StateProvider<int>((ref) => 0);

final appSessStream = StreamProvider.autoDispose<SessionState>((ref) async* {
  if (ref.watch(pollAppState) != 0) {
    final ticker =
        Stream<void>.periodic(Duration(milliseconds: ref.watch(pollAppState)));
    SessionState current = SessionState.create();

    await for (void _ in ticker) {
      if (ref.read(linkPrv).isEnabled()) {
        ref.read(linkPrv).captureAppSessionState(current);
        yield current;
      }
    }
  }
});

final numPeersStream = StreamProvider.autoDispose<int>(
  (ref) async* {
    if (ref.watch(pollNumPeers) != 0) {
      final ticker = Stream<void>.periodic(
          Duration(milliseconds: ref.watch(pollNumPeers)));
      int buffer = 0;

      await for (void _ in ticker) {
        if (ref.read(linkPrv).isEnabled()) {
          int numPeers = ref.read(linkPrv).numPeers();
          if (numPeers != buffer) {
            buffer = numPeers;
            yield numPeers;
          }
        }
      }
    }
  },
);

// move to other isolate?
// final audioSessStream = StreamProvider.autoDispose<SessionState>(
//   (ref) async* {
//     if (ref.watch(pollAudioState) != 0) {
//       final ticker = Stream<void>.periodic(
//           Duration(milliseconds: ref.watch(pollAudioState)));
//       SessionState current = SessionState.create();

//       await for (void _ in ticker) {
//         if (ref.read(linkPrv).isEnabled()) {
//           ref.read(linkPrv).captureAudioSessionState(current);
//           yield current;
//         }
//       }
//     }
//   },
// );