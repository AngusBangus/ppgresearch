import 'package:ppg/ppg.dart';
import 'package:scoped_model/scoped_model.dart';

class AppState extends Model {
  bool ppgDetected = false, hrDetected = false, hrPermission = false;
  List<double> ppgData;
  double hrData, ppgTimestamp, hrTimestamp;
  int hrAccuracy, ppgAccuracy;

  initPPG() => ppgEvents.listen(onNewPPGData);

  initHR() {
    hrPermission = true;
    notifyListeners();
  }

  onNewPPGData(PPGEvent e) {
    ppgTimestamp = e.t;
    ppgData = e.x;
    ppgDetected = true;
    notifyListeners();
  }
}
