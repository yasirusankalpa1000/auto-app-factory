import os
import re
import requests

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "").strip().strip("'").strip('"')
APP_ID = os.environ.get("APP_ID", "").strip()
BUG_DESCRIPTION = os.environ.get("BUG_DESCRIPTION", "Fix layout overflow and logic errors")

# Find the code file
file_path = f"apps/{APP_ID}/main.dart" if APP_ID and os.path.exists(f"apps/{APP_ID}/main.dart") else "lib/main.dart"

if not os.path.exists(file_path):
    raise Exception(f"Code file not found at {file_path}!")

with open(file_path, "r", encoding="utf-8") as f:
    existing_code = f.read()

# Corrected Model: gemini-2.5-flash
base_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
url = f"{base_url}?key={GEMINI_API_KEY}"

# Clean any illegal characters from URL
url = re.sub(r'[\[\]\(\)\s]', '', url)

prompt = f"""
You are an expert Flutter developer. Fix the following existing Flutter main.dart code based on the reported user issue.

REPORTED ISSUE / BUG TO FIX:
{BUG_DESCRIPTION}

CRITICAL FIX RULES:
1. Retain overall app logic, but fix all syntax errors and bugs.
2. NEVER instantiate abstract classes like StatelessWidget() or StatefulWidget(). Use SizedBox() or Container() instead.
3. NO OVERFLOW ERRORS: Use Wrap, SingleChildScrollView, or FittedBox for responsive layouts.
4. STRING ESCAPING: In Dart strings, escape dollar signs with a SINGLE backslash (e.g. \\$12.99), never double backslashes (\\\\$).
5. Valid Flutter syntax only.

Strictly follow this exact text output format:

===APP_NAME===
[Keep Original App Name]

===DESCRIPTION===
[Updated Description highlighting the fix]

===CHECKLIST===
1. Test fixed feature: {BUG_DESCRIPTION}
2. Test responsive layout
3. Test all buttons and features

===CODE===
import 'package:flutter/material.dart';
// [Insert full FIXED Flutter main.dart code here]
"""

payload = {"contents": [{"parts": [{"text": prompt + "\n\nEXISTING CODE TO FIX:\n" + existing_code}]}]}
headers = {"Content-Type": "application/json"}

response = requests.post(url, json=payload, headers=headers)
data = response.json()

if "error" in data:
    raise Exception(f"Gemini API Error: {data['error'].get('message', 'Unknown Error')}")

text_response = data['candidates'][0]['content']['parts'][0]['text']

def extract_section(text, header, next_header=None):
    pattern = rf"{header}\s*\n(.*?)(?={next_header}|$)" if next_header else rf"{header}\s*\n(.*)"
    match = re.search(pattern, text, re.DOTALL)
    return match.group(1).strip() if match else ""

app_name = extract_section(text_response, "===APP_NAME===", "===DESCRIPTION===") or "Fixed App"
description = extract_section(text_response, "===DESCRIPTION===", "===CHECKLIST===") or "Bug fixes applied"
checklist = extract_section(text_response, "===CHECKLIST===", "===CODE===") or "1. Test bug fixes"
code = extract_section(text_response, "===CODE===")

if code.startswith("```dart"):
    code = code[7:]
elif code.startswith("```"):
    code = code[3:]
if code.endswith("```"):
    code = code[:-3]
code = code.strip()

# Common Syntax Auto-fixes for LLM generated Flutter/Dart Code
code = re.sub(r'return\s+StatefulWidget\s*\([^)]*\);?', 'return const SizedBox();', code)
code = re.sub(r'return\s+StatelessWidget\s*\([^)]*\);?', 'return const SizedBox();', code)
code = re.sub(r'\\\\\$\b', r'\\$', code)
code = re.sub(r'TextAlign\.Center', 'TextAlign.center', code)
code = re.sub(r'crossAlignment:', 'crossAxisAlignment:', code)

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

if APP_ID:
    os.makedirs(f"apps/{APP_ID}", exist_ok=True)
    with open(f"apps/{APP_ID}/main.dart", "w", encoding="utf-8") as f:
        f.write(code)

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"🛠️ *FIXED APP:* {app_name}\n🆔 *App ID:* `{APP_ID}`\n\n📝 *Fix Summary:* {description}\n\n🧪 *Checklist:*\n{checklist}")
    
