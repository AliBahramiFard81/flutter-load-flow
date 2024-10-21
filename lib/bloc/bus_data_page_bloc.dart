import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bus_data_page_event.dart';
part 'bus_data_page_state.dart';

class BusDataPageBloc extends Bloc<BusDataPageEvent, BusDataPageState> {
  BusDataPageBloc() : super(BusDataPageInitial()) {
    on<BuildBussPage>((event, emit) {
      emit(BusDataPageLoading());
      return emit(BusDataPageSuccess(numOfBusses: event.numOfBusses));
    });
    on<BuildBusPageReset>((event, emit) {
      return emit(BusDataPageInitial());
    });
  }
}
