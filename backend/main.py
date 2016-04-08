import flask
from flask import Flask, request, session
from DB import UserRepo
from datetime import datetime
from uuid import uuid4
import json

app = Flask(__name__)

class User:
    def __init__(self, json):
        self.email = json['email']
        self.phone = json['phone']
        self.contacts = json['contacts']
        self.uid = str(uuid4())

def auth():
    def decorator(f):
        uid = request.header.get('UID')
        user = user_repo.get_user_by_uid(uid)
        if user is not None:
            return flask.Response(status=401)
        else:
            return f()
    return decorator


@app.route('/users', methods=['POST'])
def create_user():
    xist = user_repo.get_user_by_phone(request.json['phone'])
    if xist is None:
        xist = User(request.json)
        user_repo.create_user(xist)
    del xist['_id']
    return json.dumps(xist)


@app.route('/')
def index():
    return 'It\'s an API, you idiot!'

user_repo = UserRepo()
if __name__ == '__main__':
    app.run('10.131.56.133')