import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBackgroundLight = Color(0xFFF6F6F6);
const kCardLight = Color(0xFFFFFFFF);

const kBackgroundDark = Color(0xFF30314A);
const kCardDark = Color(0xFF1F203B);

const kGreyColor = Color(0xFFEBEDF6);

var kTitleStyle = GoogleFonts.comfortaa(
    fontSize: 22.0, fontWeight: FontWeight.bold, color: kCardLight);

var kDarkTitleStyle = GoogleFonts.comfortaa(
    fontSize: 21.0,
    fontWeight: FontWeight.lerp(FontWeight.w900, FontWeight.w900, 1.5),
    color: kCardDark);

var kSubtitleStyle = GoogleFonts.comfortaa(
    fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.bold);
