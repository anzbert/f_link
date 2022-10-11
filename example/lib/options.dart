import 'package:f_link/f_link.dart';
import 'package:f_link_example/int_selector.dart';
import 'package:f_link_example/state_app.dart';
import 'package:f_link_example/state_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsMenu extends ConsumerStatefulWidget {
  const OptionsMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends ConsumerState<OptionsMenu> {
  bool startStopSyncEnabled = false;

  @override
  Widget build(BuildContext context) {
    final link = ref.watch(linkPrv); // link will never trigger a rebuild

    final bool isPlaying = ref.watch(appStateStreamPrv
        .select((value) => value.valueOrNull?.isPlaying() ?? false));

    final int tempo = ref
        .watch(appStateStreamPrv
            .select((value) => value.valueOrNull?.tempo() ?? 120))
        .toInt();

    final int numPeers = ref.watch(numPeersStreamPrv).valueOrNull ?? 0;

    return ListView(
      children: [
        ListTile(
          title: const Text("Ableton Link enabled"),
          trailing: Switch(
            value: link.isEnabled(),
            onChanged: (bool newVal) {
              setState(() => ref.read(linkPrv).enable(newVal));
            },
          ),
        ),
        ListTile(
          title: const Text("Enable Start Stop Sync"),
          trailing: Switch(
            value: startStopSyncEnabled,
            onChanged: (bool newVal) {
              setState(() => startStopSyncEnabled = newVal);
              ref.read(linkPrv).enableStartStopSync(newVal);
            },
          ),
        ),
        const PhaseListTile(),
        const Metronome(),
        ListTile(
          title: const Text("Number of Peers"),
          trailing: Text(numPeers.toString()),
        ),
        IntSelectorTile(
          label: "Tempo",
          readValue: tempo,
          setValue: (int x) {
            if (x > 50 && x < 200) {
              SessionState state = link.captureAppSessionState();
              state.setTempo(x.toDouble(), link.clockMicros());
              link.commitAppSessionState(state);
            }
          },
        ),
        IntSelectorTile(
          label: "Quantum",
          readValue: ref.watch(quantumPrv),
          setValue: (int x) {
            if (x >= 1 && x <= 8) {
              ref.read(quantumPrv.notifier).state = x;
            }
          },
        ),
        ListTile(
          title: const Text("Playing"),
          trailing: Text(
            isPlaying.toString(),
          ),
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              enableFeedback: false, // mute click sound
            ),
            child: !isPlaying
                ? const Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.stop,
                    color: Colors.red,
                  ),
            onPressed: () {
              SessionState state = link.captureAppSessionState();
              state.setIsPlaying(!state.isPlaying(), link.clockMicros());
              link.commitAppSessionState(state);
            },
          ),
        )
      ],
    );
  }
}

class Metronome extends ConsumerWidget {
  const Metronome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int quantum = ref.watch(quantumPrv);
    final double phase = ref.watch(phasePrv);

    return ListTile(
      title: const Text("Metronome"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(quantum, (index) {
            return Icon(
              Icons.circle,
              color: index >= phase.ceil() ? Colors.grey : Colors.green,
            );
          }),
        ],
      ),
    );
  }
}

class PhaseListTile extends ConsumerWidget {
  const PhaseListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(builder: (context) {
      return ListTile(
        title: const Text("Phase"),
        trailing: Text(ref.watch(phasePrv).toStringAsFixed(2)),
      );
    });
  }
}
