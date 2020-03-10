import 'package:calendarro/calendarro.dart';
import 'package:flutter/material.dart';

class CalendarroHeaderView extends StatelessWidget {
  CalendarroHeaderView({this.title, this.curPage});
  final String title;
  final int curPage;

  @override
  Widget build(BuildContext context) {
    final calendarroState = Calendarro.of(context);
    return SizedBox(
      height: 40.0,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  print(curPage.toString());
                  int prevPage = curPage - 1;
                  if(prevPage < 0) return;
                  calendarroState.movePage(prevPage);
                },
                child: Icon(Icons.arrow_left, color: curPage == 0 ? Colors.transparent : Colors.black,)),
            Text(title),
            GestureDetector(
                onTap: () {
                  int nextPage = curPage + 1;
                  if(nextPage >= calendarroState.pagesCount) return;
                  calendarroState.movePage(nextPage);
                },
                child: Icon(Icons.arrow_right, color: curPage == calendarroState.pagesCount - 1 ? Colors.transparent : Colors.black,))
          ],
        ),
      ),
    );
  }
}
