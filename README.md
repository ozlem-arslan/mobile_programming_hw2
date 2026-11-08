# Smart Home Controller

BIM493 Mobile Programming I – Assignment #2

## Group Members

- Özlem Arslan
- Sudenaz Genç

A Flutter application for viewing and controlling smart home devices.

## Features

- Device list with Smart Light, Thermostat and Smart Speaker cards
- Each card shows the device name, a main property (brightness, target temperature, volume) and the current status
- Controls: light on/off and brightness, thermostat power and temperature adjustment, speaker play/pause, volume and power
- Connect / disconnect each device
- Scheduling for lights and thermostats
- Total number of created devices shown at the bottom, read from a static variable

## Class Structure

| Concept | Implementation |
|---|---|
| Abstract class | `SmartDevice` with abstract `getStatus()` and `performAction()` |
| Inheritance | `SmartLight`, `Thermostat`, `SmartSpeaker` extend `SmartDevice` |
| Interface | `Connectable` implemented by the device classes |
| Mixin | `Schedulable` used by `SmartLight` and `Thermostat` |
| Constructors | Default constructors and named constructors `SmartLight.nightMode`, `Thermostat.eco`, `SmartSpeaker.partyMode` |
| `static` | `SmartDevice.totalDevices` counter and constant limits |
| `super` | Super constructor parameters, `super.togglePower()`, `super.disconnect()`, `super.connectionInfo()` |
| `this` | Field initialization and setters such as `this.brightness = ...` |

## Project Layout

```
lib/
  main.dart
  models/
    connectable.dart
    schedulable.dart
    smart_device.dart
    smart_light.dart
    thermostat.dart
    smart_speaker.dart
  screens/
    home_screen.dart
  widgets/
    device_card.dart
test/
  widget_test.dart
```

## Running

```bash
flutter pub get
flutter run
```
