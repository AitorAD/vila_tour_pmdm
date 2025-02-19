import 'dart:convert';

class ResponseRouteAPI {
  List<double> bbox;
  List<_Route> routes;
  _Metadata metadata;

  ResponseRouteAPI({
    required this.bbox,
    required this.routes,
    required this.metadata,
  });

  factory ResponseRouteAPI.fromJson(String str) =>
      ResponseRouteAPI.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseRouteAPI.fromMap(Map<String, dynamic> json) =>
      ResponseRouteAPI(
        bbox: List<double>.from(json["bbox"].map((x) => x?.toDouble())),
        routes: List<_Route>.from(json["routes"].map((x) => _Route.fromMap(x))),
        metadata: _Metadata.fromMap(json["metadata"]),
      );

  Map<String, dynamic> toMap() => {
        "bbox": List<dynamic>.from(bbox.map((x) => x)),
        "routes": List<dynamic>.from(routes.map((x) => x.toMap())),
        "metadata": metadata.toMap(),
      };
}

class _Metadata {
  String attribution;
  String service;
  int timestamp;
  _Query query;
  _Engine engine;

  _Metadata({
    required this.attribution,
    required this.service,
    required this.timestamp,
    required this.query,
    required this.engine,
  });

  factory _Metadata.fromJson(String str) => _Metadata.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Metadata.fromMap(Map<String, dynamic> json) => _Metadata(
        attribution: json["attribution"],
        service: json["service"],
        timestamp: json["timestamp"],
        query: _Query.fromMap(json["query"]),
        engine: _Engine.fromMap(json["engine"]),
      );

  Map<String, dynamic> toMap() => {
        "attribution": attribution,
        "service": service,
        "timestamp": timestamp,
        "query": query.toMap(),
        "engine": engine.toMap(),
      };
}

class _Engine {
  String version;
  DateTime buildDate;
  DateTime graphDate;

  _Engine({
    required this.version,
    required this.buildDate,
    required this.graphDate,
  });

  factory _Engine.fromJson(String str) => _Engine.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Engine.fromMap(Map<String, dynamic> json) => _Engine(
        version: json["version"],
        buildDate: DateTime.parse(json["build_date"]),
        graphDate: DateTime.parse(json["graph_date"]),
      );

  Map<String, dynamic> toMap() => {
        "version": version,
        "build_date": buildDate.toIso8601String(),
        "graph_date": graphDate.toIso8601String(),
      };
}

class _Query {
  List<List<double>> coordinates;
  String profile;
  String profileName;
  String format;

  _Query({
    required this.coordinates,
    required this.profile,
    required this.profileName,
    required this.format,
  });

  factory _Query.fromJson(String str) => _Query.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Query.fromMap(Map<String, dynamic> json) => _Query(
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        profile: json["profile"],
        profileName: json["profileName"],
        format: json["format"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "profile": profile,
        "profileName": profileName,
        "format": format,
      };
}

class _Route {
  _Summary summary;
  List<_Segment> segments;
  List<double> bbox;
  String geometry;
  List<int> wayPoints;

  _Route({
    required this.summary,
    required this.segments,
    required this.bbox,
    required this.geometry,
    required this.wayPoints,
  });

  factory _Route.fromJson(String str) => _Route.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Route.fromMap(Map<String, dynamic> json) => _Route(
        summary: _Summary.fromMap(json["summary"]),
        segments:
            List<_Segment>.from(json["segments"].map((x) => _Segment.fromMap(x))),
        bbox: List<double>.from(json["bbox"].map((x) => x?.toDouble())),
        geometry: json["geometry"],
        wayPoints: List<int>.from(json["way_points"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "summary": summary.toMap(),
        "segments": List<dynamic>.from(segments.map((x) => x.toMap())),
        "bbox": List<dynamic>.from(bbox.map((x) => x)),
        "geometry": geometry,
        "way_points": List<dynamic>.from(wayPoints.map((x) => x)),
      };
}

class _Segment {
  double distance;
  double duration;
  List<_Step> steps;

  _Segment({
    required this.distance,
    required this.duration,
    required this.steps,
  });

  factory _Segment.fromJson(String str) => _Segment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Segment.fromMap(Map<String, dynamic> json) => _Segment(
        distance: json["distance"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        steps: List<_Step>.from(json["steps"].map((x) => _Step.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "duration": duration,
        "steps": List<dynamic>.from(steps.map((x) => x.toMap())),
      };
}

class _Step {
  double distance;
  double duration;
  int type;
  String instruction;
  String name;
  List<int> wayPoints;

  _Step({
    required this.distance,
    required this.duration,
    required this.type,
    required this.instruction,
    required this.name,
    required this.wayPoints,
  });

  factory _Step.fromJson(String str) => _Step.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Step.fromMap(Map<String, dynamic> json) => _Step(
        distance: json["distance"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        type: json["type"],
        instruction: json["instruction"],
        name: json["name"],
        wayPoints: List<int>.from(json["way_points"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "duration": duration,
        "type": type,
        "instruction": instruction,
        "name": name,
        "way_points": List<dynamic>.from(wayPoints.map((x) => x)),
      };
}

class _Summary {
  double distance;
  double duration;

  _Summary({
    required this.distance,
    required this.duration,
  });

  factory _Summary.fromJson(String str) => _Summary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Summary.fromMap(Map<String, dynamic> json) => _Summary(
        distance: json["distance"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "duration": duration,
      };
}
