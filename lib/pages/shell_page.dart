import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as x;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/cubit/update_min_max_icon_cubit.dart';
import 'package:main/services/read_write_result.dart';
import 'package:main/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  String result = '';
  Future<String?> readResult() async {
    result = await ReadWriteResult().readFromTxt();
    result = result.replaceAll(',', '\n');
    return result;
  }

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
              icon: BlocBuilder<UpdateMinMaxIconCubit, UpdateMinMaxIconState>(
                builder: (context, state) {
                  if (state is UpdateMinMaxIcon) {
                    return state.isMaximized
                        ? const Icon(FluentIcons.arrange_bring_forward)
                        : const Icon(FluentIcons.square_shape);
                  } else {
                    return const Icon(FluentIcons.square_shape);
                  }
                },
              ),
              onPressed: () async {
                bool isMaximized = await windowManager.isMaximized();
                if (isMaximized) {
                  await windowManager.restore();
                } else {
                  await windowManager.maximize();
                }
                BlocProvider.of<UpdateMinMaxIconCubit>(context).updateIcon();
              },
            ),
          )
        ],
        title: 'Result',
      ),
      body: FutureBuilder(
        future: readResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: ProgressRing(),
            );
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              child: SizedBox(
                width: double.infinity,
                child: SelectableText(
                  result,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
