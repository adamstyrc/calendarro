# Calendarro

Calendar widget library for Flutter apps.
Offers a way to customize the widget.

## Getting Started


### Basic use
Add a widget to your code:
```dart
Calendarro(
  startDate: DateUtils.getFirstDayOfCurrentMonth(),
  endDate: DateUtils.getLastDayOfCurrentMonth()
  )
```
![alt tag](https://github.com/adamstyrc/calendarro/blob/master/sample1.gif) 


### Customization

<b>Display Mode</b> - If you prefer to see multiple rows to see whole month use:

```dart
Calendarro(
  displayMode: DisplayMode.MONTHS,
  ...
  )
```

<b>Selection Mode</b> - If you want to select multiple dates use:

```dart
Calendarro(
  selectionMode: SelectionMode.MULTI,
  ...
  )
```

<b>Weekday Labels</b> - If you want to provide your own row widget for displaying weekday names use:
```dart
Calendarro(
  weekdayLabelsRow: CustomWeekdayLabelsRow()
  ...
  )
```
you can create your CustomWeekdayLabelsRow by looking at default CalendarroWeekdayLabelsView.

![alt tag](https://github.com/adamstyrc/calendarro/blob/master/sample2.gif) 



  
  
  
