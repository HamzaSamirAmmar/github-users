import 'package:github_users/features/github_users/domain/entities/github_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_user_model.g.dart';

@JsonSerializable()
class GithubUserModel extends GithubUser {
  const GithubUserModel({
    required super.id,
    required super.login,
    required super.avatarUrl,
    required super.htmlUrl,
  });

  factory GithubUserModel.fromJson(Map<String, dynamic> json) =>
      _$GithubUserModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$GithubUserModelToJson(this);
}
