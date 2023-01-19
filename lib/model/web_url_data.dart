class MobileApiResponse {
  MobileApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  final int? status;
  final List<MobileApiData> data;
  final String? message;

  factory MobileApiResponse.fromJson(Map<String, dynamic> json){
    return MobileApiResponse(
      status: json["status"],
      data: json["data"] == null ? [] : List<MobileApiData>.from(json["data"]!.map((x) => MobileApiData.fromJson(x))),
      message: json["message"],
    );
  }

}

class MobileApiData {
  MobileApiData({
    required this.id,
    required this.name,
    required this.link,
  });

  final int? id;
  final String? name;
  final String? link;

  factory MobileApiData.fromJson(Map<String, dynamic> json){
    return MobileApiData(
      id: json["id"],
      name: json["name"],
      link: json["link"],
    );
  }

}