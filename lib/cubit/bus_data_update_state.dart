part of 'bus_data_update_cubit.dart';

@immutable
sealed class BusDataUpdateState {}

final class BusDataUpdateInitial extends BusDataUpdateState {}

final class BusDataUpdate extends BusDataUpdateState {
  final List<BusInfoModel> busInfoModel;
  BusDataUpdate({required this.busInfoModel});
}
