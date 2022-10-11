import 'package:f_link/f_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AblLink instance, created within a Provider at the start of the App.
///
/// Note: Changes in the contained native C++ Link Object will not trigger a rebuild of this Provider.
final linkPrv = Provider<AblLink>((_) => AblLink.create(100.0));

/// Quantum setting to be used with [linkPrv].
final quantumPrv = StateProvider<int>((ref) => 4);

/// Polling rate in milliseconds of the [linkPrv] for changes in the number of
/// currently connected peers. Used by [numPeersStreamPrv].
final pollingRateNumPeersPrv = StateProvider<int>((ref) => 500);

/// Self-updating stream of the currently connected number of peers. The update frequency
/// is defined in the [pollingRateNumPeersPrv]
final numPeersStreamPrv = StreamProvider.autoDispose<int>(
  (ref) async* {
    final ticker = Stream<void>.periodic(
        Duration(milliseconds: ref.watch(pollingRateNumPeersPrv)));
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
