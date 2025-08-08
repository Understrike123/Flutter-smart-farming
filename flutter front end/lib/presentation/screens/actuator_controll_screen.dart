import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/actuator_provider.dart';
import '../widgets/actuator_controll/actuator_card.dart';

class ActuatorControlScreen extends StatefulWidget {
  const ActuatorControlScreen({super.key});

  @override
  State<ActuatorControlScreen> createState() => _ActuatorControlScreenState();
}

class _ActuatorControlScreenState extends State<ActuatorControlScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActuatorProvider>(context, listen: false).fetchActuators();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: const Text('Kontrol Aktuator')),
      body: Consumer<ActuatorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.actuators.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchActuators(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.actuators.length,
              itemBuilder: (context, index) {
                final actuator = provider.actuators[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ActuatorCard(
                    actuatorData: actuator,
                    onStatusCommand: (command) {
                      provider.sendCommand(actuator.id, command);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
