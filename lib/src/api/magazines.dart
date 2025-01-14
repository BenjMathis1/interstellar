import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interstellar/src/utils/utils.dart';

import './shared.dart';

class Magazines {
  late List<DetailedMagazine> items;
  late Pagination pagination;

  Magazines({required this.items, required this.pagination});

  Magazines.fromJson(Map<String, dynamic> json) {
    items = <DetailedMagazine>[];
    json['items'].forEach((v) {
      items.add(DetailedMagazine.fromJson(v));
    });

    pagination = Pagination.fromJson(json['pagination']);
  }
}

class DetailedMagazine {
  late Moderator owner;
  Image? icon;
  late String name;
  late String title;
  String? description;
  String? rules;
  late int subscriptionsCount;
  late int entryCount;
  late int entryCommentCount;
  late int postCount;
  late int postCommentCount;
  late bool isAdult;
  bool? isUserSubscribed;
  bool? isBlockedByUser;
  List<String>? tags;
  List<Moderator>? moderators;
  String? apId;
  String? apProfileId;
  late int magazineId;

  DetailedMagazine(
      {required this.owner,
      this.icon,
      required this.name,
      required this.title,
      this.description,
      this.rules,
      required this.subscriptionsCount,
      required this.entryCount,
      required this.entryCommentCount,
      required this.postCount,
      required this.postCommentCount,
      required this.isAdult,
      this.isUserSubscribed,
      this.isBlockedByUser,
      this.tags,
      this.moderators,
      this.apId,
      this.apProfileId,
      required this.magazineId});

  DetailedMagazine.fromJson(Map<String, dynamic> json) {
    owner = Moderator.fromJson(json['owner']);
    icon = json['icon'] != null ? Image.fromJson(json['icon']) : null;
    name = json['name'];
    title = json['title'];
    description = json['description'];
    rules = json['rules'];
    subscriptionsCount = json['subscriptionsCount'];
    entryCount = json['entryCount'];
    entryCommentCount = json['entryCommentCount'];
    postCount = json['postCount'];
    postCommentCount = json['postCommentCount'];
    isAdult = json['isAdult'];
    isUserSubscribed = json['isUserSubscribed'];
    isBlockedByUser = json['isBlockedByUser'];
    tags = json['tags']?.cast<String>();
    if (json['moderators'] != null) {
      moderators = <Moderator>[];
      json['moderators'].forEach((v) {
        moderators!.add(Moderator.fromJson(v));
      });
    }
    apId = json['apId'];
    apProfileId = json['apProfileId'];
    magazineId = json['magazineId'];
  }
}

class Moderator {
  late int magazineId;
  late int userId;
  Image? avatar;
  late String username;
  String? apId;

  Moderator(
      {required this.magazineId,
      required this.userId,
      this.avatar,
      required this.username,
      this.apId});

  Moderator.fromJson(Map<String, dynamic> json) {
    magazineId = json['magazineId'];
    userId = json['userId'];
    avatar = json['avatar'] != null ? Image.fromJson(json['avatar']) : null;
    username = json['username'];
    apId = json['apId'];
  }
}

enum MagazinesSort { active, hot, newest }

Future<Magazines> fetchMagazines(
  http.Client client,
  String instanceHost, {
  int? page,
  MagazinesSort? sort,
  String? search,
}) async {
  final response = await client.get(Uri.https(instanceHost, '/api/magazines',
      {'p': page?.toString(), 'sort': sort?.name, 'q': search}));

  httpErrorHandler(response, message: 'Failed to load magazines');

  return Magazines.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<DetailedMagazine> fetchMagazine(
  http.Client client,
  String instanceHost,
  int magazineId,
) async {
  final response =
      await client.get(Uri.https(instanceHost, '/api/magazine/$magazineId'));

  httpErrorHandler(response, message: 'Failed to load magazine');

  return DetailedMagazine.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>);
}

Future<DetailedMagazine> putSubscribe(
  http.Client client,
  String instanceHost,
  int magazineId,
  bool state,
) async {
  final response = await client.put(Uri.https(
    instanceHost,
    '/api/magazine/$magazineId/${state ? 'subscribe' : 'unsubscribe'}',
  ));

  httpErrorHandler(response, message: 'Failed to send subscribe');

  return DetailedMagazine.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>);
}
