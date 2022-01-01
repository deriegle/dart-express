part of dart_express;

class CorsOptions {
  final dynamic origin;
  final List<String> methods;
  final bool preflightContinue;
  final int optionsSuccessStatus;
  final bool credentials;
  final List<String> allowedHeaders;
  final List<String> exposedHeaders;
  final int maxAge;

  const CorsOptions({
    this.origin = '*',
    this.methods = const [
      _HTTPMethods.get,
      _HTTPMethods.head,
      _HTTPMethods.put,
      _HTTPMethods.patch,
      _HTTPMethods.post,
      _HTTPMethods.delete,
    ],
    this.preflightContinue = false,
    this.optionsSuccessStatus = 204,
    this.credentials = false,
    this.allowedHeaders = const <String>[],
    this.exposedHeaders = const <String>[],
    this.maxAge,
  });

  CorsOptions copyWith({
    dynamic origin,
    List<String> methods,
    bool preflightContinue,
    int optionsSuccessStatus,
    bool credentials,
    List<String> allowedHeaders,
    List<String> exposedHeaders,
    int maxAge,
  }) {
    return CorsOptions(
      origin: origin ?? this.origin,
      methods: methods ?? this.methods,
      preflightContinue: preflightContinue ?? this.preflightContinue,
      optionsSuccessStatus: optionsSuccessStatus ?? this.optionsSuccessStatus,
      credentials: credentials ?? this.credentials,
      allowedHeaders: allowedHeaders ?? this.allowedHeaders,
      exposedHeaders: exposedHeaders ?? this.exposedHeaders,
      maxAge: maxAge ?? this.maxAge,
    );
  }
}

class CorsMiddleware {
  static RouteMethod use({
    dynamic origin = '*',
    List<String> methods = const [
      _HTTPMethods.get,
      _HTTPMethods.head,
      _HTTPMethods.put,
      _HTTPMethods.patch,
      _HTTPMethods.post,
      _HTTPMethods.delete,
    ],
    bool preflightContinue = false,
    int optionsSuccessStatus = 204,
    bool credentials = false,
    List<String> allowedHeaders = const <String>[],
    List<String> exposedHeaders = const <String>[],
    int maxAge,
  }) {
    final options = CorsOptions(
      origin: origin,
      methods: methods,
      preflightContinue: preflightContinue,
      optionsSuccessStatus: optionsSuccessStatus,
      credentials: credentials,
      allowedHeaders: allowedHeaders,
      exposedHeaders: exposedHeaders,
      maxAge: maxAge,
    );

    return (Request req, Response res) {
      final headers = <MapEntry>[];

      if (req.method == _HTTPMethods.options) {
        headers.addAll(configureOrigin(options, req));
        headers.add(configureCredentials(options));
        headers.add(configureMethods(options));
        headers.addAll(configureAllowedHeaders(options, req));
        headers.add(configureMaxAge(options));
        headers.add(configureExposedHeaders(options));
        _applyHeaders(res, headers);

        if (options.preflightContinue) {
          req.next();
        } else {
          res.statusCode = options.optionsSuccessStatus;
          res.headers.contentLength = 0;
          res.end();
        }
      } else {
        headers.addAll(configureOrigin(options, req));
        headers.add(configureCredentials(options));
        headers.add(configureExposedHeaders(options));
        _applyHeaders(res, headers);

        req.next();
      }
    };
  }

  static void _applyHeaders(Response res, List<MapEntry> headers) {
    headers
        .where((mapEntry) => mapEntry != null)
        .forEach((mapEntry) => res.headers.add(mapEntry.key, mapEntry.value));
  }

  static bool isOriginAllowed(String origin, dynamic allowedOrigin) {
    if (allowedOrigin is List) {
      for (var i = 0; i < allowedOrigin.length; ++i) {
        if (isOriginAllowed(origin, allowedOrigin[i])) {
          return true;
        }
      }
      return false;
    } else if (allowedOrigin is String) {
      return origin == allowedOrigin;
    } else if (allowedOrigin is RegExp) {
      return allowedOrigin.hasMatch(origin);
    } else {
      return allowedOrigin != null;
    }
  }

  static List<MapEntry> configureOrigin(CorsOptions options, Request req) {
    final requestOrigin = req.headers.value('origin');
    final headers = <MapEntry>[];
    bool isAllowed;

    if (options.origin != null && options.origin == '*') {
      // allow any origin
      headers.add(
        MapEntry('Access-Control-Allow-Origin', '*'),
      );
    } else if (options.origin is String) {
      // fixed origin
      headers.add(
        MapEntry('Access-Control-Allow-Origin', options.origin),
      );
      headers.add(
        MapEntry('Vary', 'Origin'),
      );
    } else {
      isAllowed = isOriginAllowed(requestOrigin, options.origin);
      // reflect origin
      headers.add(
        MapEntry(
          'Access-Control-Allow-Origin',
          isAllowed ? requestOrigin : false,
        ),
      );
      headers.add(MapEntry('Vary', 'Origin'));
    }

    return headers;
  }

  static MapEntry configureMethods(CorsOptions options) {
    return MapEntry(
      'Access-Control-Allow-Methods',
      options.methods.join(','),
    );
  }

  static MapEntry configureCredentials(CorsOptions options) {
    if (options.credentials) {
      return MapEntry('Access-Control-Allow-Credentials', 'true');
    }

    return null;
  }

  static List<MapEntry> configureAllowedHeaders(
      CorsOptions options, Request req) {
    String allowedHeaders;
    final headers = <MapEntry>[];

    if (options.allowedHeaders == null) {
      allowedHeaders = req.headers.value('access-control-request-headers');

      headers.add(
        MapEntry('Vary', 'Access-Control-Request-Headers'),
      );
    } else {
      allowedHeaders = options.allowedHeaders.join(',');
    }

    if (allowedHeaders != null && allowedHeaders.isNotEmpty) {
      headers.add(MapEntry('Access-Control-Allow-Headers', allowedHeaders));
    }

    return headers;
  }

  static MapEntry configureMaxAge(CorsOptions options) {
    if (options.maxAge != null) {
      return MapEntry(
        'Access-Control-Max-Age',
        options.maxAge.toString(),
      );
    }

    return null;
  }

  static MapEntry configureExposedHeaders(CorsOptions options) {
    String headers;

    if (headers == null) {
      return null;
    } else if (headers is List) {
      headers = options.exposedHeaders.join(',');
    }

    if (headers != null && headers.isNotEmpty) {
      return MapEntry('Access-Control-Expose-Headers', headers);
    }

    return null;
  }
}
