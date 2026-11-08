import 'smart_device.dart';

class SmartSpeaker extends SmartDevice {
  static const int maxVolume = 100;

  int volume;
  bool isPlaying;
  String currentTrack;

  SmartSpeaker(
    super.name,
    super.room, {
    this.volume = 40,
    this.isPlaying = false,
    this.currentTrack = 'Morning Playlist',
    super.isOn,
  });

  SmartSpeaker.partyMode(String name, String room)
      : this(
          name,
          room,
          volume: 80,
          isPlaying: true,
          currentTrack: 'Party Mix',
          isOn: true,
        );

  void setVolume(int volume) {
    this.volume = volume.clamp(0, maxVolume).toInt();
  }

  void togglePlayback() {
    if (!isConnected) {
      return;
    }
    if (!isOn) {
      isOn = true;
    }
    isPlaying = !isPlaying;
  }

  @override
  void togglePower() {
    super.togglePower();
    if (!isOn) {
      isPlaying = false;
    }
  }

  @override
  void disconnect() {
    super.disconnect();
    isPlaying = false;
  }

  @override
  DeviceType get type => DeviceType.speaker;

  @override
  String get propertyLabel => 'Volume';

  @override
  String get propertyValue => '$volume%';

  @override
  String getStatus() {
    if (!isOn) {
      return 'Off';
    }
    return isPlaying ? 'Playing' : 'Paused';
  }

  @override
  void performAction() => togglePlayback();

  @override
  String connectionInfo() => '${super.connectionInfo()} • $currentTrack';
}
