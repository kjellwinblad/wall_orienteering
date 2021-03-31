from flask import Flask
from flask import request
import os
import json

app = Flask(__name__)

RESULT_LIST_DATA_FOLDER="result_list_data"

@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/get_result_list/<map_hash>')
def get_result_list(map_hash : str):
    result_file_path = os.path.join(RESULT_LIST_DATA_FOLDER, map_hash)
    try:
        with open(result_file_path) as f: 
            return f.read()
    except Exception as e:
        return {
                "map:": "the_map_data",
                "results": [
                    {"name": "Kjell Winblad",
                     "time": 23423423,
                     "route": "This is the route data"},
                    {"name": "Göran Winblad",
                     "time": 2342344,
                     "route": "This is the route data"}
                ]
                }


@app.route('/add_to_result_list/<map_hash>', methods=['POST'])
def add_to_result_list(map_hash : str):
    result_file_path = os.path.join(RESULT_LIST_DATA_FOLDER, map_hash)
    result_list = None
    print(request.get_json())
    result_item = request.get_json()
    try:
        with open(result_file_path) as f: 
            result_list = json.loads(f.read())
    except Exception as e:
        result_list = {
                "map:": map_hash,
                "results": []
                }
    result_list["results"].append(result_item)
    result_list["results"].sort(key=lambda x: x["time"])
    result_list_string : str = json.dumps(result_list)
    print(result_list_string)
    with open(result_file_path, 'wb') as f:
        f.write(result_list_string.encode("utf8"))
    return "ok"


    