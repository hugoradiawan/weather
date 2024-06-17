import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';

class AddCityDialog extends StatelessWidget {
  const AddCityDialog({
    super.key,
    required this.mainContext,
  });

  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              focusNode: FocusNode()..requestFocus(),
              controller: mainContext.read<WeatherPageUiCubit>().state.cityTec,
              decoration: const InputDecoration(
                labelText: 'Add New City',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                mainContext.read<WeatherPageUiCubit>().fetchWeatherByCity();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            )
          ]),
        ),
      );
}
