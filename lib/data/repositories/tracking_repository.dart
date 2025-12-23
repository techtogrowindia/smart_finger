import 'package:smart_finger/data/models/tracking_request_model.dart';
import 'package:smart_finger/data/services/tracking_service.dart';

class TrackingRepository {
  final TrackingService service;

  TrackingRepository(this.service);

  Future<bool> sendTracking(TrackingRequestModel model) {
    return service.sendTracking(model);
  }
}
