import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';
import '../widgets/device_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<SmartDevice> _devices = [
    SmartLight('Living Room Light', 'Living Room', isOn: true),
    SmartLight.nightMode('Bedroom Lamp', 'Bedroom'),
    Thermostat('Main Thermostat', 'Hallway', isOn: true),
    Thermostat.eco('Office Thermostat', 'Office'),
    SmartSpeaker('Kitchen Speaker', 'Kitchen'),
    SmartSpeaker.partyMode('Party Speaker', 'Garden'),
  ];

  int get _activeCount => _devices.where((device) => device.isOn).length;

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _SummaryHeader(
            activeCount: _activeCount,
            deviceCount: _devices.length,
          ),
          const SizedBox(height: 12),
          for (final device in _devices)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DeviceCard(device: device, onChanged: _refresh),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          color: colorScheme.surfaceContainerHighest,
          child: Text(
            'Total devices created: ${SmartDevice.totalDevices}',
            key: const Key('totalDevicesText'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int activeCount;
  final int deviceCount;

  const _SummaryHeader({required this.activeCount, required this.deviceCount});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.home_rounded, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text('My Devices', style: textTheme.titleLarge),
        const Spacer(),
        Text('$activeCount / $deviceCount active', style: textTheme.bodyMedium),
      ],
    );
  }
}
