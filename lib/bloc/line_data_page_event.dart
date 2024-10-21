part of 'line_data_page_bloc.dart';

@immutable
sealed class LineDataPageEvent {}

final class AddLineInformation extends LineDataPageEvent {
  final List<LineInfoModel> list;
  final LineInfoModel lineInfoModel;
  AddLineInformation({
    required this.lineInfoModel,
    required this.list,
  });
}

final class DeleteLineInformation extends LineDataPageEvent {
  final List<LineInfoModel> list;
  final int index;
  DeleteLineInformation({
    required this.index,
    required this.list,
  });
}

final class DeleteAllLineInformation extends LineDataPageEvent {
  final List<LineInfoModel> list;
  DeleteAllLineInformation({
    required this.list,
  });
}

final class LineInformationReset extends LineDataPageEvent {}
