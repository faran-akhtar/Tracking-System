import 'package:flutter/material.dart';

class CustomColors {
  static const primaryColor = Color(0xFF1CABE2);
  static const primaryColor25 = Color(0x331CABE2);
  static const primaryColor15 = Color(0x261CABE2);
  static const primaryColor10 = Color(0x1A1CABE2);
  static const primaryColor5 = Color(0x0D1CABE2);
  static const primaryTextColor = Color(0xFF1D3F43);
  static const bottleGreenColor = Color(0xFF062221);
  static const bottleGreenColor25 = Color(0x33062221);
  static const bottleGreenColor40 = Color(0x66062221);
  static const secondaryTextColor = Color(0xFF232F51);
  static const secondaryTextColor2 = Color(0xDD000000);
  static const scaffoldBgColor = Color(0xFFEDEDED);
  static const greyColor = Color(0xFF898989);
  static const scaffoldBgColor2 = Color(0xBFebeef6);
  static const secondaryScaffoldBgColor = Color(0xFFf7f7f7);
  static const splashPageColor = Color(0xFF12161F);
  static const lightGreyColor = Color(0xFF949DA9);
  static const whiteColor = Color(0xFFFFFFFF);
  static const whiteColor25 = Color(0x33FFFFFF);
  static const whiteColor75 = Color(0xBFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const blackColor15 = Color(0x26000000);
  static const lightBlackColor = Color(0xFF13171F);
  static const lightBlackColor75 = Color(0xBF13171F);
  static const backgroundColor = Color(0xFFF5F7F7);
  static const backgroundColor2 = Color(0xFFFCFBFB);
  static const lightTextColor = Color(0xFFA9B1B0);
  static const redColor = Color(0xFFFF5D55);
  static const orangeColor = Color(0xFFFF9800);
  static const orangeColor2 = Color(0xFFFF8945);
  static const customOrangeColor = Color(0xFFFFF3EC);
  static const orangeColor10 = Color(0x1AFF9800);
  static const orangeColor15 = Color(0x26FF9800);
  static const orangeColor700 = Color(0xFFF57C00);
  static const greenColor = Color(0xFF4CAF50);
  static const greenColor700 = Color(0xFF388E3C);
  static const blueColor = Color(0xFF2196F3);
  static const blueColor700 = Color(0xFF1976D2);
  static const chestnutRedColor = Color(0xFFD25D5D);
  static const chestnutRedColor5 = Color(0x0DD25D5D);
  static const chestnutRedColor10 = Color(0x1AD25D5D);
  static const chestnutRedColor15 = Color(0x26D25D5D);
  static const lightredColor = Color(0xFFF14336);
  static const lightblueColors = Color(0xFF475993);
  static const blueColors = Color(0xFF4A90E2);
  static const checkBoxBorderColor = Color(0xFFADB9C5);
  static const checkBoxTextColor = Color(0xFF232F51);
  static const dividerTextColor = Color(0xFFB7B9C1);
  static const cardDisabledColor = Color(0xffe0dede);
  static const cardSavedColor = Color(0xFFC8E6C9);

  static const hintColor = Color(0xFFBCC6C8);
  static const shadowColor = Color.fromRGBO(0, 0, 0, 0.04);
  static const shadowColor2 = Color.fromRGBO(0, 0, 0, 0.1);

  static const sliderDotsColor = Color(0xFFD5D9DC);
  static const dividerColor = Color(0xFFBAD1DA);
  static const hintTextColor = Color(0xFF949da9);
  static const inputBorderColor3 = Color(0xFFE8E8E8);
  static const textFilledColor = Color(0xFFfbfbfb);
  static const inputBgColor = Color(0xFFF5F5F5);
  static const inputBgColor300 = Color(0xFFE0E0E0);
  static const inputBorderColor = Color(0xFFD9D9D9);

  static const darkGreyColor = Color(0xFF525E65);
  static const japaneseIndigo = Color(0xFF1D3F43);
  static const tableTitlesColor = Color(0xFF57575D);
  static const honeyDew = Color(0xFFF3F3FC);
  static const tableBgColor = Color(0xFFE5F8ED);

  static MaterialColor primarySwatch = MaterialColor(0xFF4CAF50, _swatch);

  static final Map<int, Color> _swatch = {
    50: const Color(0xFFE4F5FC),
    100: const Color(0xFFBBE6F6),
    200: const Color(0xFF8ED5F1),
    300: const Color(0xFF60C4EB),
    400: const Color(0xFF3EB8E6),
    500: const Color(0xFF1CABE2),
    600: const Color(0xFF19A4DF),
    700: const Color(0xFF149ADA),
    800: const Color(0xFF1191D6),
    900: const Color(0xFF0980CF),
  };

  static Map<int, Color> successSwatch = {
    0: const Color(0xFFF5FAF5),
    5: const Color(0xFFEDF6EE),
    10: const Color(0xFFDCEDDD),
    20: const Color(0xFFCBE5CC),
    30: const Color(0xFFA9D3AB),
    40: const Color(0xFF87C289),
    50: const Color(0xFF65B168),
    60: const Color(0xFF43A047),
    70: const Color(0xFF37833B),
    80: const Color(0xFF2B662E),
    90: const Color(0xFF1F4921),
    100: const Color(0xFF132C14),
  };

  static Map<int, Color> attentionSwatch = {
    0: const Color(0xFFFFF8EB),
    5: const Color(0xFFFFEFD1),
    10: const Color(0xFFFFE5B3),
    20: const Color(0xFFFFD98F),
    30: const Color(0xFFF5CE84),
    40: const Color(0xFFEBBF67),
    50: const Color(0xFFE5AE40),
    60: const Color(0xFFD6981B),
    70: const Color(0xFFB88217),
    80: const Color(0xFF8F6512),
    90: const Color(0xFF66480D),
    100: const Color(0xFF463209),
  };

  static Map<int, Color> warningSwatch = {
    0: const Color(0xFFFEF2F1),
    5: const Color(0xFFFEE8E7),
    10: const Color(0xFFFDDCDA),
    20: const Color(0xFFFCCBC8),
    30: const Color(0xFFFAA9A3),
    40: const Color(0xFFF8877F),
    50: const Color(0xFFF6655A),
    60: const Color(0xFFF44336),
    70: const Color(0xFFC8372D),
    80: const Color(0xFF9C2B23),
    90: const Color(0xFF6F1F19),
    100: const Color(0xFF43130F),
  };
}
