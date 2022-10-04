import 'package:f_link/f_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkPrv = Provider<AblLink>((ref) {
  return AblLink.create(100.0);
});

final quantumPrv = StateProvider<int>((ref) => 4);

final pollingRateNumPeers = StateProvider<int>((ref) => 500);

final numPeersStream = StreamProvider.autoDispose<int>(
  (ref) async* {
    final ticker = Stream<void>.periodic(
        Duration(milliseconds: ref.watch(pollingRateNumPeers)));
    int buffer = 0;

    await for (void _ in ticker) {
      if (ref.read(linkPrv).isEnabled()) {
        int numPeers = ref.read(linkPrv).numPeers();
        // print("Capturing numPeers: $numPeers");
        if (numPeers != buffer) {
          buffer = numPeers;
          yield numPeers;
        }
      }
    }
  },
);
