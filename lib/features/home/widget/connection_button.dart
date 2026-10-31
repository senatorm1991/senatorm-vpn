import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/router/bottom_sheets/bottom_sheets_notifier.dart';
import 'package:hiddify/core/router/dialog/dialog_notifier.dart';
import 'package:hiddify/features/connection/model/connection_failure.dart';
import 'package:hiddify/features/connection/model/connection_status.dart';
import 'package:hiddify/features/connection/notifier/connection_notifier.dart';
import 'package:hiddify/features/profile/notifier/active_profile_notifier.dart';
import 'package:hiddify/features/stats/notifier/stats_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// What the button shows, one value per look.
enum _Look { loading, disconnected, connecting, waiting, noProxies, connected, hotReloading, disconnecting, failed }

/// One look per status the core reports. The core decides when the tunnel is waiting for a ping
/// and when it is connected; the button only shows it.
///
/// The status reloads after every core start; until the new stream answers,
/// the last status holds. A failed start comes back as disconnected with the
/// failure attached.
///
/// A hot reload keeps the tunnel up and has a look of its own.
_Look _lookOf(AsyncValue<ConnectionStatus> status) => switch (status) {
  AsyncError() => _Look.failed,
  AsyncValue(valueOrNull: Disconnected(connectionFailure: _?)) => _Look.failed,
  AsyncValue(valueOrNull: Disconnected()) => _Look.disconnected,
  AsyncValue(valueOrNull: Connecting()) => _Look.connecting,
  AsyncValue(valueOrNull: Waiting()) => _Look.waiting,
  AsyncValue(valueOrNull: NoAvailableProxies()) => _Look.noProxies,
  AsyncValue(valueOrNull: HotReloading()) => _Look.hotReloading,
  AsyncValue(valueOrNull: Connected()) => _Look.connected,
  AsyncValue(valueOrNull: Disconnecting()) => _Look.disconnecting,
  _ => _Look.loading,
};

class ConnectionButton extends HookConsumerWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider).requireValue;
    final status = ref.watch(connectionNotifierProvider);
    final look = _held(_lookOf(status));

    final onTap = switch (status) {
      AsyncData(value: Disconnected()) || AsyncError() => () => _connect(ref),
      AsyncData(value: Connected() || Waiting() || NoAvailableProxies() || Connecting() || HotReloading()) =>
        () => ref.read(connectionNotifierProvider.notifier).toggleConnection(),
      _ => null,
    };

    final failure = switch (status) {
      AsyncError(:final ConnectionFailure error) => error,
      AsyncValue(valueOrNull: Disconnected(connectionFailure: final failure?)) => failure,
      _ => null,
    };
    final stats = ref.watch(statsNotifierProvider).valueOrNull;

    return _PowerButton(
      look: look,
      onTap: onTap,
      onErrorDetails: failure == null
          ? null
          : () => ref.read(dialogNotifierProvider.notifier).showCustomAlertFromErr(failure.present(t)),
      errorDetailsLabel: t.connection.errorDetails,
      download: stats?.downlink.toInt() ?? 0,
      upload: stats?.uplink.toInt() ?? 0,
      label: switch (look) {
        _Look.loading => "",
        _Look.disconnected => t.connection.tapToConnect,
        _Look.connecting => t.connection.connecting,
        _Look.waiting => t.connection.waiting,
        _Look.noProxies => t.connection.noAvailableProxies,
        _Look.connected => t.connection.connected,
        _Look.hotReloading => t.connection.hotReloading,
        _Look.disconnecting => t.connection.disconnecting,
        _Look.failed => t.connection.failed,
      },
      hint: look == _Look.failed ? t.connection.tapToRetry : null,
    );
  }

  /// Coming back from the background, the app sets the core up again, and for a moment the status
  /// can read as not connected though the tunnel never went down. So leaving connected for
  /// [_Look.loading] waits [_hold] before it shows, and nothing changes if
  /// connected is back by then.
  ///
  /// Intentional disconnect must not keep the Connected label: it goes through
  /// [_Look.disconnecting], and a bare Connected→Disconnected jump (no Stopping event) must
  /// also clear immediately — holding disconnected made disconnect feel multi-second slow.
  /// A failure is failed, so it still shows at once.
  _Look _held(_Look look) {
    final shown = useRef(look);
    final until = useRef<DateTime?>(null);
    final rebuild = useState(0);
    final steady = {_Look.connected, _Look.noProxies}.contains(shown.value);
    final blip = {_Look.loading}.contains(look);
    var result = look;
    if (steady && blip) {
      until.value ??= DateTime.now().add(_hold);
      if (DateTime.now().isBefore(until.value!)) {
        result = shown.value;
      } else {
        until.value = null;
      }
    } else {
      until.value = null;
    }
    shown.value = result;
    // shows the new look once the hold is over, if nothing else rebuilds the button first
    useEffect(() {
      final end = until.value;
      if (end == null) return null;
      final timer = Timer(end.difference(DateTime.now()), () => rebuild.value++);
      return timer.cancel;
    }, [until.value]);
    return result;
  }

  static const _hold = Duration(milliseconds: 1500);

  /// Connects, or sends the user to add a profile when there is none.
  Future<void> _connect(WidgetRef ref) async {
    final dialogs = ref.read(dialogNotifierProvider.notifier);
    if (ref.read(activeProfileProvider).valueOrNull == null) {
      await dialogs.showNoActiveProfile();
      ref.read(bottomSheetsNotifierProvider.notifier).showAddProfile();
      return;
    }
    if (await dialogs.showExperimentalFeatureNotice()) {
      await ref.read(connectionNotifierProvider.notifier).toggleConnection();
    }
  }
}


