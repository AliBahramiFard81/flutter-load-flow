import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/cubit/bus_data_update_cubit.dart';
import 'package:main/models/bus_info_model.dart';
import 'package:sizer/sizer.dart';

class SlackBusInfoDialog extends StatefulWidget {
  final List<BusInfoModel> list;
  const SlackBusInfoDialog({
    super.key,
    required this.list,
  });

  @override
  State<SlackBusInfoDialog> createState() => _SlackBusInfoDialogState();
}

class _SlackBusInfoDialogState extends State<SlackBusInfoDialog> {
  double voltage = 0.0;
  double angle = 0.0;
  double activePower = 0.0;
  double reactivePower = 0.0;

  @override
  Widget build(BuildContext context) {
    voltage = widget.list.elementAt(0).voltage;
    angle = widget.list.elementAt(0).angle;
    activePower = widget.list.elementAt(0).activePower;
    reactivePower = widget.list.elementAt(0).reactivePower;
    return ContentDialog(
      title: const Text('Edit Bus 1'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the values in PU',
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Voltage'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: voltage,
                        smallChange: 0.1,
                        min: -100.0,
                        max: 100.0,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          voltage = value ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Angle'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: angle,
                        smallChange: 0.1,
                        min: -100.0,
                        max: 100.0,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          angle = value ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active Power'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: activePower,
                        smallChange: 0.1,
                        min: -100.0,
                        max: 100.0,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          activePower = value ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reactive Power'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: reactivePower,
                        smallChange: 0.1,
                        min: -100.0,
                        max: 100.0,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          reactivePower = value ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.pop(context);

            BlocProvider.of<BusDataUpdateCubit>(context).updateBusData(
              voltage,
              angle,
              activePower,
              reactivePower,
              widget.list,
              0,
              2.0,
            );
          },
        ),
      ],
    );
  }
}
