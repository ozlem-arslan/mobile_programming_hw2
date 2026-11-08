import 'package:flutter/material.dart';

import '../models/schedulable.dart';
import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';

class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onChanged;

  const DeviceCard({super.key, required this.device, required this.onChanged});

  static IconData iconFor(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb;
      case DeviceType.thermostat:
        return Icons.thermostat;
      case DeviceType.speaker:
        return Icons.speaker;
    }
  }

  static Color colorFor(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Colors.amber;
      case DeviceType.thermostat:
        return Colors.deepOrange;
      case DeviceType.speaker:
        return Colors.indigo;
    }
  }

  void _update(VoidCallback action) {
    action();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final accent = colorFor(device.type);
    final textTheme = Theme.of(context).textTheme;
    final enabled = device.isConnected;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: device.isOn ? accent : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  child: Icon(iconFor(device.type)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.name, style: textTheme.titleMedium),
                      Text(
                        '${device.room} • ${device.id}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: enabled ? 'Disconnect' : 'Connect',
                  icon: Icon(
                    enabled ? Icons.wifi : Icons.wifi_off,
                    color: enabled ? Colors.green : Colors.redAccent,
                  ),
                  onPressed: () => _update(
                    enabled ? device.disconnect : device.connect,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${device.propertyLabel}: ',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  device.propertyValue,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _StatusChip(label: device.getStatus(), active: device.isOn),
              ],
            ),
            const SizedBox(height: 4),
            Text(device.connectionInfo(), style: textTheme.bodySmall),
            const Divider(height: 24),
            _buildControls(context, accent, enabled),
            if (device is Schedulable)
              _ScheduleRow(
                schedulable: device as Schedulable,
                enabled: enabled,
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, Color accent, bool enabled) {
    final current = device;
    if (current is SmartLight) {
      return _LightControls(
        light: current,
        accent: accent,
        enabled: enabled,
        onUpdate: _update,
      );
    }
    if (current is Thermostat) {
      return _ThermostatControls(
        thermostat: current,
        accent: accent,
        enabled: enabled,
        onUpdate: _update,
      );
    }
    if (current is SmartSpeaker) {
      return _SpeakerControls(
        speaker: current,
        accent: accent,
        enabled: enabled,
        onUpdate: _update,
      );
    }
    return const SizedBox.shrink();
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool active;

  const _StatusChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: active
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LightControls extends StatelessWidget {
  final SmartLight light;
  final Color accent;
  final bool enabled;
  final void Function(VoidCallback action) onUpdate;

  const _LightControls({
    required this.light,
    required this.accent,
    required this.enabled,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: light.isOn,
          onChanged: enabled ? (_) => onUpdate(light.performAction) : null,
        ),
        const Icon(Icons.brightness_low, size: 20),
        Expanded(
          child: Slider(
            value: light.brightness.toDouble(),
            min: SmartLight.minBrightness.toDouble(),
            max: SmartLight.maxBrightness.toDouble(),
            divisions: 20,
            label: '${light.brightness}%',
            activeColor: accent,
            onChanged: enabled && light.isOn
                ? (value) => onUpdate(() => light.setBrightness(value.round()))
                : null,
          ),
        ),
        const Icon(Icons.brightness_high, size: 20),
      ],
    );
  }
}

class _ThermostatControls extends StatelessWidget {
  final Thermostat thermostat;
  final Color accent;
  final bool enabled;
  final void Function(VoidCallback action) onUpdate;

  const _ThermostatControls({
    required this.thermostat,
    required this.accent,
    required this.enabled,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final canAdjust = enabled && thermostat.isOn;

    return Row(
      children: [
        Switch(
          value: thermostat.isOn,
          onChanged: enabled ? (_) => onUpdate(thermostat.performAction) : null,
        ),
        const Spacer(),
        IconButton.filledTonal(
          tooltip: 'Decrease temperature',
          icon: const Icon(Icons.remove),
          onPressed: canAdjust &&
                  thermostat.targetTemperature > Thermostat.minTemperature
              ? () => onUpdate(thermostat.decreaseTemperature)
              : null,
        ),
        SizedBox(
          width: 90,
          child: Text(
            thermostat.propertyValue,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Increase temperature',
          icon: const Icon(Icons.add),
          onPressed: canAdjust &&
                  thermostat.targetTemperature < Thermostat.maxTemperature
              ? () => onUpdate(thermostat.increaseTemperature)
              : null,
        ),
      ],
    );
  }
}

class _SpeakerControls extends StatelessWidget {
  final SmartSpeaker speaker;
  final Color accent;
  final bool enabled;
  final void Function(VoidCallback action) onUpdate;

  const _SpeakerControls({
    required this.speaker,
    required this.accent,
    required this.enabled,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          tooltip: speaker.isPlaying ? 'Pause' : 'Play',
          style: IconButton.styleFrom(backgroundColor: accent),
          icon: Icon(speaker.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: enabled ? () => onUpdate(speaker.performAction) : null,
        ),
        const SizedBox(width: 8),
        const Icon(Icons.volume_down, size: 20),
        Expanded(
          child: Slider(
            value: speaker.volume.toDouble(),
            min: 0,
            max: SmartSpeaker.maxVolume.toDouble(),
            divisions: 20,
            label: '${speaker.volume}%',
            activeColor: accent,
            onChanged: enabled && speaker.isOn
                ? (value) => onUpdate(() => speaker.setVolume(value.round()))
                : null,
          ),
        ),
        const Icon(Icons.volume_up, size: 20),
        IconButton(
          tooltip: speaker.isOn ? 'Turn off' : 'Turn on',
          icon: Icon(
            Icons.power_settings_new,
            color: speaker.isOn ? accent : Colors.grey,
          ),
          onPressed: enabled ? () => onUpdate(speaker.togglePower) : null,
        ),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final Schedulable schedulable;
  final bool enabled;
  final VoidCallback onChanged;

  const _ScheduleRow({
    required this.schedulable,
    required this.enabled,
    required this.onChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null || !context.mounted) {
      return;
    }
    schedulable.setSchedule(picked.format(context));
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(schedulable.scheduleSummary())),
          if (schedulable.hasSchedule)
            IconButton(
              tooltip: 'Clear schedule',
              icon: const Icon(Icons.close),
              onPressed: enabled
                  ? () {
                      schedulable.clearSchedule();
                      onChanged();
                    }
                  : null,
            ),
          TextButton(
            onPressed: enabled ? () => _pickTime(context) : null,
            child: Text(schedulable.hasSchedule ? 'Change' : 'Set'),
          ),
        ],
      ),
    );
  }
}
