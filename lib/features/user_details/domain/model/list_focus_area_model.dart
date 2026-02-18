class FocusAreaResponse {
  final bool status;
  final String message;
  final int currentPage;
  final List<FocusArea> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  FocusAreaResponse({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory FocusAreaResponse.fromJson(Map<String, dynamic> json) {
    return FocusAreaResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      currentPage: json['current_page'] ?? 0,

      // ✅ SAFE list parsing
      data: (json['data'] as List? ?? [])
          .map((e) => FocusArea.fromJson(e))
          .toList(),

      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      lastPageUrl: json['last_page_url'] ?? '',

      // ✅ SAFE links parsing
      links: (json['links'] as List? ?? [])
          .map((e) => PageLink.fromJson(e))
          .toList(),

      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
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

class FocusArea {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  FocusArea({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FocusArea.fromJson(Map<String, dynamic> json) {
    return FocusArea(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "display_name": displayName,
      "image_url": imageUrl,
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
