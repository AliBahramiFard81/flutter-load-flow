part of 'bus_data_page_bloc.dart';

@immutable
sealed class BusDataPageEvent {}

final class BuildBussPage extends BusDataPageEvent {
  final int numOfBusses;
  BuildBussPage({required this.numOfBusses});
}

final class BuildBusPageReset extends BusDataPageEvent {}
