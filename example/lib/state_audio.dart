// import 'package:f_link/f_link.dart';
// import 'package:f_link_example/state_link.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final pollingRateAudioState = StateProvider<int>((ref) => 20);

// // TODO : move audio to other isolate
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
