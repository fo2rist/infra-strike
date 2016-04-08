import pymongo
from pymongo import MongoClient

class Repo:
    def __init__(self):
        self.client = MongoClient('localhost')
        self.db = self.client['hackathon']

class UserRepo (Repo):

    def create_user(self, user):
        users = self.db.users
        inserted_id = users.insert_one(user.__dict__).inserted_id
        return str(inserted_id)

    def get_user_by_phone(self, phone):
        users = self.db.users
        result = users.find({'phone':phone})
        if result.count() == 0:
            return None
        return result[0]

    def get_user_by_uid(self, uid):
        users = self.db.users
        result = users.find({'uid': uid})
        return result

    def clean_users(self):
        users = self.db.users
        users.remove()

class FightRepo(Repo):

    def create_fight(self, fight):
        fights = self.db.fights
