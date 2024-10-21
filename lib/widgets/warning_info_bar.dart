import 'package:fluent_ui/fluent_ui.dart';
import 'package:main/utils/responsive_font.dart';
import 'package:google_fonts/google_fonts.dart';

class WarningInfoBar extends StatelessWidget {
  final String title;
  final String text;
  const WarningInfoBar({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InfoBar(
      title: Text(
        title,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14 * ResponsiveFont.responsiveFont(context),
            color: Colors.black,
          ),
        ),
      ),
      content: Text(
        text,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14 * ResponsiveFont.responsiveFont(context),
            color: Colors.black,
          ),
        ),
      ),
      severity: InfoBarSeverity.warning,
      isLong: true,
    );
  }
}
