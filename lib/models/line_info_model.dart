class LineInfoModel {
  final int from;
  final int to;
  final double resistance;
  final double reactance;

  LineInfoModel({
    required this.from,
    required this.to,
    required this.resistance,
    required this.reactance,
  });

  factory LineInfoModel.fromJson(Map<String, double> information) {
    return LineInfoModel(
      from: information['from']!.toInt(),
      to: information['to']!.toInt(),
      resistance: information['resistance'] ?? 0.0,
      reactance: information['impedance'] ?? 0.0,
    );
  }
}
