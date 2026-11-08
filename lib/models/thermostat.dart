import 'schedulable.dart';
import 'smart_device.dart';

class Thermostat extends SmartDevice with Schedulable {
  static const double minTemperature = 16;
  static const double maxTemperature = 30;
  static const double step = 0.5;

  double currentTemperature;
  double targetTemperature;

  Thermostat(
    super.name,
    super.room, {
    this.currentTemperature = 21,
    this.targetTemperature = 23,
    super.isOn,
  });

  Thermostat.eco(String name, String room)
      : this(
          name,
          room,
          currentTemperature: 22,
          targetTemperature: 19,
          isOn: true,
        );

  void setTargetTemperature(double targetTemperature) {
    this.targetTemperature =
        targetTemperature.clamp(minTemperature, maxTemperature).toDouble();
  }

  void increaseTemperature() => setTargetTemperature(targetTemperature + step);

  void decreaseTemperature() => setTargetTemperature(targetTemperature - step);

  String get mode {
    if (targetTemperature > currentTemperature) {
      return 'Heating';
    }
    if (targetTemperature < currentTemperature) {
      return 'Cooling';
    }
    return 'Holding';
  }

  @override
  DeviceType get type => DeviceType.thermostat;

  @override
  String get propertyLabel => 'Target';

  @override
  String get propertyValue => '${targetTemperature.toStringAsFixed(1)} °C';

  @override
  String getStatus() => isOn ? mode : 'Off';

  @override
  void performAction() => togglePower();

  @override
  String connectionInfo() =>
      '${super.connectionInfo()} • Room ${currentTemperature.toStringAsFixed(1)} °C';
}
