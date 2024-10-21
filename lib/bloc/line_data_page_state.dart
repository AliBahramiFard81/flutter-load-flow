part of 'line_data_page_bloc.dart';

@immutable
sealed class LineDataPageState {}

final class LineDataPageInitial extends LineDataPageState {}

final class AddLineInformationSuccess extends LineDataPageState {
  final List<LineInfoModel> list;
  AddLineInformationSuccess({required this.list});
}
