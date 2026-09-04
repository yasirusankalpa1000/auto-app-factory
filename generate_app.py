import os
import re
import requests

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY repository secret is missing!")

url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key={GEMINI_API_KEY}"

prompt = """
You are an expert Flutter developer. Generate a unique, fully working single-file Flutter app (main.dart) for a useful tool or utility.

Strictly follow this exact text output format using the section delimiters below:

===APP_NAME===
[Insert short App Name here]

===DESCRIPTION===
[Insert short description here]

===CHECKLIST===
1. [Test item 1]
2. [Test item 2]
3. [Test item 3]

===CODE===
import 'package:flutter/material.dart';
// [Insert complete, production-ready Flutter main.dart code here]
"""

payload = {"contents": [{"parts": [{"text": prompt}]}]}
headers = {"Content-Type": "application/json"}

response = requests.post(url, json=payload, headers=headers)
data = response.json()

if "error" in data:
    print("API Error Response:", data)
    raise Exception(f"Gemini API Error: {data['error'].get('message', 'Unknown Error')}")

if "candidates" not in data or not data["candidates"]:
    raise Exception("No candidate response generated from Gemini API.")

text_response = data['candidates'][0]['content']['parts'][0]['text']

def extract_section(text, header, next_header=None):
    pattern = rf"{header}\s*\n(.*?)(?={next_header}|$)" if next_header else rf"{header}\s*\n(.*)"
    match = re.search(pattern, text, re.DOTALL)
    return match.group(1).strip() if match else ""

app_name = extract_section(text_response, "===APP_NAME===", "===DESCRIPTION===") or "Auto Flutter App"
description = extract_section(text_response, "===DESCRIPTION===", "===CHECKLIST===") or "Generated Flutter App"
checklist = extract_section(text_response, "===CHECKLIST===", "===CODE===") or "1. Test all UI elements"
code = extract_section(text_response, "===CODE===")

if code.startswith("```dart"):
    code = code[7:]
elif code.startswith("```"):
    code = code[3:]
if code.endswith("```"):
    code = code[:-3]
code = code.strip()

if not code:
    raise Exception("Failed to extract valid Flutter code from Gemini response.")

os.makedirs("lib", exist_ok=True)
with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"📱 *App Name:* {app_name}\n\n📝 *Description:* {description}\n\n🧪 *Testing Checklist:*\n{checklist}")
    
