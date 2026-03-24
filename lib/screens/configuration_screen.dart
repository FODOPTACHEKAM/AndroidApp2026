import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late TextEditingController _subjectsController;
  late TextEditingController _maxGradeController;
  
  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppState>(context, listen: false);
    _subjectsController = TextEditingController(text: state.totalSubjects.toString());
    _maxGradeController = TextEditingController(text: state.maxGrade.toString());
  }
  
  @override
  void dispose() {
    _subjectsController.dispose();
    _maxGradeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildConfigurationForm(),
                const Spacer(),
                _buildSaveButton(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 48, color: Color(0xFF667eea)),
            const SizedBox(height: 12),
            Text(
              'Configuration Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Set the total number of subjects and maximum grade for your calculation',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfigurationForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _subjectsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Number of Subjects',
                prefixIcon: Icon(Icons.subject),
                border: OutlineInputBorder(),
                helperText: 'Enter the total subjects for calculation',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _maxGradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Maximum Grade',
                prefixIcon: Icon(Icons.star),
                border: OutlineInputBorder(),
                helperText: 'Enter the maximum possible grade (e.g., 20)',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Grades will be calculated based on ${_subjectsController.text} subjects with a maximum of ${_maxGradeController.text} points',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
      text: 'Save Configuration',
      icon: Icons.save,
      onPressed: () {
        final state = Provider.of<AppState>(context, listen: false);
        
        final subjects = int.tryParse(_subjectsController.text);
        if (subjects != null && subjects > 0) {
          state.setTotalSubjects(subjects);
        }
        
        final maxGrade = double.tryParse(_maxGradeController.text);
        if (maxGrade != null && maxGrade > 0) {
          state.setMaxGrade(maxGrade);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuration saved successfully')),
        );
        
        Navigator.pop(context);
      },
    );
  }
}