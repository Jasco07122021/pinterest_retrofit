import 'package:dio/dio.dart';
import 'package:pinterest_2022/models/collection_model.dart';
import 'package:retrofit/http.dart' as http;
import 'package:retrofit/retrofit.dart';

part 'retrofit_server.g.dart';

bool isTester = true;

const String SERVER_DEVELOPMENT = "https://api.unsplash.com";
const String SERVER_PRODUCTION = "https://api.unsplash.com";

String getServer() {
  if (isTester) return SERVER_DEVELOPMENT;
  return SERVER_PRODUCTION;
}

@RestApi(baseUrl: SERVER_DEVELOPMENT)
abstract class RetrofitServer {
  factory RetrofitServer(Dio dio, {String baseUrl}) = _RetrofitServer;

  static const Map<String, String> header = {
    "Accept-Version": "v1",
    "Authorization": "Client-ID IuR29HU8Dj0Fpyz-i6kJA-wR6p0NArKTlR8qF-cdjho"
  };

  @GET("/collections")
  @http.Headers(header)
  Future<List<Collections>> getCollections(
      @Queries() Map<String, dynamic> queries);

  @GET('/search/collections')
  @http.Headers(header)
  Future<String> getSearchCollections(
      @Queries() Map<String, dynamic> queries);
}


