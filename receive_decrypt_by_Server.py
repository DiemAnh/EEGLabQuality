from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from Crypto.Random import get_random_bytes
import paho.mqtt.client as mqtt
import json
import pandas as pd

broker = 'localhost'
port = 1883
topic = "envData"
username = "EEGLabQuality"
passwd = "Iomt2024@"

key = b'toilakeydungthangnaoancap127890@'

def aes_256_cbc_decrypt(encrypted_text, key):
        # Extract the initialization vector (IV) from the beginning
        iv = encrypted_text[:AES.block_size]
        cipher = AES.new(key, AES.MODE_CBC, iv)

        #Decrypt and unpad the encrypted text
        decrypted_padded_text = cipher.decrypt(encrypted_text[AES.block_size:])
        decrypted_text = unpad(decrypted_padded_text, AES.block_size)

        return decrypted_text.decode()

file_path = "envData.tsv"

def save_to_tsv(dataframe):
        dataframe.to_csv(
                file_path, sep="\t", index=False, mode='w', header=True
        )

decrypted = pd.DataFrame()

def on_message(client, userdata, message):
        global decrypted

        encrypted = message.payload
        decrypted_message = aes_256_cbc_decrypt(encrypted, key)

        decrypted_json = json.loads(decrypted_message)
        decrypted_df = pd.DataFrame([decrypted_json])
        decrypted = pd.concat([decrypted, decrypted_df], ignore_index=True)

        save_to_tsv(decrypted)

        print(decrypted)

client = mqtt.Client()
client.username_pw_set(username, passwd)
client.on_message = on_message
client.connect(broker, port, 60)
client.subscribe(topic)
client.loop_forever()