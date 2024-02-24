import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_system_mobile_app/app/app.dart';
import 'package:tracking_system_mobile_app/app/sdk/location_services/background_location.dart';
import '../../../../styles/style.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar(
      {super.key, required this.label, required this.onLogoutPressed});

  final String label;
  final VoidCallback onLogoutPressed;

  void _showStartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue,
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 8),
              Text('Confirmation'),
            ],
          ),
          content: const Text('Are you sure you want to start?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () async {
                final permission = await context
                    .read<DriverHomeCubit>()
                    .enableGPSWithPermission();

                if (permission) {
                  await BackgroundService().initializeService();
                  BackgroundService().setServiceAsForeGround();
                  // ignore: use_build_context_synchronously
                  context.read<DriverHomeCubit>().updateRun();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  print('permission diend');
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Start'),
            )
          ],
        );
      },
    );
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue,
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 8),
              Text('Confirmation'),
            ],
          ),
          content: const Text('Are you sure you want to End?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            BlocBuilder<DriverHomeCubit, DriverHomeState>(
              builder: (context, state) {
                return TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    BackgroundService().stopService();
                    context.read<DriverHomeCubit>().updateRunStop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('End'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: Sizes.s10,
            right: Sizes.s10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  BlocBuilder<DriverHomeCubit, DriverHomeState>(
                    builder: (context, state) {
                      return Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () async {
                              state.runStatus == RunStatus.none
                                  ? _showStartDialog(context)
                                  : _showEndDialog(context);
                            },
                            icon: Icon(
                              state.runStatus == RunStatus.none
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            constraints: const BoxConstraints(
                              maxHeight: 40,
                              maxWidth: 40,
                              minHeight: 40,
                              minWidth: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterTextTheme.lightTextTheme.headline4?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: onLogoutPressed,
                        icon: const Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        ),
                        splashRadius: 24,
                        constraints: const BoxConstraints(
                          maxHeight: 40,
                          maxWidth: 40,
                          minHeight: 40,
                          minWidth: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
