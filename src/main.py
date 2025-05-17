import openai
from openai import OpenAI
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()

# Create an OpenAI client. It will automatically look for the OPENAI_API_KEY environment variable.
# Ensure OPENAI_API_KEY is set in your environment or .env file.
client = OpenAI()

app = Flask(__name__)
CORS(app)

def chat_with_gpt(prompt):
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": prompt}]
    )
    return response.choices[0].message.content.strip()

@app.route('/chat', methods=['POST'])
def chat_endpoint():
    data = request.json
    user_input = data.get('prompt')
    if not user_input:
        return jsonify({"error": "No prompt provided"}), 400
    
    response = chat_with_gpt(user_input)
    return jsonify({"response": response})

if __name__ == "__main__":
    app.run(debug=True, port=5000)

