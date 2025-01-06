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
                    child: 
                    Column(
                        children: [
                          const WeatherFrame(
                            icon: Icons.person, 
                            title: 'EEG',
                            subTitle: 'Experiment',
                            date:'Type: Concentration'),
                          Column(
                            children: [
                              Spacing.h8,
                              Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(left: 32, right: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sensors', style: TextStyles.t20M.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                                    TextButton(
                                      onPressed: (){}, 
                                      child: Text('See all', style: TextStyles.t16R.copyWith(color: Colors.blue)))
                                  ],
                                ),
                              ),     
                              Row(
                                children: [
                                  Spacing.v32,
                                  Column(
                                    children: [
                                      DeviceButton(
                                        onPressed: (){},
                                        color: Color.fromARGB(255, 253, 198, 202),
                                        icon: Icons.air),
                                      Spacing.h8,
                                      const Text('MQ-135')
                                    ],
                                  ),
                                  Spacing.v16,
                                  Column(
                                    children: [
                                      DeviceButton(
                                        onPressed: (){}, 
                                        icon: Icons.volume_up, 
                                        color: Color.fromARGB(255, 178, 240, 253)),
                                      Spacing.h8,
                                      const Text('MAX4466')
                                    ],
                                  ),
                                  Spacing.v16,
                                  Column(
                                    children: [
                                      DeviceButton(
                                        onPressed: (){}, 
                                        icon: Icons.light, 
                                        color: Color.fromRGBO(198, 253, 214, 1)),
                                      Spacing.h8,
                                      const Text('BH1750')
                                    ],
                                  ),
                                  Spacing.v16,
                                  Column(
                                    children: [
                                      DeviceButton(
                                        onPressed: (){}, 
                                        icon: Icons.sensors, 
                                        color: Color.fromRGBO(253, 248, 198, 1)),
                                      Spacing.h8,
                                      const Text('DHT11')
                                    ],
                                  ),
                                
                                ],
                              ),
                            ],
                          ),
                          Spacing.h8,
                          Column(
                            children:[
                              Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(left:32, right:32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Recently',style: TextStyles.t20M.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                                    TextButton(
                                      onPressed: (){}, 
                                      child: Text('See all',style: TextStyles.t16R.copyWith(color: Colors.blue)))
                                  ],
                                ),
                              ),
  
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: (
                                      Row(
                                        children: const [
                                          DataFrame(
                                            icon: Icons.light, 
                                            title: '0', 
                                            subTitle: 'Light',
                                            date: '6-1-2025'),
                                          DataFrame(
                                            icon: Icons.volume_up, 
                                            title: '74 dB', 
                                            subTitle: 'Volume',
                                            date: '6-1-2025'),
                                          Spacing.v32 
                                        ],
                                      )
                                    ),
                                    
                                  )
                                ],
                              ),
                              Spacing.h16,
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: (
                                      Row(
                                        children: const [
                                          DataFrame(
                                            icon: Icons.heat_pump, 
                                            title: '23 C', 
                                            subTitle: 'Temp',
                                            date: '6-1-2025'),
                                          DataFrame(
                                            icon: Icons.water_drop, 
                                            title: '26%', 
                                            subTitle: 'Humid',
                                            date: '6-1-2025'),
                                          Spacing.v32 
                                        ],
                                      )
                                    ),
                                    
                                  )
                                ],
                              ),
                            Spacing.h16,
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  SingleChildScrollView(
                                    
                                    child: (
                                      Row(
                                        children: const [
                                          DataFrame(
                                            icon: Icons.air, 
                                            title: '781', 
                                            subTitle: 'CO2',
                                            date: '6-1-2025'),
                                         
                                        ],
                                      )
                                    ),
                                    
                                  )
                                ],
                              ),
                            
                            ]
                          ),
                          Spacing.h8,
                          Column(
                            children:[
                              Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(left:32, right:32),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left:32),
                                    child: Text('Enviroment data',style: TextStyles.t16R, textAlign: TextAlign.start,),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: (
                                      Row(
                                        children: const [
                                          DataGraphs(),
                                          DataGraphs(),
                                          DataGraphs(),
                                          Spacing.v32  
                                        ],
                                      )
                                    ), 
                                  )
                                ],
                              ),
                              Spacing.h16,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Padding(
                                    padding: EdgeInsets.only(left:32),
                                    child: Text(
                      _tsvData,
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: (
                                      Row(
                                        children: const [
                                          DataGraphs(),
                                          DataGraphs(),
                                          Spacing.v32 
                                        ],
                                      )
                                    ), 
                                  ),
                                  Spacing.h32
                                ],
                              ),
                            ]
                          )
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
