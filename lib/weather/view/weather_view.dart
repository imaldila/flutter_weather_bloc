import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_weather_bloc/themes/cubit/theme_cubit.dart';
import 'package:flutter_weather_bloc/weather/cubit/weather_cubit.dart';

import '../../search/search.dart';
import '../../settings/settings.dart';
import '../widgets/widgets.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                SettingsPage.route(
                  context.read<WeatherCubit>(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child:
            BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
          switch (state.status) {
            case WeatherStatus.initial:
              return const WeatherEmpty();
            case WeatherStatus.loading:
              return const WeatherLoading();
            case WeatherStatus.success:
              return WeatherPopulated(
                weather: state.weather,
                units: state.temperatureUnits,
                onRefresh: () {
                  return context.read<WeatherCubit>().refreshWeather();
                },
              );
            case WeatherStatus.failure:
            default:
              return WeatherError();
          }
        }, listener: (context, state) {
          if (state.status.isSuccess) {
            context.read<ThemeCubit>().updateTheme(state.weather);
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () async {
            final city = await Navigator.of(context).push(SearchPage.route());
            await context.read<WeatherCubit>().fetchWeather(city);
          }),
    );
  }
}
