part of 'update_min_max_icon_cubit.dart';

@immutable
sealed class UpdateMinMaxIconState {}

final class UpdateMinMaxIconInitial extends UpdateMinMaxIconState {}

final class UpdateMinMaxIcon extends UpdateMinMaxIconState {
  final bool isMaximized;
  UpdateMinMaxIcon({required this.isMaximized});
}
