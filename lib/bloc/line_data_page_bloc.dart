import 'package:bloc/bloc.dart';
import 'package:main/models/line_info_model.dart';
import 'package:meta/meta.dart';

part 'line_data_page_event.dart';
part 'line_data_page_state.dart';

class LineDataPageBloc extends Bloc<LineDataPageEvent, LineDataPageState> {
  LineDataPageBloc() : super(LineDataPageInitial()) {
    on<AddLineInformation>((event, emit) {
      final lineDataList = event.list;
      lineDataList.add(event.lineInfoModel);
      return emit(AddLineInformationSuccess(list: lineDataList));
    });
    on<DeleteAllLineInformation>((event, emit) {
      final lineDataList = event.list;
      lineDataList.clear();
      return emit(AddLineInformationSuccess(list: lineDataList));
    });
    on<DeleteLineInformation>((event, emit) {
      final lineDataList = event.list;
      lineDataList.removeAt(event.index);
      return emit(AddLineInformationSuccess(list: lineDataList));
    });
    on<LineInformationReset>((event, emit) {
      return emit(LineDataPageInitial());
    });
  }
}
