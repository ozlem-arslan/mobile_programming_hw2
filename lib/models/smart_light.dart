import 'schedulable.dart';
import 'smart_device.dart';

class SmartLight extends SmartDevice with Schedulable {
  static const int minBrightness = 0;
  static const int maxBrightness = 100;

  int brightness;

  SmartLight(super.name, super.room, {this.brightness = 75, super.isOn});

  SmartLight.nightMode(String name, String room)
      : this(name, room, brightness: 20, isOn: true);

  void setBrightness(int brightness) {
    this.brightness = brightness.clamp(minBrightness, maxBrightness).toInt();
  }

  @override
  DeviceType get type => DeviceType.light;

  @override
  String get propertyLabel => 'Brightness';

  @override
  String get propertyValue => '$brightness%';

  @override
  String getStatus() => isOn ? 'On' : 'Off';

  @override
  void performAction() => togglePower();

  @override
  String connectionInfo() =>
      '${super.connectionInfo()} • ${hasSchedule ? 'Timer mode' : 'Manual mode'}';
}
