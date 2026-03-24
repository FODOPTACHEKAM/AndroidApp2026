class Grade {
  final String subject;
  final double value;
  final double coefficient;
  
  const Grade({
    required this.subject,
    required this.value,
    required this.coefficient,
  });
  
  bool get isValid => value >= 0 && value <= 20 && coefficient > 0;
  
  Grade copyWith({
    String? subject,
    double? value,
    double? coefficient,
  }) {
    return Grade(
      subject: subject ?? this.subject,
      value: value ?? this.value,
      coefficient: coefficient ?? this.coefficient,
    );
  }
}