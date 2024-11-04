from flask import Flask, render_template, request, flash
from pymongo import MongoClient, errors
import openai

# Flask configuration
app = Flask(__name__)
app.secret_key = "supersecretkey"

# MongoDB configuration
mongo_client = MongoClient(
    "mongodb://<user>:<pass>@<mongoIP>:27017/vector_db?authSource=admin"
)
db = mongo_client["vector_db"]
collection = db["texts"]

# OpenAI API configuration
openai.api_key = "<api key>"

def generate_vector(text):
    """Generate vector embedding using OpenAI."""
    try:
        response = openai.Embedding.create(
            model="text-embedding-ada-002",  # Use the latest model
            input=text
        )
        return response['data'][0]['embedding']
    except Exception as e:  # General exception handling for OpenAI errors
        flash(f"Error generating vector: {str(e)}", "danger")
        return None

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        text = request.form['text']
        vector = generate_vector(text)

        if vector:
            try:
                collection.insert_one({'text': text, 'vector': vector})
                flash('Text and vector saved successfully!', 'success')
            except errors.PyMongoError as e:
                flash(f"Database Error: {str(e)}", "danger")

    return render_template('index.html')

@app.route('/search', methods=['GET'])
def search():
    keyword = request.args.get('keyword', '')
    results = []

    if keyword:
        try:
            results = list(collection.find({"text": {"$regex": keyword, "$options": "i"}}))
        except errors.PyMongoError as e:
            flash(f"Database Error: {str(e)}", "danger")

    return render_template('index.html', results=results, keyword=keyword)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
