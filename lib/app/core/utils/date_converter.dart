import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateConverter
{
  static String formatDateTime(String? dateTimeString) {

    if(dateTimeString==null||dateTimeString=="null")
    {
        return "";
      }
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return '$formattedDate\n$formattedTime';
  }
}