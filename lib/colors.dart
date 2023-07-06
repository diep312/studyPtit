import 'package:flutter/material.dart';

const MaterialColor appcolors = MaterialColor(_appcolorsPrimaryValue, <int, Color>{
  50: Color(0xFFF5F5F3),
  100: Color(0xFFE7E6E1),
  200: Color(0xFFD7D6CD),
  300: Color(0xFFC6C5B8),
  400: Color(0xFFBAB8A9),
  500: Color(_appcolorsPrimaryValue),
  600: Color(0xFFA7A592),
  700: Color(0xFF9D9B88),
  800: Color(0xFF94927E),
  900: Color(0xFF84826C),
});
const int _appcolorsPrimaryValue = 0xFFAEAC9A;

const MaterialColor appcolorsAccent = MaterialColor(_appcolorsAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_appcolorsAccentValue),
  400: Color(0xFFFFF79A),
  700: Color(0xFFFFF580),
});
const int _appcolorsAccentValue = 0xFFFDF9CF;