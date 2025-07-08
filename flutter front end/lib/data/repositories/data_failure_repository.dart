// Kelas dasar untuk semua jenis kegagalan
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Kegagalan spesifik untuk server atau data dummy
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}
