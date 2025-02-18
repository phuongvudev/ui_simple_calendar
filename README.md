# ui_simple_calendar

A simple Flutter package for displaying a calendar.

## Features

- Display a monthly calendar view
- Navigate between months
- Select dates

## Getting started

To use this package, add `ui_simple_calendar` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  ui_simple_calendar: ^0.0.1
```

## Usage

```dart

import 'package:ui_simple_calendar/ui_simple_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Calendar'),
        ),
        body: SimpleCalendar(),
      ),
    );
  }
}

```

## Additional information
For more information, visit the [package documentation](https://pub.dev/packages/ui_simple_calendar). 

Contributions are welcome! Please file issues and pull requests on the [GitHub repository](https://github.com/phuongvudev/ui_simple_calendar).