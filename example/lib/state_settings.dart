import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f_link/f_link.dart';

/// The current Quantum setting to be used with [AblLink] and [SessionState] instances.
final quantumPrv = StateProvider<int>((ref) => 4);
