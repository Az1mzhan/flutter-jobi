import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/brigades/data/models/brigade_model.dart';

class BrigadesRemoteDataSource {
  const BrigadesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<BrigadeModel>> getBrigades() async {
    final response = await _apiClient.get(ApiEndpoints.brigades);
    return (response.data as List<dynamic>)
        .map((item) => BrigadeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BrigadeModel> getBrigade(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.brigades}/$id');
    return BrigadeModel.fromJson(response.data as Map<String, dynamic>);
  }
}
