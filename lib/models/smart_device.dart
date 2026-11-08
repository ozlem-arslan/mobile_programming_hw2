import 'connectable.dart';

enum DeviceType { light, thermostat, speaker }

abstract class SmartDevice implements Connectable {
  static int _totalDevices = 0;

  static int get totalDevices => _totalDevices;

  final String id;
  final String name;
  final String room;
  bool isOn;
  bool _connected = true;

  SmartDevice(this.name, this.room, {this.isOn = false})
      : id = 'SD-${(_totalDevices + 1).toString().padLeft(3, '0')}' {
    _totalDevices++;
  }

  DeviceType get type;

  String get propertyLabel;

  String get propertyValue;

  String getStatus();

  void performAction();

  void togglePower() {
    if (!_connected) {
      return;
    }
    isOn = !isOn;
  }

  @override
  bool get isConnected => _connected;

  @override
  void connect() {
    _connected = true;
  }

  @override
  void disconnect() {
    _connected = false;
    isOn = false;
  }

  @override
  String connectionInfo() => _connected ? 'Online' : 'Offline';

  @override
  String toString() => '$id $name ($room) - ${getStatus()}';
}
