from flask import Flask, jsonify
import pandas as pd

app = Flask(__name__)

# Đọc dữ liệu từ file TSV
@app.route('/data', methods=['GET'])
def get_data():
    file_path = "envData.tsv"  # Đường dẫn đến file TSV
    try:
        data = pd.read_csv(file_path, sep="\t")
        return jsonify(data.to_dict(orient='records'))
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="100.84.254.69", port=5000)

#Đọc dữ liệu từ cổng, CMD: python3 -m http.server 8000