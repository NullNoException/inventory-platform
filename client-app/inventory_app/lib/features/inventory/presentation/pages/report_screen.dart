import 'dart:io';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/services/report_generation_service.dart';

enum ReportType { inventoryStock, transactions, lowStock }

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late ReportGenerationService _reportService;
  // Default report type
  ReportType _selectedReportType = ReportType.inventoryStock;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  bool _isGenerating = false;
  String? _errorMessage;
  File? _generatedReport;

  @override
  void initState() {
    super.initState();
    _reportService = context.read<ReportGenerationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ReportType>(
                      value: _selectedReportType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ReportType.inventoryStock,
                          child: Text('Inventory Stock Report'),
                        ),
                        DropdownMenuItem(
                          value: ReportType.transactions,
                          child: Text('Transaction History Report'),
                        ),
                        DropdownMenuItem(
                          value: ReportType.lowStock,
                          child: Text('Low Stock Alert Report'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedReportType = value;
                          });
                        }
                      },
                    ),
                    if (_selectedReportType == ReportType.transactions) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Date Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectStartDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(_startDate),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectEndDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(_endDate),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _generateReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            _isGenerating
                                ? const CircularProgressIndicator()
                                : const Text('Generate Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            if (_generatedReport != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generated Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'File: ${_generatedReport!.path.split('/').last}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _shareReport(),
                          icon: const Icon(Icons.share),
                          label: const Text('Share Report'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: _endDate,
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _generatedReport = null;
    });

    try {
      final result = await _generateSelectedReport();

      result.fold(
        (failure) {
          setState(() {
            _errorMessage = failure.message;
            _isGenerating = false;
          });
        },
        (report) {
          setState(() {
            _generatedReport = report;
            _isGenerating = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating report: $e';
        _isGenerating = false;
      });
    }
  }

  Future<void> _shareReport() async {
    if (_generatedReport != null) {
      await _reportService.shareReport(_generatedReport!);
    }
  }

  Future<Either<Failure, File>> _generateSelectedReport() {
    switch (_selectedReportType) {
      case ReportType.inventoryStock:
        return _reportService.generateInventoryStockReport();
      case ReportType.transactions:
        return _reportService.generateTransactionReport(_startDate, _endDate);
      case ReportType.lowStock:
        return _reportService.generateLowStockReport();
    }
  }
}
