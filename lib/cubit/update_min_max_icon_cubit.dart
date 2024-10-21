import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:window_manager/window_manager.dart';

part 'update_min_max_icon_state.dart';

class UpdateMinMaxIconCubit extends Cubit<UpdateMinMaxIconState> {
  UpdateMinMaxIconCubit() : super(UpdateMinMaxIconInitial());

  void updateIcon() async {
    bool isMaximized = await windowManager.isMaximized();
    return emit(UpdateMinMaxIcon(isMaximized: isMaximized));
  }
}
