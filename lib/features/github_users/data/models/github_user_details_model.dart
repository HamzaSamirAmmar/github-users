import 'package:github_users/features/github_users/domain/entities/github_user_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_user_details_model.g.dart';

@JsonSerializable()
class GithubUserDetailsModel extends GithubUserDetails {
  const GithubUserDetailsModel({
    required super.id,
    required super.login,
    required super.avatarUrl,
    required super.htmlUrl,
    required super.publicRepos,
    super.updatedAt,
  });

  factory GithubUserDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GithubUserDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GithubUserDetailsModelToJson(this);
}
