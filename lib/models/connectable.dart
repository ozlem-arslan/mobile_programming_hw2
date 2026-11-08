abstract interface class Connectable {
  bool get isConnected;

  void connect();

  void disconnect();

  String connectionInfo();
}
