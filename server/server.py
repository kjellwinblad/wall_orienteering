from flask import Flask
from flask import request
import os
import json
import db

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/get_result_list/<map_hash>')
def get_result_list(map_hash : str):
    return json.dumps({
             "map:": map_hash,
             "results": db.get_result_list(map_hash)
           })


@app.route('/add_to_result_list/<map_hash>', methods=['POST'])
def add_to_result_list(map_hash : str):
    result_item = request.get_json()
    print(result_item)
    db.add_result_item(result_item['name'], result_item['time'], result_item['route'], map_hash)
    return "ok"


    