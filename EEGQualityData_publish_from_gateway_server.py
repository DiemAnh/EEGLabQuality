import serial
import time
from datetime import datetime
import paho.mqtt.client as mqtt
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Random import get_random_bytes
import json

bluetooth=serial.Serial('/dev/rfcomm7',9600)

while True:                                                                             
    data = bluetooth.readline().decode('utf-8').strip()
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    data_json = json.loads(data)
    data_json["timestamp"] = timestamp
    data_str = json.dumps(data_json)
    print(data_json)
    
    def aes_256_cbc_encrypt(plain_text, key):
        iv = get_random_bytes(AES.block_size)
            
        cipher = AES.new(key, AES.MODE_CBC, iv)
        
        padded_text = pad(plain_text.encode(), AES.block_size)
        
        encrypted_text = cipher.encrypt(padded_text)
        
        return iv + encrypted_text

    key = b'toilakeydungthangnaoancap127890@'
    plain_text = data_str
    
    broker = '192.168.78.37'
    port = 1883
    username = 'EEGLabQuality'
    passwd = 'Iomt2024@'
    topic = 'envData'
    message = aes_256_cbc_encrypt(plain_text, key)
    
    print(message)
    
    client = mqtt.Client()
    client.username_pw_set(username, passwd)
    client.connect(broker, port, 60)
    client.publish(topic, message)