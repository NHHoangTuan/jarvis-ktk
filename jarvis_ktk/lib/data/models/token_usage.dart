class TokenUsage {
  final int availableTokens;
  final int totalTokens;
  final bool unlimited;

  TokenUsage({
    required this.availableTokens,
    required this.totalTokens,
    required this.unlimited,
  });

  factory TokenUsage.fromJson(Map<String, dynamic> json) {
    return TokenUsage(
      availableTokens: json['availableTokens'],
      totalTokens: json['totalTokens'],
      unlimited: json['unlimited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableTokens': availableTokens,
      'totalTokens': totalTokens,
      'unlimited': unlimited,
    };
  }

  // Set
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
