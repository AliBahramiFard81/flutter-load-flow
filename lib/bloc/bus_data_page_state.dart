part of 'bus_data_page_bloc.dart';

@immutable
sealed class BusDataPageState {}

final class BusDataPageInitial extends BusDataPageState {}

final class BusDataPageSuccess extends BusDataPageState {
  final int numOfBusses;
  BusDataPageSuccess({required this.numOfBusses});
}

final class BusDataPageFailed extends BusDataPageState {}

final class BusDataPageLoading extends BusDataPageState {}
