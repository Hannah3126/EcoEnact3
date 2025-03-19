from flask import Flask, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from flask_session import Session
from werkzeug.security import generate_password_hash, check_password_hash
from flask_session import Session
from sqlalchemy import text
from datetime import datetime, date, timedelta
import requests
import json
import os
from PIL import Image
import io
import base64
from google.cloud import vision
import googlemaps
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array, load_img

gmaps = googlemaps.Client(key='AIzaSyALGUlIGSetASLC6WkAQFGVMAFA-N_V9Dk')
GOOGLE_API_KEY = 'AIzaSyALGUlIGSetASLC6WkAQFGVMAFA-N_V9Dk'
GOOGLE_CLOUD_VISION = 'AIzaSyDF7IQVd0t9MKOIz7S5uVP_yrNqBzysvLI'

# Emission factors in grams CO2 per kilometer
emission_factors = {
    'train': 0.041,  #
    'car': 0.12    # 
}
# Define maximum values for normalization
MAX_ELECTRICITY_USAGE = 30000  # kWh per year
MAX_CAR_MILEAGE = 50000        # km per year
MAX_FLIGHTS = 20               # flights per year
MAX_MEAT_CONSUMPTION = 7       # servings per week

app = Flask(__name__)
CORS(app)
password = 'hanah%40312'

# Configure the MySQL database
app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+pymysql://flask_user:{password}@localhost/my_flask_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Configure Flask-Session
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SECRET_KEY'] = 'supersecretkey'
Session(app)

db = SQLAlchemy(app)

# Define the User model
class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(256), nullable=False)
    survey_completed = db.Column(db.Boolean, default=False)
    carbon_footprint = db.Column(db.Float, nullable=True)

# Define the Badge model
class Badge(db.Model):
    __tablename__ = 'badges'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    name = db.Column(db.String(100), nullable=False)
    current_steps = db.Column(db.Integer, default=0)
    bronze_steps = db.Column(db.Integer, default=0)
    silver_steps = db.Column(db.Integer, default=0)
    gold_steps = db.Column(db.Integer, default=0)
    level = db.Column(db.String(20), default='None')
    description = db.Column(db.Text)
    how_to_attain = db.Column(db.Text)

# Define the Points model
class Points(db.Model):
    __tablename__ = 'points'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    points = db.Column(db.Integer, nullable=False, default=0)

# Define the ElectricityPrice model
class ElectricityPrice(db.Model):
    __tablename__ = 'cost_of_electricity_by_country_2024'
    country = db.Column(db.String(100), primary_key=True)
    CostOfElectricityMarch2023 = db.Column(db.Float, nullable=False)
    CostOfElectricitySeptember2022 = db.Column(db.Float, nullable=False)

# Define the Survey model
class Survey(db.Model):
    __tablename__ = 'survey_results'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    country = db.Column(db.String(100), nullable=False)
    electricity_bill = db.Column(db.Float, nullable=False)
    electricity_usage_kwh = db.Column(db.Float, nullable=False)
    car_mileage_km = db.Column(db.Float, nullable=True)
    flights_per_year = db.Column(db.Integer, nullable=True)
    meat_consumption_per_week = db.Column(db.Integer, nullable=True)
    carbon_footprint = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Define the FoodCarbonFootprint model
class FoodCarbonFootprint(db.Model):
    __tablename__ = 'carbon_footprint_for_food'
    id = db.Column(db.Integer, primary_key=True)
    food_item = db.Column(db.String(255), nullable=False, unique=True)
    CO2_e_per_kg = db.Column(db.Float, nullable=False)
    typical_serving_size_g = db.Column(db.Integer, nullable=False)
    CO2_e_per_serving = db.Column(db.Float, nullable=False)

# Define the FoodLog model
class FoodLog(db.Model):
    __tablename__ = 'food_log'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    food_name = db.Column(db.String(100), nullable=False)
    serving_size = db.Column(db.Float, nullable=False)
    carbon_footprint = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Define the Station model
class Station(db.Model):
    __tablename__ = 'all_stations'
    id = db.Column(db.Integer, primary_key=True)
    station_name = db.Column(db.String(255), nullable=False)
    line_name = db.Column(db.String(255), nullable=False)

# Define the RecyclingRecommendation model
class RecyclingRecommendation(db.Model):
    __tablename__ = 'recycling_recommendations'
    id = db.Column(db.Integer, primary_key=True)
    topic = db.Column(db.String(255))
    title = db.Column(db.String(255))
    url = db.Column(db.String(255))
    description = db.Column(db.Text)
    popularity_score = db.Column(db.Integer)

    def to_dict(self):
        return {
            'id': self.id,
            'topic': self.topic,
            'title': self.title,
            'url': self.url,
            'description': self.description,
            'popularity_score': self.popularity_score
        }

# Define the UserInteraction model
class UserInteraction(db.Model):
    __tablename__ = 'user_interactions'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    article_id = db.Column(db.Integer, db.ForeignKey('recycling_recommendations.id'), nullable=False)  # Foreign key reference to RecyclingRecommendation
    category = db.Column(db.String(255), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'article_id': self.article_id,
            'category': self.category,
            'timestamp': self.timestamp.isoformat()
        }

# Define the Post model
class Post(db.Model):
    __tablename__ = 'posts'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    user_name = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'user_name': self.user_name,
            'content': self.content,
            'timestamp': self.timestamp.isoformat()
        }

