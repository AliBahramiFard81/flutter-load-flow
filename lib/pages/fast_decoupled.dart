import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as x;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/bloc/bus_data_page_bloc.dart';
import 'package:main/cubit/bus_data_update_cubit.dart';
import 'package:main/models/bus_info_model.dart';
import 'package:main/pages/line_data_page.dart';
import 'package:main/services/list_to_csv.dart';
import 'package:main/widgets/custom_appbar.dart';
import 'package:main/widgets/other_buses_info_dialog.dart';
import 'package:main/widgets/slack_bus_info_dialog.dart';
import 'package:sizer/sizer.dart';

class FastDecoupled extends StatefulWidget {
  final int busNum;
  const FastDecoupled({
    super.key,
    required this.busNum,
  });

  @override
  State<FastDecoupled> createState() => _FastDecoupledState();
}

class _FastDecoupledState extends State<FastDecoupled> {
  List<BusInfoModel> firstData = [];
  @override
  void initState() {
    firstData = List.generate(
      widget.busNum,
      (index) => BusInfoModel.fromJson(
        index == 0
            ? {
                'voltage': 0.0,
                'angle': 0.0,
                'active power': 0.0,
                'reactive power': 0.0,
                'bus type': 2,
              }
            : {
                'voltage': 0.0,
                'angle': 0.0,
                'active power': 0.0,
                'reactive power': 0.0,
                'bus type': 1,
              },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BusDataUpdateCubit>(context).reset();
    return x.Scaffold(
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
      appBar: const CustomAppbar(
        actions: [],
        title: 'Bus information',
      ),
      body: BlocListener<BusDataPageBloc, BusDataPageState>(
        listener: (context, state) {
          if (state is BusDataPageSuccess) {
          } else {}
        },
        child: BlocBuilder<BusDataPageBloc, BusDataPageState>(
          builder: (context, state) {
            if (state is BusDataPageSuccess) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Bus 1 (Slack)'),
                    subtitle:
                        BlocBuilder<BusDataUpdateCubit, BusDataUpdateState>(
                      builder: (context, state) {
                        if (state is BusDataUpdate) {
                          return Text(
                              'V = ${state.busInfoModel.elementAt(0).voltage}   |   δ = ${state.busInfoModel.elementAt(0).angle}   |   P = ${state.busInfoModel.elementAt(0).activePower}   |   Q = ${state.busInfoModel.elementAt(0).reactivePower}');
                        } else {
                          return const Text(
                              'V = 0   |   δ = 0   |   P = 0   |   Q = 0');
                        }
                      },
                    ),
                    trailing: const Icon(FluentIcons.edit),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return SlackBusInfoDialog(list: firstData);
                        },
                      );
                    },
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.numOfBusses - 1,
                    itemBuilder: (context, index) {
                      index = index + 2;
                      return Column(
                        children: [
                          ListTile(
                            title: BlocBuilder<BusDataUpdateCubit,
                                BusDataUpdateState>(
                              builder: (context, state) {
                                if (state is BusDataUpdate) {
                                  return Text(
                                      'Bus $index (${state.busInfoModel.elementAt(index - 1).busType == 0 ? 'PV' : 'PQ'})');
                                } else {
                                  return Text('Bus $index (PQ)');
                                }
                              },
                            ),
                            subtitle: BlocBuilder<BusDataUpdateCubit,
                                BusDataUpdateState>(
                              builder: (context, state) {
                                if (state is BusDataUpdate) {
                                  return Text(
                                      'V = ${state.busInfoModel.elementAt(index - 1).voltage}   |   δ = ${state.busInfoModel.elementAt(index - 1).angle}   |   P = ${state.busInfoModel.elementAt(index - 1).activePower}   |   Q = ${state.busInfoModel.elementAt(index - 1).reactivePower}');
                                } else {
                                  return const Text(
                                      'V = 0   |   δ = 0   |   P = 0   |   Q = 0');
                                }
                              },
                            ),
                            trailing: const Icon(FluentIcons.edit),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return OtherBusesInfoDialog(
                                    list: firstData,
                                    index: index - 1,
                                  );
                                },
                              );
                            },
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
                  ),
                ],
              );
            } else {
              return const Center(
                child: ProgressRing(),
              );
            }
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 8.w,
        height: 8.w,
        child: FilledButton(
          child: const Icon(FluentIcons.accept_medium),
          onPressed: () async {
            List<List<dynamic>> lineData = List.generate(
              firstData.length,
              (index) {
                return [
                  firstData.elementAt(index).activePower,
                  firstData.elementAt(index).reactivePower,
                  firstData.elementAt(index).voltage,
                  firstData.elementAt(index).angle,
                  firstData.elementAt(index).busType,
                ];
              },
            );
            await ListToCsv(rows: lineData, fileName: 'bus_data').listToCsv();
            Navigator.push(
              context,
              FluentPageRoute(
                builder: (context) => LineDataPage(
                  numOfBuses: firstData.length,
                ),
              ),
            ).then(
              (value) {},
            );
          },
        ),
      ),
    );
  }
}
