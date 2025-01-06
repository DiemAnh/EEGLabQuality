# EEGLabQuality

A recent study has shown that indoor environmental factors like light, temperature, humidity, and air quality can impact brainwave activity, affecting the accuracy of EEG measurements. To improve precision in EEG experiments, we want to develope an IoT device that continuously monitors and adjusts these environmental factors in real-time to ensure that EEG measurements more accurately reflect true changes in brain activity. This system may face challenges when malicious people want to sent unauthorized data or attack DoS.
<img width="647" alt="block diagram" src="https://github.com/user-attachments/assets/f11fe1b8-0246-4896-becb-c2dff7dd4cb5" />
<img width="620" alt="flowchart" src="https://github.com/user-attachments/assets/9f17b321-e235-4bb4-a6db-a906f0d81adf" />
Data in the storage will be displayed in a flutter app for monitoring environment parameters
![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-06 at 00 44 43](https://github.com/user-attachments/assets/774133da-cffb-43b4-877b-ebab926767b9)
##Results
We have designed an IoMT gateway with security purpose by applying AES-2565-CBC 
We implemented an IoMT node to test the data sent to the gateway and server to store data. A flutter app is applied to display the results from environment data 
##Challenges
The node modules are affected by the loosely wire 
If the module is impacted, the first bit of data sent from arduino is incorrect format, which cause the lost of data 
We haven’t check other scenarios, as the hacker sends the data with another topic may the server verify the authority of the data 
