import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iomt_eeg_lab_quality/themes/spacing.dart';
import 'package:iomt_eeg_lab_quality/themes/text_styles.dart';
import 'package:iomt_eeg_lab_quality/widget/data_frame.dart';
import 'package:iomt_eeg_lab_quality/widget/data_graph.dart';
import 'package:iomt_eeg_lab_quality/widget/device_button.dart';
import 'package:iomt_eeg_lab_quality/widget/weather_frame.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EEG Quality Data',
      theme: ThemeData(
        primaryColor: Colors.white, // Set the primary color to white
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white, // Make the app bar background white
        foregroundColor: Colors.black, // Set text color on app bar to black (for visibility)
      ),
      scaffoldBackgroundColor: Colors.white, // Set the background color of the scaffold to white
      primarySwatch: Colors.blue, 
      ),
      home: TSVFileViewer(),
    );
  }
}

class TSVFileViewer extends StatefulWidget {
  @override
  _TSVFileViewerState createState() => _TSVFileViewerState();
}

class _TSVFileViewerState extends State<TSVFileViewer> {
  String _tsvData = '';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTSVData();
  }

  // Fetch the TSV data from the Linux server
  Future<void> _fetchTSVData() async {
    // Replace with your Tailscale IP address and port
    String url = 'http://100.84.254.69:8000/envData.tsv';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _tsvData = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load TSV file. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Function to parse TSV data into rows and columns
  List<List<String>> _parseTSV(String tsvData) {
    List<List<String>> rows = [];
    List<String> lines = tsvData.split('\n');
    
    // Find the maximum number of columns in any row
    int maxColumns = lines.map((line) => line.split('\t').length).reduce((a, b) => a > b ? a : b);

    for (String line in lines) {
      List<String> columns = line.split('\t');
      // Pad rows with fewer columns with empty strings
      while (columns.length < maxColumns) {
        columns.add('');
      }
      rows.add(columns);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EEG Quality Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        const WeatherFrame(
                            icon: Icons.person, 
                            title: 'EEG',
                            subTitle: 'Experiment',
                            date: 'Type: Concentration'),
                        // Additional sections go here ...

                        // Display TSV data as a table
                        Spacing.h16,
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Table',style: TextStyles.t20M.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                              TextButton(
                                onPressed: (){}, 
                                child: Text('See all',style: TextStyles.t16R.copyWith(color: Colors.blue)))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 32),
                          child: Text(
                            'Enviroment data',
                            style: TextStyles.t16R,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Spacing.h16,
                        // Table view for TSV data
                        _tsvData.isNotEmpty
                            ? Table(
                                border: TableBorder.all(),
                                children: _parseTSV(_tsvData).map((row) {
                                  return TableRow(
                                    children: row.map((cell) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(cell, style: TextStyle(fontFamily: 'monospace')),
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              )
                            : Center(
                                child: Text('No TSV data available', style: TextStyle(color: Colors.red)),
                              ),
                        Spacing.h32,
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
      ),
    );
  }
}
