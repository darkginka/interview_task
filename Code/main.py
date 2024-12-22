import functions_framework
from datetime import datetime, time
from flask import jsonify
from google.cloud import firestore

db = firestore.Client(project="turf")

@functions_framework.http
def hello_http(request):
    request_json = request.get_json(silent=True)

    # Initialize final_price with a default or error response
    final_price = None

    if request_json :
        sport = request_json['sport']
        duration = request_json['duration']
        date = request_json['date']
        time_string = request_json['time']
        
        try:
            overrides = fetch_overrides_from_firestore()
            default_pricing = fetch_pricing_from_firestore()
            final_price = get_override_price(sport, duration, date, time_string, overrides,default_pricing)
        except KeyError as e:
            return jsonify({"error": f"Invalid sport or duration: {e}"}), 400
        except ValueError as e:
            return jsonify({"error": f"Invalid date or time format: {e}"}), 400

    else:
        return jsonify({"error": "Missing required fields in request JSON"}), 400

    return jsonify(
        {
            "price": final_price,
        }
    )

# default_pricing = {
#     "Badminton": {60: 100, 90: 150, 120: 190},
#     "Football": {60: 1000, 120: 1950},
# }

def fetch_pricing_from_firestore():
    pricing = {}
    docs = db.collection('pricing').stream()
    for doc in docs:
        # Use the document ID as the sport name
        sport_name = doc.id
        # Convert the document fields to a dictionary and cast string prices to integers
        sport_pricing = {int(k): int(v) for k, v in doc.to_dict().items()}
        pricing[sport_name] = sport_pricing
    return pricing




def fetch_overrides_from_firestore():
    overrides = []
    docs = db.collection('overrides').stream()
    for doc in docs:
        override = doc.to_dict()
        overrides.append(override)
    return overrides

# Utility functions
def parse_time_range(start, end):
    return time.fromisoformat(start), time.fromisoformat(end)


def is_within_time_range(check_time, time_range):
    start, end = parse_time_range(*time_range)
    return start <= check_time <= end


def get_override_price(sport, duration, date, time_string, overrides,default_pricing):
    query_date = datetime.strptime(date, "%Y-%m-%d").date()
    query_time = time.fromisoformat(time_string)
    query_day = query_date.strftime("%A")

    applicable_override = None
    for override in overrides:
        if (
            override["type"] == "date"
            and query_date == datetime.strptime(override["date"], "%Y-%m-%d").date()
        ):
            if "time_range" in override and is_within_time_range(
                query_time, override["time_range"]
            ):
                applicable_override = override
                break
        elif override["type"] == "day" and override["day"] == query_day:
            if "time_range" in override and is_within_time_range(
                query_time, override["time_range"]
            ):
                applicable_override = override
        elif override["type"] == "time":
            if is_within_time_range(query_time, override["time_range"]):
                applicable_override = override

    if applicable_override:
        return default_pricing[sport][duration] + applicable_override["adjustment"]
    return default_pricing[sport][duration]