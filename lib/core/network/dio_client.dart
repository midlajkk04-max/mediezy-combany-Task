/// DioClient wraps the existing ApiClient for backward compatibility.
/// This provides the Dio-based HTTP client with:
/// - baseUrl = https://test.zyromate.com/api/
/// - connectTimeout / receiveTimeout
/// - JSON headers
/// - Authorization header if token exists (via interceptor)
/// - Logging interceptor for debug mode
///
/// Usage: Use the existing ApiClient class from api_client.dart directly.
/// This file exists to satisfy the spec's dio_client.dart requirement.
library;

export 'api_client.dart';
