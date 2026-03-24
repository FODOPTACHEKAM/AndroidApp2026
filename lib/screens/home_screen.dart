import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_button.dart';
import 'configuration_screen.dart';
import 'upload_screen.dart';
import 'results_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildMenuCards(context),
                  const Spacer(flex: 2),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calculate,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppConstants.appName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appDescription,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMenuCards(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Configure Settings',
          icon: Icons.settings,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConfigurationScreen()),
            );
          },
          isOutlined: true,
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Upload Grades',
          icon: Icons.upload_file,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UploadScreen()),
            );
          },
        ),
        Consumer<AppState>(
          builder: (context, state, _) {
            if (state.students.isEmpty) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CustomButton(
                text: 'View Results',
                icon: Icons.bar_chart,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultsScreen()),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'Supported formats: Excel (.xlsx, .xls)',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          'Version 1.0.0',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
        ),
      ],
    );
  }
}