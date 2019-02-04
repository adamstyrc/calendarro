# Calendarro

Calendar widget library for Flutter apps.
Offers multiple ways to customize the widget.

## Getting Started

### Installation
Add dependency to your pubspec.yaml:

```dart
calendarro: ^0.0.5
```

### Basic use
First, add an import to your code:
```dart
import 'package:calendarro/calendarro.dart';
```

Add a widget to your code:
```dart
Calendarro(
  startDate: DateUtils.getFirstDayOfCurrentMonth(),
  endDate: DateUtils.getLastDayOfCurrentMonth()
  )
```
![alt tag](https://github.com/adamstyrc/calendarro/blob/master/sample1.gif) 


### Customization

![alt tag](https://github.com/adamstyrc/calendarro/blob/master/sample2.gif) 

<b>1. Display Mode</b> - If you prefer to operate on multiple rows to see whole month, use:

```dart
Calendarro(
  displayMode: DisplayMode.MONTHS,
  ...
  )
```

<b>2. Selection Mode</b> - If you want to select multiple dates, use:

```dart
Calendarro(
  selectionMode: SelectionMode.MULTI,
  ...
  )
```

<b>3. Weekday Labels</b> - If you want to provide your own row widget for displaying weekday names, use:
```dart
Calendarro(
  weekdayLabelsRow: CustomWeekdayLabelsRow()
  ...
  )
```
you can create your CustomWeekdayLabelsRow by looking at default CalendarroWeekdayLabelsView.

<b>4. Day Tile Builder</b> - If you want to build day tiles your own way, you can use:
```dart
Calendarro(
  dayTileBuilder: CustomDayTileBuilder()
  ...
  )
```
you can create your CustomDayTileBuilder looking upon DefaultDayTileBuilder.

<b>5. Initial selected dates</b> - When you want some dates to be selected from the scratch, use selectedDate (SelectionMode.SINGLE) or selectedDates (SelectionMode.MULTI) arguments:
```dart
Calendarro(
  selectedDate: DateTime(2018, 8, 1)
  //or
  selectedDates: [DateTime(2018, 8, 1), DateTime(2018, 8, 8)]
  ...
  )
```
you can create your CustomDayTileBuilder looking upon DefaultDayTileBuilder.

  
  ### Selecting date callback
  
  If you want to get a callback when a date tile is clicked, there is onTap param:

  ```dart
  Calendarro(
    onTap: (date) {
        //your code
    }
    ...
    )
  ```
  
  
  ## Advanced usage:
  For more advanced usage see:
  https://github.com/adamstyrc/parking-app
  
