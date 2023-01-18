import 'package:cbesdesktop/widgets/search_view.dart';
import 'package:flutter/material.dart';

class ToggleOnlineView extends StatefulWidget {
  const ToggleOnlineView({Key? key}) : super(key: key);

  @override
  State<ToggleOnlineView> createState() => _ToggleOnlineViewState();
}

class _ToggleOnlineViewState extends State<ToggleOnlineView> {
  var _online = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_online) const SearchView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  icon: const Icon(Icons.file_copy),
                  onPressed: () {
                    // Create a new Excel document.
                  },
                  label: const Text('Generate Excel')),
              ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {},
                  label: const Text('Generate PDF')),
              Switch.adaptive(
                  value: _online,
                  onChanged: (val) {
                    setState(() {
                      _online = val;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }
}
