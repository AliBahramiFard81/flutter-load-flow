import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/cubit/bus_data_update_cubit.dart';
import 'package:main/models/bus_info_model.dart';
import 'package:sizer/sizer.dart';

class OtherBusesInfoDialog extends StatefulWidget {
  final List<BusInfoModel> list;
  final int index;
  const OtherBusesInfoDialog({
    super.key,
    required this.list,
    required this.index,
  });

  @override
  State<OtherBusesInfoDialog> createState() => _OtherBusesInfoDialogState();
}

class _OtherBusesInfoDialogState extends State<OtherBusesInfoDialog> {
  List<String> busType = ['PQ', 'PV'];
  String selectedBusType = 'PQ';

  double voltage = 0.0;
  double angle = 0.0;
  double activePower = 0.0;
  double reactivePower = 0.0;
  int busTypeInt = 0;

  @override
  void initState() {
    voltage = widget.list.elementAt(widget.index).voltage;
    angle = widget.list.elementAt(widget.index).angle;
    activePower = widget.list.elementAt(widget.index).activePower;
    reactivePower = widget.list.elementAt(widget.index).reactivePower;

    busTypeInt = widget.list.elementAt(widget.index).busType;

    if (busTypeInt == 0) {
      selectedBusType = 'PV';
    } else {
      selectedBusType = 'PQ';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('Edit Bus ${widget.index}'),
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
                        precision: 5,
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
                        precision: 5,
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
                        precision: 5,
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
                        precision: 5,
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
          ),
          Container(
            width: double.infinity,
            height: 0.3.w,
            margin: EdgeInsets.only(bottom: 2.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 109, 113, 119),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Row(
            children: [
              const Text('Bus type'),
              SizedBox(width: 2.w),
              ComboBox<String>(
                value: selectedBusType,
                placeholder: const Text('Select a bus type'),
                items: busType.map<ComboBoxItem<String>>((e) {
                  return ComboBoxItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      selectedBusType = value!;
                      if (value == 'PQ') {
                        busTypeInt = 1;
                      } else {
                        busTypeInt = 0;
                      }
                    },
                  );
                },
              )
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
              widget.index,
              busTypeInt.toDouble(),
            );
          },
        ),
      ],
    );
  }
}
