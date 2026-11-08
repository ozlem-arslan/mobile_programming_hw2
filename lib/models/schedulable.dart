mixin Schedulable {
  String? _scheduledTime;

  String? get scheduledTime => _scheduledTime;

  bool get hasSchedule => _scheduledTime != null;

  void setSchedule(String time) {
    _scheduledTime = time;
  }

  void clearSchedule() {
    _scheduledTime = null;
  }

  String scheduleSummary() =>
      hasSchedule ? 'Scheduled at $_scheduledTime' : 'No schedule';
}
