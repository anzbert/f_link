
// final pollingRateAudioState = StateProvider<int>((ref) => 0);


// move to other isolate?
// final audioStateStream = StreamProvider.autoDispose<SessionState>(
//   (ref) async* {
//     if (ref.watch(pollingRateAudioState) != 0) {
//       final ticker = Stream<void>.periodic(
//           Duration(milliseconds: ref.watch(pollingRateAudioState)));
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