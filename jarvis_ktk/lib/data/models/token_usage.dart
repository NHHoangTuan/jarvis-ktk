import 'package:json_annotation/json_annotation.dart';

part 'token_usage.g.dart';

@JsonSerializable()
class TokenUsage {
  final int availableTokens;
  final int totalTokens;
  final bool unlimited;

  TokenUsage({required this.availableTokens, required this.totalTokens, required this.unlimited});

  factory TokenUsage.fromJson(Map<String, dynamic> json) => _$TokenUsageFromJson(json);
  Map<String, dynamic> toJson() => _$TokenUsageToJson(this);

  TokenUsage copyWith({
    int? availableTokens,
    int? totalTokens,
    bool? unlimited,
  }) {
    return TokenUsage(
      availableTokens: availableTokens ?? this.availableTokens,
      totalTokens: totalTokens ?? this.totalTokens,
      unlimited: unlimited ?? this.unlimited,
    );
  }
}