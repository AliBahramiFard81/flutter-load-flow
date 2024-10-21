import 'package:bloc/bloc.dart';
import 'package:main/models/bus_info_model.dart';
import 'package:meta/meta.dart';

part 'bus_data_update_state.dart';

class BusDataUpdateCubit extends Cubit<BusDataUpdateState> {
  BusDataUpdateCubit() : super(BusDataUpdateInitial());

  void updateBusData(double voltage, double angle, double activePower,
      double reactivePower, List<BusInfoModel> list, int index, double busType) {
    list[index] = BusInfoModel.fromJson(
      {
        'voltage': voltage,
        'angle': angle,
        'active power': activePower,
        'reactive power': reactivePower,
        'bus type': busType,
      },
    );
    return emit(
      BusDataUpdate(busInfoModel: list),
    );
  }

  void reset() {
    return emit(BusDataUpdateInitial());
  }
}
