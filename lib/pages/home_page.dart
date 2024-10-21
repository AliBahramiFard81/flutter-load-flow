import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as x;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/bloc/bus_data_page_bloc.dart';
import 'package:main/bloc/line_data_page_bloc.dart';
import 'package:main/pages/fast_decoupled.dart';
import 'package:main/utils/responsive_font.dart';
import 'package:main/widgets/method_button.dart';
import 'package:main/widgets/warning_info_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numOfBusses = 2;
  @override
  Widget build(BuildContext context) {
    return x.Scaffold(
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
      body: Container(
        margin: EdgeInsets.all(5.w),
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select calculation method',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 30 * ResponsiveFont.responsiveFont(context),
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  children: [
                    MethodButton(
                      title: 'Fast decoupled load flow',
                      text: 'Solve load flow using fast decoupled method',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => ContentDialog(
                            title: const Text('Number of buses'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Enter the total number of the buses',
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 2.w),
                                  height: 4.5.h,
                                  child: NumberBox(
                                    value: 2,
                                    min: 2,
                                    max: 100,
                                    mode: SpinButtonPlacementMode.inline,
                                    onChanged: (int? value) {
                                      numOfBusses = value ?? 2;
                                    },
                                  ),
                                ),
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
                                  BlocProvider.of<BusDataPageBloc>(context)
                                      .add(BuildBusPageReset());
                                  BlocProvider.of<LineDataPageBloc>(context)
                                      .add(LineInformationReset());
                                  Navigator.push(
                                    context,
                                    FluentPageRoute(
                                      builder: (context) => FastDecoupled(
                                        busNum: numOfBusses,
                                      ),
                                    ),
                                  );
                                  BlocProvider.of<BusDataPageBloc>(context).add(
                                    BuildBussPage(
                                      numOfBusses: numOfBusses,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    MethodButton(
                      title: 'DC load flow',
                      text: 'Solve load flow using DC method',
                      onPressed: () async {
                        print(Platform.environment['USERPROFILE']);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const WarningInfoBar(
              title: 'Warning',
              text:
                  '-This app is still under development so it may have some bugs.                                      \n-Matlab version used for this app 2024b.\n-The iterations limit is 1000.\n-Developed by Ali Bahrami Fard',
            )
          ],
        ),
      ),
    );
  }
}
