import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  @override
  Widget build(BuildContext context) {
    return  SfDateRangePicker(

      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        setState(() {
          if (args.value is PickerDateRange) {
            _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
                ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
          } else if (args.value is DateTime) {
            _selectedDate = args.value.toString();
          } else if (args.value is List<DateTime>) {
            _dateCount = args.value.length.toString();
          } else {
            _rangeCount = args.value.length.toString();
          }
        });
      }
      ,
      selectionMode: DateRangePickerSelectionMode.range,
      initialSelectedRange: PickerDateRange(
          DateTime.now().subtract(const Duration(days: 4)),
          DateTime.now().add(const Duration(days: 3))),

    );
  }
}
