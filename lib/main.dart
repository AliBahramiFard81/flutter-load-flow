import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/bloc/bus_data_page_bloc.dart';
import 'package:main/bloc/line_data_page_bloc.dart';
import 'package:main/cubit/bus_data_update_cubit.dart';
import 'package:main/cubit/update_min_max_icon_cubit.dart';
import 'package:main/pages/home_page.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then(
    (value) async {
      await windowManager.setSize(const Size(600, 800));
      await windowManager.center();
      await windowManager.setTitle('Load Flow');
      await windowManager.setMaximizable(false);
      await windowManager.setResizable(false);
      await windowManager.setIcon('/lib/assets/image/icon.png');
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BusDataPageBloc()),
        BlocProvider(create: (context) => BusDataUpdateCubit()),
        BlocProvider(create: (context) => LineDataPageBloc()),
        BlocProvider(create: (context) => UpdateMinMaxIconCubit()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return FluentApp(
            themeMode: ThemeMode.dark,
            theme: FluentThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
