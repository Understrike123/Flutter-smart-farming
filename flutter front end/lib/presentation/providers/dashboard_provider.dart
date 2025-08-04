import 'package:flutter/foundation.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

class DashboardProvider with ChangeNotifier {
  final GetDashboardSummary getDashboardSummary;

  DashboardProvider({required this.getDashboardSummary});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashboardSummary? _dashboardSummary;
  DashboardSummary? get dashboardSummary => _dashboardSummary;

  Future<void> fetchDashboardSummary() async {
    _isLoading = true;
    notifyListeners();

    final result = await getDashboardSummary();
    result.fold(
      (failure) => print(failure.message),
      (summary) => _dashboardSummary = summary,
    );

    _isLoading = false;
    notifyListeners();
  }
}
