import os
import json
import requests

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY repository secret is missing!")

# Gemini 2.5 Flash Model
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={GEMINI_API_KEY}"

prompt = """
You are an expert Flutter developer. Generate a unique, fully working single-file Flutter app (main.dart) for a useful tool or utility.
Return JSON strictly in this format without markdown code block wrappers:
{
  "app_name": "App Name",
  "description": "Short description",
  "checklist": "1. Test X\\n2. Test Y\\n3. Test Z",
  "code": "import 'package:flutter/material.dart'; ..."
}
"""

payload = {"contents": [{"parts": [{"text": prompt}]}]}
headers = {"Content-Type": "application/json"}

response = requests.post(url, json=payload, headers=headers)
data = response.json()

if "error" in data:
    print("API Error Response:", json.dumps(data, indent=2))
    raise Exception(f"Gemini API Error: {data['error'].get('message', 'Unknown Error')}")

if "candidates" not in data or not data["candidates"]:
    print("Unexpected Response:", json.dumps(data, indent=2))
    raise Exception("No candidate response generated from Gemini API.")

text_response = data['candidates'][0]['content']['parts'][0]['text'].strip()

if text_response.startswith("```json"):
    text_response = text_response[7:]
if text_response.startswith("```"):
    text_response = text_response[3:]
if text_response.endswith("```"):
    text_response = text_response[:-3]

app_data = json.loads(text_response.strip())

os.makedirs("lib", exist_ok=True)
with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(app_data["code"])

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"📱 *App Name:* {app_data['app_name']}\n\n📝 *Description:* {app_data['description']}\n\n🧪 *Testing Checklist:*\n{app_data['checklist']}")
    
