class MasterGoalResponse {
  final bool status;
  final String message;

  // Pagination (optional)
  final int? currentPage;
  final List<MasterGoal> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  MasterGoalResponse({
    required this.status,
    required this.message,
    required this.data,
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links = const [],
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory MasterGoalResponse.fromJson(Map<String, dynamic> json) {
    return MasterGoalResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',

      // ✅ Works whether API is paginated or not
      data: (json['data'] as List? ?? [])
          .map((e) => MasterGoal.fromJson(e))
          .toList(),

      currentPage: json['current_page'],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],

      // ✅ NEVER crashes now
      links: (json['links'] as List? ?? [])
          .map((e) => PageLink.fromJson(e))
          .toList(),

      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "current_page": currentPage,
      "data": data.map((e) => e.toJson()).toList(),
      "first_page_url": firstPageUrl,
      "from": from,
      "last_page": lastPage,
      "last_page_url": lastPageUrl,
      "links": links.map((e) => e.toJson()).toList(),
      "next_page_url": nextPageUrl,
      "path": path,
      "per_page": perPage,
      "prev_page_url": prevPageUrl,
      "to": to,
      "total": total,
    };
  }
}

class MasterGoal {
  final int id;
  final String name;
  final String displayName;
  final int status;
  final String createdAt;
  final String updatedAt;

  MasterGoal({
    required this.id,
    required this.name,
    required this.displayName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MasterGoal.fromJson(Map<String, dynamic> json) {
    return MasterGoal(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "display_name": displayName,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({this.url, required this.label, required this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {"url": url, "label": label, "active": active};
  }
}
