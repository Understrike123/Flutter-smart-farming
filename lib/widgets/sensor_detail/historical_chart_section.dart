import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoricalChartSection extends StatefulWidget {
  const HistoricalChartSection({super.key});

  @override
  State<HistoricalChartSection> createState() => _HistoricalChartSectionState();
}

class _HistoricalChartSectionState extends State<HistoricalChartSection> {
  int _selectedIntervalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Historis: Kelembaban Tanah Zona 1', // Ini bisa dibuat dinamis nanti
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: LineChart(
            mainData(), // Memanggil data grafik
            duration: const Duration(milliseconds: 250),
          ),
        ),
        const SizedBox(height: 20),
        _buildIntervalSelector(),
      ],
    );
  }

  // Widget untuk pemilih interval waktu (24 Jam, 7 Hari, 30 Hari)
  Widget _buildIntervalSelector() {
    return Center(
      child: ToggleButtons(
        isSelected: List.generate(
          3,
          (index) => index == _selectedIntervalIndex,
        ),
        onPressed: (int index) {
          setState(() {
            _selectedIntervalIndex = index;
            // TODO: Tambahkan logika untuk mengubah data grafik berdasarkan interval
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

  // Konfigurasi utama untuk LineChart dari package fl_chart
  LineChartData mainData() {
    final lineColor = Theme.of(context).primaryColor;

    // Data dummy untuk grafik
    final List<FlSpot> spots = [
      const FlSpot(0, 70),
      const FlSpot(2, 55),
      const FlSpot(4, 40),
      const FlSpot(6, 50),
      const FlSpot(8, 45),
      const FlSpot(10, 35),
      const FlSpot(12, 50),
      const FlSpot(14, 65),
      const FlSpot(16, 75),
      const FlSpot(18, 60),
      const FlSpot(20, 65),
      const FlSpot(22, 70),
      const FlSpot(23, 68),
    ];

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
            interval: 6,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.black54, fontSize: 12);
              String text;
              switch (value.toInt()) {
                case 0:
                  text = '12:00';
                  break;
                case 6:
                  text = '18:00';
                  break;
                case 12:
                  text = '00:00';
                  break;
                case 18:
                  text = '06:00';
                  break;
                default:
                  return Container();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(text, style: style),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 30,
            getTitlesWidget: (value, meta) {
              if (value == 0 || value == 40 || value == 70 || value == 100) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                  textAlign: TextAlign.left,
                );
              }
              return Container();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
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
      // Menambahkan garis putus-putus sebagai target/batas
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 30, // Nilai y untuk garis
            color: Colors.orange.withOpacity(0.8),
            strokeWidth: 2,
            dashArray: [5, 5], // Membuat garis menjadi putus-putus
          ),
        ],
      ),
    );
  }
}
