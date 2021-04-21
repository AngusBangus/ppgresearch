import 'package:flutter/material.dart';
import 'package:ppgresearch/sensor.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:wear/wear.dart';

export 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    show
        Permission,
        PermissionStatus,
        PermissionStatusGetters,
        PermissionWithService,
        FuturePermissionStatusGetters,
        ServiceStatus,
        ServiceStatusGetters,
        FutureServiceStatusGetters;

PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;
Future<bool> openAppSettings() => _handler.openAppSettings();

extension PermissionListActions on List<Permission> {
  /// Requests the user for access to these permissions, if they haven't already
  /// been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  Future<Map<Permission, PermissionStatus>> request() =>
      _handler.requestPermissions(this);
}

void main() {
  final AppState state = AppState();

  final MaterialApp app = MaterialApp(
    title: 'PPG Measurement',
    debugShowCheckedModeBanner: false,
    home: ScopedModel<AppState>(model: state, child: PPGExample()),
  );

  runApp(app);

  state.initPPG();
}

class PPGExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppState state = ScopedModel.of<AppState>(
      context,
      rebuildOnChange: true,
    );

    final String ppgTxt = !state.ppgDetected
        ? 'PPG not detected'
        : 'Channel 1: ${state.ppgData[0]}\n'
            'Channel 2: ${state.ppgData[1]}\n'
            'timestamp: ${state.ppgTimestamp.round()}\n'
            'accuracy: ${state.ppgAccuracy}';

    final String hrTxt = !state.hrPermission
        ? 'Permission not granted'
        : !state.hrDetected
            ? 'Reading...'
            : '${state.hrData.round()} bpm\n'
                'timestamp: ${state.hrTimestamp.round()}\n'
                'accuracy: ${state.hrAccuracy}';

    final String txt = 'PPG\n$ppgTxt\n\nHeart Rate\n$hrTxt';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 8),
        child: Text(
          txt,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
