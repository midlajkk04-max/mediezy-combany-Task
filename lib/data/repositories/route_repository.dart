import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/route_model.dart';

class RouteRepository {
  RouteRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<RouteModel>> routeList() async {
    final data = await _apiClient.get(ApiEndpoints.routeList);
    return RouteModel.listFromDynamic(data);
  }
}
