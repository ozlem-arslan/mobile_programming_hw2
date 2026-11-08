import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/models/smart_device.dart';
import 'package:smart_home_controller/models/smart_light.dart';
import 'package:smart_home_controller/models/smart_speaker.dart';
import 'package:smart_home_controller/models/thermostat.dart';

void main() {
  test('static counter increases for every created device', () {
    final before = SmartDevice.totalDevices;
    SmartLight('Test Light', 'Lab');
    Thermostat.eco('Test Thermostat', 'Lab');
    SmartSpeaker('Test Speaker', 'Lab');
    expect(SmartDevice.totalDevices, before + 3);
  });

  test('device actions change state', () {
    final light = SmartLight('Light', 'Room');
    light.performAction();
    expect(light.getStatus(), 'On');
    light.setBrightness(150);
    expect(light.brightness, SmartLight.maxBrightness);

    final thermostat = Thermostat('Thermostat', 'Room', isOn: true);
    thermostat.setTargetTemperature(10);
    expect(thermostat.targetTemperature, Thermostat.minTemperature);

    final speaker = SmartSpeaker.partyMode('Speaker', 'Room');
    expect(speaker.getStatus(), 'Playing');
    speaker.performAction();
    expect(speaker.getStatus(), 'Paused');
    speaker.disconnect();
    expect(speaker.isConnected, false);
    expect(speaker.getStatus(), 'Off');
  });

  testWidgets('home screen shows devices and total count', (tester) async {
    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('Smart Home Controller'), findsOneWidget);
    expect(find.text('Living Room Light'), findsOneWidget);
    expect(
      find.text('Total devices created: ${SmartDevice.totalDevices}'),
      findsOneWidget,
    );
  });

  testWidgets('device controls update the cards', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('19.0 °C'), findsWidgets);
    await tester.tap(find.byTooltip('Increase temperature').at(1));
    await tester.pump();
    expect(find.text('19.5 °C'), findsWidgets);

    expect(find.text('Playing'), findsOneWidget);
    await tester.tap(find.byTooltip('Play').first);
    await tester.pump();
    expect(find.text('Playing'), findsNWidgets(2));
    expect(find.text('6 / 6 active'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(find.text('5 / 6 active'), findsOneWidget);
  });
}