# Define the ActivityLog model
class ActivityLog(db.Model):
    __tablename__ = 'activity_logs'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Foreign key reference to User
    activity_type = db.Column(db.String(100), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    def __init__(self, user_id, activity_type):
        self.user_id = user_id
        self.activity_type = activity_type

class DailyCarbonFootprint(db.Model):
    __tablename__ = 'daily_carbon_footprint'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    carbon_footprint = db.Column(db.Float, nullable=False)

    user = db.relationship('User', backref=db.backref('daily_footprints', lazy=True))
    
# Vouchers Model
class Vouchers(db.Model):
    __tablename__ = 'vouchers'
    voucher_id = db.Column(db.Integer, primary_key=True)
    points_required = db.Column(db.Integer, nullable=False)
    discount_percentage = db.Column(db.Float, nullable=False)
    description = db.Column(db.String(255), nullable=False)
    validity_period = db.Column(db.Date, nullable=False)

# UserVouchers Model
class UserVouchers(db.Model):
    __tablename__ = 'user_vouchers'
    user_voucher_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    voucher_id = db.Column(db.Integer, db.ForeignKey('vouchers.voucher_id'), nullable=False)
    date_claimed = db.Column(db.DateTime, default=datetime.utcnow)
               
# Create the database and the database table
with app.app_context():
    db.create_all()
    
# Load the model
food_model = tf.keras.models.load_model('model_trained_101class.keras')

# Load class names
with open('classes.txt', 'r') as f:
    class_names = f.read().splitlines()

# Ensure the target size matches the input shape of your model
TARGET_SIZE = (150, 150)

recycle_model = load_model('/Users/hannahjoshua/Downloads/EcoEnact 1:3/Recyclable Image Processing/cnn_best_model.keras')

# Define a dictionary to map class indices to category names
class_info = [
    {'name': 'aerosol_cans', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-aerosol-cans/'},
    {'name': 'aluminum_food_cans', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-aluminum-cans/'},
    {'name': 'aluminum_soda_cans', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-aluminum-cans/'},
    {'name': 'cardboard_boxes', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-cardboard/'},
    {'name': 'cardboard_packaging', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-cardboard/'},
    {'name': 'clothing', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-clothing-accessories/'},
    {'name': 'coffee_grounds', 'url': 'https://earth911.com/home-garden/reuse-coffee-grounds-and-tea-bags/'},
    {'name': 'disposable_plastic_cutlery', 'url': 'https://earth911.com/home-garden/recycling-plastic-utensils/'},
    {'name': 'eggshells', 'url': 'https://earth911.com/home-garden/recycling-plastic-utensils/'},
    {'name': 'food_waste', 'url': 'https://earth911.com/eco-tech/apps-to-rescue-food-from-waste/'},
    {'name': 'glass_beverage_bottles', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-glass-bottles-jars/'},
    {'name': 'glass_cosmetic_containers', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-glass/'},
    {'name': 'glass_food_jars', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-glass-bottles-jars/'},
    {'name': 'magazines', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-books-magazines/'},
    {'name': 'newspaper', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-newspaper/'},
    {'name': 'office_paper', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-paper/'},
    {'name': 'paper_cups', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-paper-cups/'},
    {'name': 'plastic_cup_lids', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-caps-lids/'},
    {'name': 'plastic_detergent_bottles', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-jugs-bottles/'},
    {'name': 'plastic_food_containers', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-jugs-bottles/'},
    {'name': 'plastic_shopping_bags', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-bags/'},
    {'name': 'plastic_soda_bottles', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-jugs-bottles/'},
    {'name': 'plastic_straws', 'url': 'https://www.onegoodthingbyjillee.com/23-practical-ways-reuse-disposable-straws/'},
    {'name': 'plastic_trash_bags', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-bags/'},
    {'name': 'plastic_water_bottles', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-plastic-jugs-bottles/'},
    {'name': 'shoes', 'url': 'https://earth911.com/how-and-buy/plant-based-shoes/'},
    {'name': 'steel_food_cans', 'url': 'https://earth911.com/recycling-guide/how-to-recycle-tin-or-steel-cans/'},
    {'name': 'styrofoam_cups', 'url': 'https://get-green-now.com/reuse-styrofoam/'},
    {'name': 'styrofoam_food_containers', 'url': 'https://get-green-now.com/reuse-styrofoam/'},
    {'name': 'tea_bags', 'url': 'https://earth911.com/home-garden/reuse-coffee-grounds-and-tea-bags/'}
]

@app.route('/user/<int:user_id>/carbon_footprint', methods=['GET'])
def get_carbon_footprint(user_id):
    user = User.query.get(user_id)
    if user:
        return jsonify({
            "carbon_footprint": user.carbon_footprint
        }), 200
    else:
        return jsonify({"message": "User not found"}), 404
    
# Define a function to preprocess the uploaded image
def preprocess_image(image_path):
    img = load_img(image_path, target_size=(224, 224))  # Ensure the target size matches the input shape of the model
    img = img_to_array(img)
    img = np.expand_dims(img, axis=0)
    img = img / 255.0  # Rescale the image as done during training
    return img

def preprocess_image_recycle(image_path):
    img = Image.open(image_path)
    img = img.resize((150, 150))
    img_array = np.array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    return img_array

@app.route('/stations', methods=['GET'])
def get_stations():
    all_stations = Station.query.all()
    station_names = [station.station_name for station in all_stations]
    return jsonify(station_names)

# Route to register a new user
@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')
        full_name = data.get('full_name')

        # Check if user already exists
        if User.query.filter_by(email=email).first():
            return jsonify({"message": "User already exists"}), 400

        # Create new user
        new_user = User(
            email=email,
            password=generate_password_hash(password),
            full_name=full_name,
            carbon_footprint=0.0,  # Default carbon footprint
            survey_completed=False  # Default survey status
        )
        db.session.add(new_user)
        db.session.commit()


        # Default badges for new user
        default_badges = [
            Badge(
                name='Daily Habit',
                bronze_steps=10,
                silver_steps=20,
                gold_steps=30,
                user_id=new_user.id,
                description='Incorporate eco-friendly habits into your daily routine.',
                how_to_attain='Turn off lights when not in use, use reusable water bottles, conserve water daily.'
            ),
            Badge(
                name='Green Commuter',
                bronze_steps=10,
                silver_steps=20,
                gold_steps=30,
                user_id=new_user.id,
                description='Choose green transportation methods.',
                how_to_attain='Find our EcoEnact QR codes in your trains and scan them to log your green commuting activities.'
            ),
            Badge(
                name='Challenge Champ',
                bronze_steps=10,
                silver_steps=20,
                gold_steps=30,
                user_id=new_user.id,
                description='Complete sustainability challenges.',
                how_to_attain='Participate in and complete various eco-friendly challenges, such as zero-waste weeks or meatless Mondays.'
            ),
            Badge(
                name='Green Friend',
                bronze_steps=10,
                silver_steps=20,
                gold_steps=30,
                user_id=new_user.id,
                description='Spread awareness about sustainability.',
                how_to_attain='Educate others about eco-friendly practices, organize community clean-ups, and participate in environmental campaigns.'
            ),
            Badge(
                name='Recycler',
                bronze_steps=10,
                silver_steps=20,
                gold_steps=30,
                user_id=new_user.id,
                description='Dedicate efforts to recycling.',
                how_to_attain='Recycle paper, plastic, glass, and electronics, and reduce waste by repurposing items.'
            ),
        ]

        db.session.add_all(default_badges)
        db.session.commit()

        return jsonify({
            "message": "User registered successfully",
            "user_id": new_user.id  
        }), 201

    except Exception as e:
        print(e)
        return jsonify({"message": "Error in registration"}), 500

@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        print(data)  # Log the incoming data for debugging
        email = data.get('email')
        password = data.get('password')

        user = User.query.filter_by(email=email).first()
        if user and check_password_hash(user.password, password):
            session['user_id'] = user.id
            session['user_name'] = user.full_name
            session['carbon_footprint'] = user.carbon_footprint if user.survey_completed else 0

            carbon_footprint = user.carbon_footprint if user.carbon_footprint is not None else 0.0

            return jsonify({
                "message": "Login successful",
                "user_id": user.id,
                "user_name": user.full_name,
                "carbon_footprint": carbon_footprint,
                "new_user": not user.survey_completed
            }), 200
        else:
            return jsonify({"message": "Invalid email or password"}), 401
    except Exception as e:
        print(e)
        return jsonify({"message": "Error in login"}), 500

    
@app.route('/get_user_data', methods=['GET'])
def get_user_data():
    if 'user_id' in session:
        user_id = session['user_id']
        user_name = session['user_name']
        carbon_footprint = session['carbon_footprint']
        return jsonify({
            "user_id": user_id,
            "user_name": user_name,
            "carbon_footprint": carbon_footprint
        }), 200
    else:
        return jsonify({"message": "User not logged in"}), 401

# Route to get user badges and points
@app.route('/user/<int:user_id>/gamification', methods=['GET'])
def get_gamification_data(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Predefined badge data
    predefined_badges = [
        {"name": "Daily Habit", "bronze_steps": 10, "silver_steps": 20, "gold_steps": 30, "level": "Bronze"},
        {"name": "Green Commuter", "bronze_steps": 10, "silver_steps": 20, "gold_steps": 30, "level": "Bronze"},
        {"name": "Challenge Champ", "bronze_steps": 10, "silver_steps": 20, "gold_steps": 30, "level": "Bronze"},
        {"name": "Green Friend", "bronze_steps": 10, "silver_steps": 20, "gold_steps": 30, "level": "Bronze"},
        {"name": "Recycler", "bronze_steps": 10, "silver_steps": 20, "gold_steps": 30, "level": "Bronze"}
    ]

    # Fetch the user's badges
    user_badges = Badge.query.filter_by(user_id=user_id).all()
    user_badges_dict = {badge.name: badge for badge in user_badges}

    # Merge predefined badges with user badges
    badges_list = []
    for predefined_badge in predefined_badges:
        badge_name = predefined_badge['name']
        if badge_name in user_badges_dict:
            badge = user_badges_dict[badge_name]
            badges_list.append({
                'name': badge.name,
                'current_steps': badge.current_steps,
                'bronze_steps': badge.bronze_steps,
                'silver_steps': badge.silver_steps,
                'gold_steps': badge.gold_steps,
                'level': badge.level,
                'description': badge.description if badge.description else 'No description available',
                'how_to_attain': badge.how_to_attain if badge.how_to_attain else 'No information available'
            })
        else:
            badges_list.append({
                'name': predefined_badge['name'],
                'current_steps': 0,
                'bronze_steps': predefined_badge['bronze_steps'],
                'silver_steps': predefined_badge['silver_steps'],
                'gold_steps': predefined_badge['gold_steps'],
                'level': predefined_badge['level'],
                'description': 'No description available',
                'how_to_attain': 'No information available'
            })

    points = Points.query.filter_by(user_id=user_id).first()
    points_value = points.points if points else 0

    # print("Badges List:", badges_list)  # Print the badges list to debug

    return jsonify({
        'points': points_value,
        'badges': badges_list
    }), 200

@app.route('/user/<int:user_id>/log_activity', methods=['POST'])
def log_activity(user_id):
    data = request.json
    activity_type = data.get('activity_type')
    percentage_reduction = data.get('percentage_reduction')
    print(f"Logging activity for user {user_id}: {activity_type} with reduction {percentage_reduction}")

    user = User.query.get(user_id)
    if not user:
        print("User not found")
        return jsonify({"message": "User not found"}), 404

    # Log the activity
    new_log = ActivityLog(user_id=user_id, activity_type=activity_type)
    db.session.add(new_log)
    db.session.commit()

    # Update points
    points = Points.query.filter_by(user_id=user_id).first()
    if not points:
        points = Points(user_id=user_id, points=0)
        db.session.add(points)
    points.points += 10  # Example points increment

    # Update badges based on activity type
    badge = Badge.query.filter_by(user_id=user_id, name=activity_type).first()
    if badge:
        badge.current_steps += 1  # Example step increment
        print(f"Updated steps for badge {badge.name}: {badge.current_steps}")

        # Check and update badge level
        if badge.current_steps >= badge.gold_steps:
            badge.level = 'Gold'
        elif badge.current_steps >= badge.silver_steps:
            badge.level = 'Silver'
        elif badge.current_steps >= badge.bronze_steps:
            badge.level = 'Bronze'
        print(f"Updated level for badge {badge.name}: {badge.level}")

    # Check if the user earned any other badge today
    today = datetime.utcnow().date()
    activities_today = ActivityLog.query.filter(
        ActivityLog.user_id == user_id,
        db.func.date(ActivityLog.timestamp) == today,
        ActivityLog.activity_type != 'Daily Habit'
    ).all()

    if activities_today:
        # Check if Daily Habit badge has been updated today
        daily_habit_updated_today = ActivityLog.query.filter(
            ActivityLog.user_id == user_id,
            db.func.date(ActivityLog.timestamp) == today,
            ActivityLog.activity_type == 'Daily Habit'
        ).first()

        if not daily_habit_updated_today:
            daily_habit_badge = Badge.query.filter_by(user_id=user_id, name='Daily Habit').first()
            if daily_habit_badge:
                daily_habit_badge.current_steps += 1
                print(f"Updated steps for Daily Habit badge: {daily_habit_badge.current_steps}")

                if daily_habit_badge.current_steps >= daily_habit_badge.gold_steps:
                    daily_habit_badge.level = 'Gold'
                elif daily_habit_badge.current_steps >= daily_habit_badge.silver_steps:
                    daily_habit_badge.level = 'Silver'
                elif daily_habit_badge.current_steps >= daily_habit_badge.bronze_steps:
                    daily_habit_badge.level = 'Bronze'
                print(f"Updated level for Daily Habit badge: {daily_habit_badge.level}")

                # Log the Daily Habit activity
                daily_habit_log = ActivityLog(user_id=user_id, activity_type='Daily Habit')
                db.session.add(daily_habit_log)

    # Update user's carbon footprint
    if percentage_reduction is not None:
        user.carbon_footprint -= user.carbon_footprint * (percentage_reduction / 100)
        print(f"Updated carbon footprint for user {user_id}: {user.carbon_footprint}")

    db.session.commit()
    print("Database commit successful")

    return jsonify({"message": "Activity logged successfully"}), 200


# Route to submit survey
@app.route('/user/<int:user_id>/submit_survey', methods=['POST'])
def submit_survey(user_id):
    try:
        data = request.json
        country = data.get('country')
        electricity_bill_local = data.get('electricity_bill')
        car_mileage_km = data.get('car_mileage_km')
        flights_per_year = data.get('flights_per_year')
        meat_consumption_per_week = data.get('meat_consumption_per_week')

        # Get electricity price and exchange rate
        price_response = requests.get(f"http://192.168.0.105:5001/get_price_per_kwh?country={country}")
        if price_response.status_code != 200:
            return jsonify({"message": "Failed to fetch price per kWh"}), 500

        price_data = price_response.json()
        price_per_kwh_usd = price_data['price_per_kwh_usd']
        exchange_rate = price_data['exchange_rate']
        electricity_bill_usd = float(electricity_bill_local) / exchange_rate
        electricity_usage_kwh = electricity_bill_usd / price_per_kwh_usd

        carbon_footprint, max_value, scaled_footprint = calculate_carbon_footprint(
            electricity_usage_kwh,
            car_mileage_km,
            flights_per_year,
            meat_consumption_per_week
        )

        new_survey = Survey(
            user_id=user_id,
            country=country,
            electricity_bill=electricity_bill_local,
            electricity_usage_kwh=electricity_usage_kwh,
            car_mileage_km=car_mileage_km,
            flights_per_year=flights_per_year,
            meat_consumption_per_week=meat_consumption_per_week,
            carbon_footprint=carbon_footprint
        )

        user = User.query.get(user_id)
        user.survey_completed = True
        user.carbon_footprint = carbon_footprint
        db.session.add(new_survey)
        db.session.commit()

        session['carbon_footprint'] = carbon_footprint

        return jsonify({
            "message": "Survey submitted successfully",
            "carbon_footprint": carbon_footprint,
            "max_value": max_value,
            "scaled_footprint": scaled_footprint
        }), 200

    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({"message": "An error occurred while submitting the survey"}), 500
    

def calculate_carbon_footprint(electricity_usage_kwh, car_mileage_km, flights_per_year, meat_consumption_per_week):
    CO2_PER_KWH = 0.92
    CO2_PER_KM_CAR = 0.12
    CO2_PER_FLIGHT = 200
    CO2_PER_MEAT_CONSUMPTION = 10

    electricity_footprint = electricity_usage_kwh * CO2_PER_KWH
    car_footprint = car_mileage_km * CO2_PER_KM_CAR if car_mileage_km else 0
    flights_footprint = flights_per_year * CO2_PER_FLIGHT
    meat_footprint = meat_consumption_per_week * CO2_PER_MEAT_CONSUMPTION * 52

    total_footprint = electricity_footprint + car_footprint + flights_footprint + meat_footprint

    STANDARD_THRESHOLD = 20000  #standard threshold
    max_value = max(total_footprint, STANDARD_THRESHOLD) * 1.2  # buffer for scaling

    scaled_footprint = min(total_footprint / max_value * 100, 100)  # Scale to a percentage

    return round(total_footprint, 2), round(max_value, 2), scaled_footprint

@app.route('/get_price_per_kwh', methods=['GET'])
def get_price_per_kwh():
    country = request.args.get('country')

    # Fetch the price per kWh from the database
    result = db.session.execute(
        text("SELECT CostOfElectricityMarch2023 FROM `cost-of-electricity-by-country-2024` WHERE country = :country"),
        {'country': country}
    ).fetchone()
    
    if result:
        price_per_kwh = result[0]
    else:
        return jsonify({'message': 'Country not found'}), 404

    # Fetch the local currency of the country
    country_info_response = requests.get(f"https://restcountries.com/v3.1/name/{country}?fullText=true")
    if country_info_response.status_code != 200:
        return jsonify({"message": "Failed to fetch country info"}), 500
    
    country_info = country_info_response.json()
    local_currency_code = list(country_info[0]['currencies'].keys())[0]

    # Fetch the conversion rate from local currency to USD
    exchange_rate_response = requests.get(f"https://api.exchangerate-api.com/v4/latest/{local_currency_code}")
    if exchange_rate_response.status_code != 200:
        return jsonify({"message": "Failed to fetch exchange rate"}), 500
    
    exchange_rate = exchange_rate_response.json()['rates']['USD']
    
    return jsonify({
        "price_per_kwh_usd": price_per_kwh,
        "exchange_rate": exchange_rate,
        "local_currency_code": local_currency_code
    }), 200
    
def prepare_image(image):
    image = image.resize(TARGET_SIZE)
    image = img_to_array(image)
    image = np.expand_dims(image, axis=0) 
    image = image / 255.0
    return image

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'message': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'message': 'No selected file'}), 400
    
    image = Image.open(io.BytesIO(file.read()))
    prepared_image = prepare_image(image)
    
    prediction = food_model.predict(prepared_image)
    predicted_class_index = np.argmax(prediction, axis=1)[0]
    predicted_class_name = class_names[predicted_class_index]
    confidence_score = float(np.max(prediction))

    return jsonify({
        'predicted_class_index': int(predicted_class_index),
        'predicted_class_name': predicted_class_name,
        'confidence_score': confidence_score
    }), 200

@app.route('/log_food', methods=['POST'])
def log_food():
    data = request.json
    user_id = data.get('user_id')
    food_item = data.get('food')
    serving_size = data.get('serving')

    if not user_id or not food_item or not serving_size:
        return jsonify({"message": "Missing data"}), 400

    # Fetch food data from the database
    food_data = db.session.execute(
        text("SELECT CO2_e_per_kg, typical_serving_size_g, CO2_e_per_serving FROM carbon_footprint_for_food WHERE food_item = :food_item"),
        {'food_item': food_item}
    ).fetchone()

    if not food_data:
        return jsonify({"message": "Food item not found"}), 404

    co2_per_kg = food_data[0]
    typical_serving_size_g = food_data[1]
    co2_per_serving = food_data[2]

    # Calculate CO2 footprint for the given serving size
    co2_footprint = (serving_size / 1000.0) * co2_per_kg

    # Fetch the user's current main carbon footprint
    user = User.query.get(user_id)
    main_carbon_footprint = user.carbon_footprint

    # Calculate the food carbon footprint as a percentage of the main carbon footprint
    percentage_increase = (co2_footprint / main_carbon_footprint) * 100 if main_carbon_footprint != 0 else 0

    # Update the user's main carbon footprint
    user.carbon_footprint += co2_footprint
    db.session.commit()
    
    # Fetch or create the user's daily carbon footprint entry for today
    today = date.today()
    daily_footprint = DailyCarbonFootprint.query.filter_by(user_id=user_id, date=today).first()
    if daily_footprint:
        daily_footprint.carbon_footprint += co2_footprint
    else:
        daily_footprint = DailyCarbonFootprint(user_id=user_id, date=today, carbon_footprint=co2_footprint)
        db.session.add(daily_footprint)

    db.session.commit()

    # Save the food log in the database
    new_food_log = FoodLog(
        user_id=user_id,
        food_name=food_item,
        serving_size=serving_size,
        carbon_footprint=co2_footprint
    )
    db.session.add(new_food_log)
    db.session.commit()

    # Determine badge and level based on CO2 footprint
    if co2_footprint < 0.5:
        badge = 'Gold'
        level = 'Eco Warrior'
    elif co2_footprint < 1.0:
        badge = 'Silver'
        level = 'Green Enthusiast'
    else:
        badge = 'Bronze'
        level = 'Eco Beginner'

    return jsonify({"message": "Food log added successfully", "badge": badge, "level": level, "total_co2": user.carbon_footprint}), 200

@app.route('/user/<int:user_id>/food_logs', methods=['GET'])
def get_food_logs(user_id):
    try:
        today = date.today()
        food_logs = FoodLog.query.filter(
            FoodLog.user_id == user_id,
            db.func.date(FoodLog.timestamp) == today
        ).all()

        food_logs_list = [
            {
                'food_name': food_log.food_name,
                'serving_size': food_log.serving_size,
                'carbon_footprint': food_log.carbon_footprint
            } for food_log in food_logs
        ]

        # Calculate the user's total CO2 footprint for today
        total_co2 = sum(food_log.carbon_footprint for food_log in food_logs)

        # Determine badge and level based on total CO2 footprint
        if total_co2 < 0.5:
            badge = 'Gold'
            level = 'Eco Warrior'
        elif total_co2 < 1.0:
            badge = 'Silver'
            level = 'Green Enthusiast'
        else:
            badge = 'Bronze'
            level = 'Eco Beginner'

        response = {
            "food_logs": food_logs_list,
            "total_co2": total_co2,
            "badge": badge,
            "level": level
        }

        return jsonify(response), 200
    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({"message": "An error occurred while fetching food logs"}), 500
    
@app.route('/distance', methods=['GET'])
def calculate_distance():
    origin = request.args.get('origin', 'Kuala Lumpur')
    destination = request.args.get('destination', 'Penang')
    user_id = request.args.get('user_id')  # Get the user_id from the request

    if not origin or not destination:
        return jsonify({'error': 'Please provide both origin and destination parameters'}), 400

    if not user_id:
        return jsonify({'error': 'Please provide the user_id parameter'}), 400

    try:
        user_id = int(user_id)
    except ValueError:
        return jsonify({'error': 'Invalid user_id parameter'}), 400

    # Construct the API request URL
    url = f"https://maps.googleapis.com/maps/api/distancematrix/json?origins={origin}&destinations={destination}&units=metric&key={GOOGLE_API_KEY}"
    print(f"Request URL: {url}")

    # Call the Google Distance Matrix API
    response = requests.get(url)
    print(f"Response status code: {response.status_code}")
    print(f"Response text: {response.text}")

    data = response.json()

    if data.get('status') != 'OK':
        return jsonify({'error': 'Error from Google Distance Matrix API', 'details': data}), 500

    try:
        distance = data['rows'][0]['elements'][0]['distance']['value'] / 1000  # Convert meters to kilometers
    except (IndexError, KeyError):
        return jsonify({'error': 'Invalid response from Google Distance Matrix API', 'details': data}), 500

    # Calculate emissions
    train_emissions = distance * emission_factors['train']
    car_emissions = distance * emission_factors['car']

    # Update the user's daily carbon footprint
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    today = date.today()
    daily_footprint = DailyCarbonFootprint.query.filter_by(user_id=user_id, date=today).first()
    if daily_footprint:
        daily_footprint.carbon_footprint += train_emissions
    else:
        daily_footprint = DailyCarbonFootprint(user_id=user_id, date=today, carbon_footprint=train_emissions)
        db.session.add(daily_footprint)

    # Calculate the percentage reduction in carbon footprint
    carbon_footprint_saved = car_emissions - train_emissions
    if user.carbon_footprint > 0:
        percentage_reduction = (carbon_footprint_saved / user.carbon_footprint) * 100
    else:
        percentage_reduction = 0

    # Apply the percentage reduction to the user's main carbon footprint
    user.carbon_footprint -= carbon_footprint_saved
    db.session.commit()

    return jsonify({
        'origin': origin,
        'destination': destination,
        'distance_km': distance,
        'emissions': {
            'train': train_emissions,
            'car': car_emissions
        },
        'total_daily_footprint': daily_footprint.carbon_footprint,
        'total_carbon_footprint': user.carbon_footprint,
        'percentage_reduction': percentage_reduction
    })
    
@app.route('/upload', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    try:
        # Read the image file
        image_content = file.read()

        # Encode the image to base64
        image_base64 = base64.b64encode(image_content).decode('utf-8')

        # Prepare the request payload
        payload = {
            "requests": [
                {
                    "image": {
                        "content": image_base64
                    },
                    "features": [
                        {
                            "type": "LABEL_DETECTION"
                        }
                    ]
                }
            ]
        }

        # Send the request to the Vision API
        response = requests.post(
            f'https://vision.googleapis.com/v1/images:annotate?key={GOOGLE_CLOUD_VISION}',
            json=payload
        )

        response_data = response.json()

        if 'error' in response_data:
            return jsonify({"error": response_data['error']['message']}), 500

        labels = [label['description'] for label in response_data['responses'][0]['labelAnnotations']]

        return jsonify(labels)

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/log_interaction', methods=['POST'])
def log_interaction():
    data = request.json
    user_id = data['user_id']
    article_id = data['article_id']
    category = data['category']
    
    interaction = UserInteraction(user_id=user_id, article_id=article_id, category=category)
    db.session.add(interaction)
    db.session.commit()
    
    return jsonify({'status': 'success'}), 200

@app.route('/recommendations_or_educational/<int:user_id>', methods=['GET', 'POST'])
def get_recommendations_or_educational(user_id):
    if request.method == 'POST':
        # Increment popularity score for a specific recommendation
        recommendation_id = request.json.get('recommendation_id')
        print(f"Received POST request to increment popularity for recommendation_id: {recommendation_id}")
        
        if recommendation_id is None:
            return jsonify({'error': 'recommendation_id is required'}), 400

        try:
            recommendation = RecyclingRecommendation.query.get(recommendation_id)
            if recommendation:
                print(f"Found recommendation with id {recommendation_id}, current popularity score: {recommendation.popularity_score}")
                recommendation.popularity_score += 1
                db.session.commit()
                print(f"Updated popularity score to: {recommendation.popularity_score}")
                return jsonify({'message': 'Popularity score updated successfully'}), 200
            else:
                print(f"Recommendation with id {recommendation_id} not found")
                return jsonify({'error': 'Recommendation not found'}), 404
        except SQLAlchemyError as e:
            print(f"SQLAlchemyError: {e}")
            return jsonify({'error': str(e)}), 500

    # Fetch user interactions
    interactions = UserInteraction.query.filter_by(user_id=user_id).all()
    
    # Debugging output
    print(f"User Interactions for user {user_id}: {interactions}")

    def get_limited_results(topic, limit):
        results = RecyclingRecommendation.query.filter_by(topic=topic).limit(limit).all()
        return results

    recommendations = {
        'diyProjects': [],
        'recyclingBenefits': [],
        'reuseProjects': [],
        'upcyclingIdeas': [],
        'environmentalImpact': []
    }

    # If no interactions, fetch general educational content
    if not interactions:
        recommendations['diyProjects'] = get_limited_results('DIY Recycling Projects', 2)
        recommendations['recyclingBenefits'] = get_limited_results('Benefits of Recycling', 2)
        recommendations['reuseProjects'] = get_limited_results('Reuse Projects', 2)
        recommendations['upcyclingIdeas'] = get_limited_results('Upcycling Ideas', 2)
        recommendations['environmentalImpact'] = get_limited_results('Environmental Impact', 2)
    else:
        # Count interactions per category
        category_counts = {}
        for interaction in interactions:
            category = interaction.category
            if category in category_counts:
                category_counts[category] += 1
            else:
                category_counts[category] = 1

        # Debugging output
        print(f"Category counts for user {user_id}: {category_counts}")

        # Determine most preferred category
        if category_counts:
            preferred_category = max(category_counts, key=category_counts.get)
        else:
            preferred_category = None

        # Fetch recommended articles
        for category_key, topic_name in {
            'diyProjects': 'DIY Recycling Projects',
            'recyclingBenefits': 'Benefits of Recycling',
            'reuseProjects': 'Reuse Projects',
            'upcyclingIdeas': 'Upcycling Ideas',
            'environmentalImpact': 'Environmental Impact'
        }.items():
            limit = 4 if topic_name == preferred_category else 2
            results = get_limited_results(topic_name, limit)
            recommendations[category_key] = results

    # Convert results to dictionary format for JSON response
    for category in recommendations:
        recommendations[category] = [result.to_dict() for result in recommendations[category]]

    # Debugging output
    print(f"Recommendations for user {user_id}: {recommendations}")

    return jsonify(recommendations)

# Define the route for image classification
@app.route('/predict_recycle', methods=['POST'])
def predict_recycle():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file:
        file_path = os.path.join('uploads', file.filename)
        
        # Ensure the 'uploads' directory exists
        if not os.path.exists('uploads'):
            os.makedirs('uploads')
            
        file.save(file_path)
        img = preprocess_image_recycle(file_path)
        prediction = recycle_model.predict(img)
        
        # Debug print for prediction
        print(f"Prediction: {prediction}")

        predicted_class_idx = np.argmax(prediction, axis=1)[0]

        # Debug print for predicted_class_idx
        print(f"Predicted Class Index: {predicted_class_idx}")

        if predicted_class_idx < len(class_info):
            predicted_class_info = class_info[predicted_class_idx]
            confidence_score = float(np.max(prediction))  # Get the confidence score of the prediction

            # Determine recyclability based on confidence score
            is_recyclable = confidence_score >= 0.50

            return jsonify({
                'predicted_class_idx': int(predicted_class_idx),
                'predicted_class_name': predicted_class_info['name'],
                'confidence_score': confidence_score,
                'is_recyclable': is_recyclable,
                'url': predicted_class_info['url']
            })
        else:
            return jsonify({'error': 'Predicted class index out of range'}), 500

@app.route('/create_post', methods=['POST'])
def create_post():
    data = request.get_json()
    user_id = data.get('user_id')
    user_name = data.get('user_name')
    content = data.get('content')

    if not all([user_id, user_name, content]):
        return jsonify({'error': 'Missing data'}), 400

    new_post = Post(user_id=user_id, user_name=user_name, content=content)
    db.session.add(new_post)
    db.session.commit()


    return jsonify({'message': 'Post created successfully'}), 201
        
@app.route('/posts', methods=['GET'])
def get_posts():
    # Fetch user posts from the database
    user_posts = Post.query.order_by(Post.timestamp.desc()).all()

    # Fetch the most popular article from the recycle_recommendations table
    most_popular_article = RecyclingRecommendation.query.order_by(RecyclingRecommendation.popularity_score.desc()).first()

    posts = [post.to_dict() for post in user_posts]

    response_data = {
        'posts': posts,
        'most_popular_article': most_popular_article.to_dict() if most_popular_article else None
    }
    return jsonify(response_data)

@app.route('/reset_password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    new_password = data.get('new_password')

    # Validate email and new_password fields
    if not email or not new_password:
        return jsonify({"message": "Email and new password are required."}), 400

    user = User.query.filter_by(email=email).first()

    if user:
        user.password = generate_password_hash(new_password)
        db.session.commit()
        return jsonify({"message": "Password reset successful"}), 200
    else:
        return jsonify({"message": "User not found"}), 404


@app.route('/leaderboard/<string:criteria>', methods=['GET'])
def get_leaderboard(criteria):
    print(f"Received request for leaderboard with criteria: {criteria}")

    if criteria not in ['carbon_footprint', 'points']:
        print("Invalid criteria received")
        return jsonify({"error": "Invalid criteria"}), 400

    try:
        if criteria == 'carbon_footprint':
            users = User.query.order_by(User.carbon_footprint.asc()).all()
            print(f"Fetched {len(users)} users sorted by carbon footprint")
            leaderboard = [
                {
                    'id': user.id,
                    'full_name': user.full_name,
                    'carbon_footprint': user.carbon_footprint
                } for user in users
            ]
            for user in leaderboard:
                print(f"User: {user['full_name']}, Carbon Footprint: {user['carbon_footprint']}")
        else:
            users_with_points = db.session.query(User, Points).join(Points).order_by(Points.points.desc()).all()
            print(f"Fetched {len(users_with_points)} users with points")
            leaderboard = [
                {
                    'id': user.User.id,
                    'full_name': user.User.full_name,
                    'points': user.Points.points
                } for user in users_with_points
            ]
            for user in leaderboard:
                print(f"User: {user['full_name']}, Points: {user['points']}")

        print(f"Returning leaderboard with {len(leaderboard)} entries")
        return jsonify(leaderboard)
    except Exception as e:
        print(f"Error fetching leaderboard data: {e}")
        return jsonify({"error": "Failed to fetch leaderboard data"}), 500

@app.route('/user/<int:user_id>/log_car_usage', methods=['POST'])
def log_car_usage(user_id):
    data = request.json
    kilometers_driven = data.get('kilometers_driven')

    if kilometers_driven is None:
        return jsonify({'error': 'Kilometers driven is required'}), 400

    try:
        kilometers_driven = float(kilometers_driven)
    except ValueError:
        return jsonify({'error': 'Invalid value for kilometers driven'}), 400

    # Define the emission factor for cars (CO2e per km)
    car_emission_factor = emission_factors.get('car', 0.12)  # Default value if not defined

    # Calculate the emissions from the car usage
    car_emissions = kilometers_driven * car_emission_factor

    # Find the user in the database
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Update the user's daily carbon footprint without affecting the main carbon footprint directly
    today = date.today()
    daily_footprint = DailyCarbonFootprint.query.filter_by(user_id=user_id, date=today).first()
    if daily_footprint:
        daily_footprint.carbon_footprint += car_emissions
    else:
        daily_footprint = DailyCarbonFootprint(user_id=user_id, date=today, carbon_footprint=car_emissions)
        db.session.add(daily_footprint)

    # Calculate the percentage increase and update the main carbon footprint
    percentage_increase = (car_emissions / user.carbon_footprint) * 100 if user.carbon_footprint else 0
    user.carbon_footprint += car_emissions

    db.session.commit()

    return jsonify({
        'message': 'Car usage logged successfully',
        'car_emissions': car_emissions,
        'total_daily_footprint': daily_footprint.carbon_footprint,
        'total_carbon_footprint': user.carbon_footprint,
        'percentage_increase': percentage_increase
    }), 200
    
@app.route('/user/<int:user_id>/carbon_footprint_period', methods=['GET'])
def get_carbon_footprint_daily(user_id):
    # Fetch the period from the query parameter
    period = request.args.get('period', 'daily').lower()
    today = datetime.today().date()

    # Determine the start date based on the period
    if period == 'daily':
        start_date = today
    elif period == 'weekly':
        start_date = today - timedelta(days=today.weekday())  # Start from Monday
    elif period == 'monthly':
        start_date = today.replace(day=1)  # Start from the first day of the month
    else:
        app.logger.error(f'Invalid period specified: {period}')
        return jsonify({'error': 'Invalid period specified'}), 400

    try:
        # Fetch carbon footprint data from the DailyCarbonFootprint table
        total_carbon_footprint = db.session.query(
            db.func.sum(DailyCarbonFootprint.carbon_footprint)
        ).filter(
            DailyCarbonFootprint.user_id == user_id,
            DailyCarbonFootprint.date >= start_date,
            DailyCarbonFootprint.date <= today
        ).scalar()

        total_carbon_footprint = total_carbon_footprint if total_carbon_footprint else 0.0

        app.logger.debug(f'User ID: {user_id}, Period: {period}, Start Date: {start_date}, '
                         f'Total Carbon Footprint: {total_carbon_footprint}')

        return jsonify({'carbon_footprint': total_carbon_footprint}), 200

    except Exception as e:
        app.logger.error(f'Error fetching carbon footprint for user {user_id}: {str(e)}')
        return jsonify({'error': str(e)}), 500
    
@app.route('/user/<int:user_id>/points', methods=['GET'])
def get_user_points(user_id):
    try:
        # Query the Points table to get the user's points
        points_record = Points.query.filter_by(user_id=user_id).first()
        
        if points_record:
            points = points_record.points
            return jsonify({
                "user_id": user_id,
                "points": points
            }), 200

        else:
            return jsonify({"message": "User points not found"}), 404

    except Exception as e:
        print(f"Error fetching points for user {user_id}: {e}")
        return jsonify({"message": "An error occurred while fetching user points"}), 500
    
def fetch_user_points(user_id):
    points_record = Points.query.filter_by(user_id=user_id).first()
    return points_record.points if points_record else 0

def add_voucher_to_user(user_id, voucher_id):
    user_voucher = UserVouchers(user_id=user_id, voucher_id=voucher_id)
    db.session.add(user_voucher)
    db.session.commit()

@app.route('/user/<int:user_id>/claim_voucher', methods=['POST'])
def claim_voucher(user_id):
    voucher_id = request.json.get('voucher_id')
    user_points = fetch_user_points(user_id)
    voucher = Vouchers.query.get(voucher_id)
    
    if not voucher:
        return jsonify({"message": "Voucher not found"}), 404

    if user_points >= voucher.points_required:
        add_voucher_to_user(user_id, voucher_id)
        return jsonify({"message": "Voucher claimed successfully"}), 200
    else:
        return jsonify({"message": "Not enough points to claim this voucher"}), 400

@app.route('/user/<int:user_id>/vouchers', methods=['GET'])
def get_user_vouchers(user_id):
    try:
        # Query the UserVouchers table to get the user's vouchers
        user_vouchers = UserVouchers.query.filter_by(user_id=user_id).all()

        if not user_vouchers:
            return jsonify({"message": "No vouchers found for this user"}), 404

        vouchers_list = []
        for user_voucher in user_vouchers:
            voucher = Vouchers.query.get(user_voucher.voucher_id)
            if voucher:
                vouchers_list.append({
                    "voucher_id": voucher.voucher_id,
                    "description": voucher.description,
                    "discount_percentage": voucher.discount_percentage,
                    "points_required": voucher.points_required,
                    "validity_period": voucher.validity_period.isoformat() if voucher.validity_period else None,
                    "date_claimed": user_voucher.date_claimed.isoformat() if user_voucher.date_claimed else None
                })

        return jsonify({"vouchers": vouchers_list}), 200

    except Exception as e:
        print(f"Error fetching vouchers for user {user_id}: {e}")
        return jsonify({"message": "An error occurred while fetching user vouchers"}), 500
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0',port=5001)