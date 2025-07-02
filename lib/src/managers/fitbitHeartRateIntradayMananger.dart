import 'package:fitbitter/fitbitter.dart';
import 'package:logger/logger.dart';

import '../utils/formats.dart';

class FitbitIntradayHeartRateManager extends FitbitDataManager {
  FitbitIntradayHeartRateManager({
    required super.clientID,
    required super.clientSecret,
    required super.onRefreshCredentials,
    required super.onResetCredentials,
  });

  @override
  Future<List<FitbitData>> fetch(FitbitAPIURL fitbitUrl) async {
    // Get the response
    final response = await getResponse(fitbitUrl: fitbitUrl);

    // Debugging
    final logger = Logger();
    logger.i('$response');

    //Extract data and return them
    List<FitbitData> ret = _extractFitbitHeartRateIntradayData(
        response, fitbitUrl.fitbitCredentials!.userID);
    return ret;
  } // fetch

  /// A private method that extracts [FitbitHeartData] from the given response.
  List<FitbitHeartRateIntradayData> _extractFitbitHeartRateIntradayData(
      dynamic response, String? userId) {
    final dateOfMonitoring =
    DateTime.parse(response['activities-heart'][0]['dateTime']);
    final data = response['activities-heart-intraday']['dataset'];
    List<FitbitHeartRateIntradayData> heartDataPoints =
    List<FitbitHeartRateIntradayData>.empty(growable: true);

    if (data.isNotEmpty) {
      for (var record in data) {
        final time = Formats.onlyTimeWithSeconds.parse(record['time']);
        heartDataPoints.add(FitbitHeartRateIntradayData(
          userID: userId,
          dateOfMonitoring: dateOfMonitoring.add(Duration(
              hours: time.hour, minutes: time.minute, seconds: time.second)),
          value: record['value'].toDouble(),
        ));
      } // for entry
    }

    return heartDataPoints;
  }
}
