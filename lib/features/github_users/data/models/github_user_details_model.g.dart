// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_user_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubUserDetailsModel _$GithubUserDetailsModelFromJson(
  Map<String, dynamic> json,
) => GithubUserDetailsModel(
  id: (json['id'] as num).toInt(),
  login: json['login'] as String,
  avatarUrl: json['avatar_url'] as String,
  htmlUrl: json['html_url'] as String,
  publicRepos: (json['public_repos'] as num).toInt(),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$GithubUserDetailsModelToJson(
  GithubUserDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'login': instance.login,
  'avatar_url': instance.avatarUrl,
  'html_url': instance.htmlUrl,
  'public_repos': instance.publicRepos,
  if (instance.updatedAt?.toIso8601String() case final value?)
    'updated_at': value,
};
