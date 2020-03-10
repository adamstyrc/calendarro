import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_header.dart';
import 'package:flutter/material.dart';

class DefaultHeaderBuilder extends HeaderBuilder {

  DefaultHeaderBuilder();

  @override
  Widget build(BuildContext context, String title, int curPage) {
  return CalendarroHeaderView(title: title, curPage: curPage);
  }
}