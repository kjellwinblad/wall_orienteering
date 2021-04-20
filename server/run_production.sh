#!/bin/bash

source venv/bin/activate

export FLASK_APP=server.py

export FLASK_ENV=production

flask run --port=5021