String _speed(int bytesPerSecond) {
  const units = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
  var v = bytesPerSecond.toDouble();
  var u = 0;
  while (v >= 1024 && u < units.length - 1) {
    v /= 1024;
    u++;
  }
  return '${v.toStringAsFixed(u == 0 ? 0 : 1)} ${units[u]}';
}

/// senatorm vpn's connect control: a plain ring when idle, a solid disc when connected.
class _PowerButton extends StatelessWidget {
  const _PowerButton({
    required this.look,
    required this.onTap,
    required this.onErrorDetails,
    required this.errorDetailsLabel,
    required this.download,
    required this.upload,
    required this.label,
    required this.hint,
  });

  final _Look look;
  final VoidCallback? onTap;
  final VoidCallback? onErrorDetails;
  final String errorDetailsLabel;
  final int download;
  final int upload;
  final String label;
  final String? hint;

  static const _outer = 196.0;
  static const _inner = 164.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final busy = look == _Look.connecting ||
        look == _Look.waiting ||
        look == _Look.hotReloading ||
        look == _Look.disconnecting ||
        look == _Look.loading;
    final on = look == _Look.connected || look == _Look.noProxies;
    final failed = look == _Look.failed;
    final fill = on ? scheme.primary : Colors.transparent;
    final fg = on ? scheme.onPrimary : (failed ? scheme.error : scheme.onSurface);
    final ring = failed ? scheme.error : scheme.onSurface;
    final icon = failed
        ? Icons.refresh_rounded
        : look == _Look.noProxies
            ? Icons.warning_amber_rounded
            : Icons.power_settings_new_rounded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          enabled: onTap != null,
          label: label,
          hint: hint,
          child: SizedBox.square(
            dimension: _outer,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: _outer,
                  height: _outer,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.outlineVariant, width: 1.5),
                  ),
                ),
                if (busy)
                  SizedBox.square(
                    dimension: _outer,
                    child: CircularProgressIndicator(strokeWidth: 3, color: scheme.onSurface),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  width: _inner,
                  height: _inner,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fill,
                    border: Border.all(color: ring, width: on ? 0 : 3),
                  ),
                  child: Material(
                    key: const ValueKey("home_connection_button"),
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onTap,
                      child: Center(child: Icon(icon, size: 64, color: fg)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(28),
        ExcludeSemantics(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              label,
              key: ValueKey(label),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (hint != null) ...[
          const Gap(4),
          Text(hint!, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        ],
        if (failed && onErrorDetails != null)
          TextButton(onPressed: onErrorDetails, child: Text(errorDetailsLabel)),
        const Gap(12),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: on ? 1 : 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.ltr,
            children: [
              Icon(Icons.arrow_downward_rounded, size: 18, color: scheme.onSurfaceVariant),
              const Gap(4),
              Text(_speed(download), style: theme.textTheme.bodyMedium),
              const Gap(20),
              Icon(Icons.arrow_upward_rounded, size: 18, color: scheme.onSurfaceVariant),
              const Gap(4),
              Text(_speed(upload), style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
