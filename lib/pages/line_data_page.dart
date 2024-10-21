import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as x;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/bloc/line_data_page_bloc.dart';
import 'package:main/models/line_info_model.dart';
import 'package:main/pages/shell_page.dart';
import 'package:main/services/list_to_csv.dart';
import 'package:main/services/read_write_result.dart';
import 'package:main/widgets/custom_appbar.dart';
import 'package:main/widgets/line_info_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:process_run/process_run.dart';

class LineDataPage extends StatefulWidget {
  final int numOfBuses;
  const LineDataPage({
    super.key,
    required this.numOfBuses,
  });

  @override
  State<LineDataPage> createState() => _LineDataPageState();
}

class _LineDataPageState extends State<LineDataPage> {
  List<LineInfoModel> list = [];

  @override
  Widget build(BuildContext context) {
    return x.Scaffold(
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
      appBar: CustomAppbar(
        actions: [
          SizedBox(
            width: 10.w,
            height: double.infinity,
            child: IconButton(
              icon: const Icon(FluentIcons.delete),
              onPressed: () {
                BlocProvider.of<LineDataPageBloc>(context)
                    .add(DeleteAllLineInformation(list: list));
                list.clear();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(1.w),
            width: 20.w,
            height: double.infinity,
            child: FilledButton(
              child: const Text('Calculate'),
              onPressed: () async {
                int numOfBranches =
                    ((widget.numOfBuses * (widget.numOfBuses - 1)) / 2).toInt();

                if (numOfBranches > list.length) {
                  await displayInfoBar(context, builder: (context, close) {
                    return InfoBar(
                      title: Text(
                          'Define all the branches.\nA ${widget.numOfBuses} bus system should have $numOfBranches branches.'),
                      action: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: close,
                      ),
                      severity: InfoBarSeverity.warning,
                    );
                  });
                } else {
                  List<List<dynamic>> lineData = List.generate(
                    list.length,
                    (index) {
                      return [
                        list.elementAt(index).from,
                        list.elementAt(index).to,
                        list.elementAt(index).resistance,
                        list.elementAt(index).reactance,
                      ];
                    },
                  );
                  await ListToCsv(rows: lineData, fileName: 'line_data')
                      .listToCsv();
                  var shell = Shell();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ContentDialog(
                        constraints: BoxConstraints(maxWidth: 25.h),
                        title: const Center(child: Text('Calculating')),
                        content: SizedBox(
                          height: 10.w,
                          child: Center(
                            child: SizedBox(
                              width: 10.w,
                              height: 10.w,
                              child: const ProgressRing(),
                            ),
                          ),
                        ),
                        actions: [
                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              child: const Text('Cancel'),
                              onPressed: () async {
                                shell.kill();
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      );
                    },
                  );
                  try {
                    String dir = '${Directory.current.path}\\matlib\\main.exe';
                    String dir2 = dir.replaceAll('\\', '\\\\');

                    await shell.run('"$dir2"').then(
                      (value) async {
                        await ReadWriteResult()
                            .writeToTxt(value.first.stdout.toString());
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          FluentPageRoute(
                            builder: (context) => const ShellPage(),
                          ),
                        );
                        //await windowManager.maximize();
                      },
                    );
                  } catch (e) {
                    await displayInfoBar(context, builder: (context, close) {
                      return InfoBar(
                        title: const Text('Operation was cancelled'),
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                        severity: InfoBarSeverity.warning,
                      );
                    });
                  }
                }
              },
            ),
          )
        ],
        title: 'Line information',
      ),
      body: BlocListener<LineDataPageBloc, LineDataPageState>(
        listener: (context, state) {
          if (state is AddLineInformationSuccess) {
            list = state.list;
          }
        },
        child: BlocBuilder<LineDataPageBloc, LineDataPageState>(
          builder: (context, state) {
            if (state is AddLineInformationSuccess) {
              list = state.list;
              return ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Line No.${index + 1}'),
                        subtitle: Text(
                            'From = ${state.list.elementAt(index).from}   |   To = ${state.list.elementAt(index).to}   |   R = ${state.list.elementAt(index).resistance}   |   X = ${state.list.elementAt(index).reactance}'),
                        trailing: IconButton(
                          icon: const Icon(FluentIcons.cancel),
                          onPressed: () {
                            BlocProvider.of<LineDataPageBloc>(context).add(
                              DeleteLineInformation(
                                index: index,
                                list: list,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.2.w,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 72, 74, 77),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Press the + button to add a line'),
              );
            }
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 8.w,
        height: 8.w,
        child: FilledButton(
          child: const Icon(FluentIcons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddLineInfoDialog(
                  list: list,
                  numberOfBuses: widget.numOfBuses,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
