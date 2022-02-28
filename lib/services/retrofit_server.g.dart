// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit_server.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _RetrofitServer implements RetrofitServer {
  _RetrofitServer(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.unsplash.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Collections>> getCollections(queries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{
      r'Accept-Version': 'v1',
      r'Authorization': 'Client-ID IuR29HU8Dj0Fpyz-i6kJA-wR6p0NArKTlR8qF-cdjho'
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<Collections>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/collections',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Collections.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> getSearchCollections(queries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{
      r'Accept-Version': 'v1',
      r'Authorization': 'Client-ID IuR29HU8Dj0Fpyz-i6kJA-wR6p0NArKTlR8qF-cdjho'
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/search/collections',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
