class BusInfoModel {
  final double voltage;
  final double angle;
  final double activePower;
  final double reactivePower;
  final int busType;
  BusInfoModel({
    required this.voltage,
    required this.angle,
    required this.activePower,
    required this.reactivePower,
    required this.busType,
  });

  factory BusInfoModel.fromJson(Map<String, double> information) {
    return BusInfoModel(
      voltage: information['voltage'] ?? 0.0,
      angle: information['angle'] ?? 0.0,
      activePower: information['active power'] ?? 0.0,
      reactivePower: information['reactive power'] ?? 0.0,
      busType: information['bus type']!.toInt(),
    );
  }
}
