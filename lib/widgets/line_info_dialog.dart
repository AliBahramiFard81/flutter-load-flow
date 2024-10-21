import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/bloc/line_data_page_bloc.dart';
import 'package:main/models/line_info_model.dart';
import 'package:sizer/sizer.dart';

class AddLineInfoDialog extends StatefulWidget {
  final List<LineInfoModel> list;
  final int numberOfBuses;
  const AddLineInfoDialog({
    super.key,
    required this.list,
    required this.numberOfBuses,
  });

  @override
  State<AddLineInfoDialog> createState() => _AddLineInfoDialogState();
}

class _AddLineInfoDialogState extends State<AddLineInfoDialog> {
  int from = 1;
  int to = 2;
  double resistance = 0.0;
  double reactance = 0.0;

  @override
  Widget build(BuildContext context) {
    /*
    from = widget.list.elementAt(widget.index).from;
    to = widget.list.elementAt(widget.index).to;
    resistance = widget.list.elementAt(widget.index).resistance;
    reactance = widget.list.elementAt(widget.index).reactance;
  */
    return ContentDialog(
      title: const Text('Add new line information'),
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
                    const Text('From'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: from,
                        smallChange: 1,
                        min: 1,
                        max: widget.numberOfBuses,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (int? value) {
                          from = value ?? 1;
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
                    const Text('To'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: to,
                        smallChange: 1,
                        min: 1,
                        max: widget.numberOfBuses,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (int? value) {
                          to = value ?? 1;
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
                    const Text('Resistance'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: resistance,
                        smallChange: 0.1,
                        min: -100.0,
                        max: 100.0,
                        precision: 5,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          resistance = value ?? 0.0;
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
                    const Text('Reactance'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      height: 4.5.h,
                      child: NumberBox(
                        value: reactance,
                        smallChange: 0.1,
                        precision: 5,
                        min: -100.0,
                        max: 100.0,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (double? value) {
                          reactance = value ?? 0.0;
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
          onPressed: () async {
            Navigator.pop(context);
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Confirm'),
          onPressed: () async {
            bool isDefined = true;

            if (widget.list.isNotEmpty) {
              for (var i in widget.list) {
                if (i.from == from && i.to == to) {
                  isDefined = false;
                } else if (i.to == from && i.from == to) {
                  isDefined = false;
                } else {
                  continue;
                }
              }
            }
            if (from == to) {
              await displayInfoBar(context, builder: (context, close) {
                return InfoBar(
                  title: const Text('You can not connect a bus to itself'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.warning,
                );
              });
            } else if (!isDefined) {
              await displayInfoBar(context, builder: (context, close) {
                return InfoBar(
                  title: const Text('This line is already defined'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.warning,
                );
              });
            } else if (!isDefined) {
              await displayInfoBar(context, builder: (context, close) {
                return InfoBar(
                  title: const Text('This line is already defined'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.warning,
                );
              });
            } else {
              BlocProvider.of<LineDataPageBloc>(context).add(
                AddLineInformation(
                  lineInfoModel: LineInfoModel(
                    from: from,
                    to: to,
                    resistance: resistance,
                    reactance: reactance,
                  ),
                  list: widget.list,
                ),
              );
              Navigator.pop(context);
            }
            //Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
