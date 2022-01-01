import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/preferences_provider.dart';
import '../../provider/scheduling_provider.dart';

class SettingPage extends StatelessWidget {
  static const route = '/setting';
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Setting"),
      ),
      body: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return ListView(
          children: <Widget>[
            Material(
              child: ListTile(
                title: const Text("Notification"),
                trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    activeColor: Colors.blue,
                    value: provider.isDailyRestaurantsActive,
                    onChanged: (value) async {
                      scheduled.schedulingRestaurant(value);
                      provider.activeDailyRestaurant(value);
                    },
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
