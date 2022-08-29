// To parse this JSON data, do
//
//     final getCass = getCassFromJson(jsonString);

import 'dart:convert';

GetCass getCassFromJson(String str) => GetCass.fromJson(json.decode(str));

String getCassToJson(GetCass data) => json.encode(data.toJson());

class GetCass {
  GetCass({
    required this.id,
    required this.Get_Cast,
    required this.crew,
  });

  int id;
  List<GetCass> Get_Cast;
  List<GetCass> crew;

  factory GetCass.fromJson(Map<String, dynamic> json) => GetCass(
        id: json["id"],
        Get_Cast: List<GetCass>.from(
            json["Get_Cast"].map((x) => GetCass.fromJson(x))),
        crew: List<GetCass>.from(json["crew"].map((x) => GetCass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Get_Cast": List<dynamic>.from(Get_Cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class Get_Cast {
  Get_Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.Get_CastId,
    required this.character,
    required this.creditId,
    required this.order,
    required this.department,
    required this.job,
  });

  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int Get_CastId;
  String character;
  String creditId;
  int order;
  String department;
  String job;

  factory Get_Cast.fromJson(Map<String, dynamic> json) => Get_Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        Get_CastId: json["Get_Cast_id"] == null ? null : json["Get_Cast_id"],
        character: json["character"] == null ? null : json["character"],
        creditId: json["credit_id"],
        order: json["order"] == null ? null : json["order"],
        department: json["department"] == null ? null : json["department"],
        job: json["job"] == null ? null : json["job"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath == null ? null : profilePath,
        "Get_Cast_id": Get_CastId == null ? null : Get_CastId,
        "character": character == null ? null : character,
        "credit_id": creditId,
        "order": order == null ? null : order,
        "department": department == null ? null : department,
        "job": job == null ? null : job,
      };
}
