import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Dibutuhkan untuk memformat tanggal di sumbu grafik
import '../../providers/sensor_provider.dart';

// Widget utama, sekarang bisa menjadi StatelessWidget karena data diambil dari luar
class HistoricalChartSection extends StatelessWidget {
  const HistoricalChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk "mendengarkan" perubahan dari SensorProvider
    return Consumer<SensorProvider>(
      builder: (context, provider, child) {
        // 1. Tampilkan loading indicator saat data sedang diambil
        if (provider.isLoadingHistory) {
          return const SizedBox(
            height: 250, // Beri tinggi agar layout tidak "loncat"
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Tampilkan pesan jika tidak ada data riwayat
        if (provider.history.isEmpty) {
          return const SizedBox(
            height: 250,
            child: Center(child: Text('Data riwayat tidak tersedia.')),
          );
        }

        // 3. Jika data ada, tampilkan grafik dan tombol interval
        return Column(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                // Kirim data yang sudah diolah ke fungsi pembuat grafik
                _mainChartData(context, provider),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            const SizedBox(height: 20),
            // Gunakan widget terpisah untuk tombol agar state-nya terisolasi
            const _IntervalSelector(),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengkonfigurasi dan membuat data LineChart
  LineChartData _mainChartData(BuildContext context, SensorProvider provider) {
    final lineColor = Theme.of(context).primaryColor;

    // 4. Ubah data dari List<SensorHistory> menjadi List<FlSpot> yang dimengerti grafik
    final spots = provider.history.asMap().entries.map((entry) {
      // Sumbu X adalah indeks (0, 1, 2, ...), Sumbu Y adalah nilai sensor
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // Buat interval label sumbu X dinamis agar tidak terlalu padat
            interval: (provider.history.length / 4).ceilToDouble(),
            getTitlesWidget: (value, meta) {
              // Pastikan tidak mencoba mengakses indeks di luar jangkauan
              if (value.toInt() >= provider.history.length) return Container();
              final timestamp = provider.history[value.toInt()].timestamp;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  DateFormat('HH:mm').format(timestamp), // Format waktu
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              // Tampilkan label sumbu Y dengan format angka bulat
              return Text(
                '${value.toInt()}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots, // Gunakan data spots yang sudah diolah
          isCurved: true,
          gradient: LinearGradient(
            colors: [lineColor, lineColor.withOpacity(0.5)],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [lineColor.withOpacity(0.3), lineColor.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      // ... Anda bisa menambahkan extraLinesData di sini jika perlu
    );
  }
}

// Widget stateful terpisah untuk mengelola state tombol interval (24 Jam, 7 Hari, dll.)
// Ini adalah praktik yang baik untuk menjaga agar state UI tidak tercampur dengan logika data.
class _IntervalSelector extends StatefulWidget {
  const _IntervalSelector();

  @override
  State<_IntervalSelector> createState() => __IntervalSelectorState();
}

class __IntervalSelectorState extends State<_IntervalSelector> {
  int _selectedIntervalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        isSelected: List.generate(
          3,
          (index) => index == _selectedIntervalIndex,
        ),
        onPressed: (int index) {
          setState(() {
            _selectedIntervalIndex = index;
            // TODO: Panggil method di SensorProvider untuk memuat data sesuai interval baru
            // Contoh: context.read<SensorProvider>().fetchSensorHistoryForInterval(widget.sensorId, index);
          });
        },
        borderRadius: BorderRadius.circular(8.0),
        selectedColor: Colors.white,
        fillColor: Theme.of(context).primaryColor,
        color: Theme.of(context).primaryColor,
        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
        children: const [Text('24 Jam'), Text('7 Hari'), Text('30 Hari')],
      ),
    );
  }
}
