import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/utils/responsive_font.dart';
import 'package:sizer/sizer.dart';

class MethodButton extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onPressed;
  const MethodButton({
    super.key,
    required this.title,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.w),
      child: Button(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 8.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 20 * ResponsiveFont.responsiveFont(context),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    text,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 14 * ResponsiveFont.responsiveFont(context),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(FluentIcons.chevron_right_med),
          ],
        ),
      ),
    );
  }
}
