/// Base Model
/// Base class for all data models
abstract class BaseModel {
  /// Convert model to JSON
  Map<String, dynamic> toJson();

  /// Create model from JSON
  BaseModel fromJson(Map<String, dynamic> json);
}
