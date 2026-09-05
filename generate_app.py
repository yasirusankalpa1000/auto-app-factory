import os
import re
import requests
import time

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY repository secret is missing!")

url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key={GEMINI_API_KEY}"

prompt = """
You are an expert Flutter developer. Generate a unique, fully functional, feature-rich single-file Flutter app (main.dart) for a useful utility or tool.

CRITICAL UI & CODE RULES:
1. DO NOT generate the default Flutter counter app ("You have pushed the button this many times").
2. The UI and logic MUST strictly match the generated APP_NAME and DESCRIPTION.
3. NO OVERFLOW ERRORS: Always use `Wrap`, `SingleChildScrollView`, or `FittedBox` for lists of badges/chips/buttons so they never clip or overflow screen boundaries horizontally.
4. DOLLAR SIGN ESCAPING: Always escape raw dollar signs in text strings with a backslash (e.g., use \\$12.99 instead of $12.99).
5. STRICT FLUTTER & DART SYNTAX RULES:
   - NEVER chain `.writeln()` on `StringBuffer()` initialization (e.g., DO NOT write `var sb = StringBuffer().writeln()`). Initialize `StringBuffer()` first, then call `.writeln()` on new lines.
   - Always use official Flutter color names (e.g., `Colors.green`, `Colors.teal`, `Colors.blue`). NEVER use non-existent color names like `Colors.emerald`.
   - For `decoration:` in input fields, ALWAYS wrap with `InputDecoration(border: OutlineInputBorder(...))`, NEVER pass `OutlineInputBorder` directly to `decoration`.
   - Use `TextAlign.center` (lowercase 'c'), NEVER `TextAlign.Center`.
   - In `Wrap` widget, use `crossAxisAlignment:`, NEVER `crossAlignment:`.
   - Use `EdgeInsets.symmetric(vertical: X)` or `EdgeInsets.all(X)`, NEVER `EdgeInsets.vertical(X)`.
6. Ensure clean, modern Material 3 styling with proper padding, scrollable views, and responsive layouts.

Strictly follow this exact text output format:

===APP_NAME===
[Unique App Name]

===DESCRIPTION===
[Detailed description of what the app actually does]

===CHECKLIST===
1. [Test item 1]
2. [Test item 2]
3. [Test item 3]

===CODE===
import 'package:flutter/material.dart';
// [Insert full custom Flutter main.dart code here]
"""

payload = {"contents": [{"parts": [{"text": prompt}]}]}
headers = {"Content-Type": "application/json"}

# API එක Busy වුණොත් පාරවල් 3ක් Retry කරන කොටස
max_retries = 3
data = {}

for attempt in range(max_retries):
    print(f"Sending Request to Gemini API (Attempt {attempt + 1}/{max_retries})...")
    response = requests.post(url, json=payload, headers=headers)
    data = response.json()
    
    if "error" not in data:
        break
    
    print(f"Attempt {attempt + 1} Failed: {data['error'].get('message', 'Unknown Error')}")
    if attempt < max_retries - 1:
        print("Waiting 10 seconds before retrying...")
        time.sleep(10)

if "error" in data:
    raise Exception(f"Gemini API Error after {max_retries} retries: {data['error'].get('message')}")

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

# Auto-fix common Gemini Syntax & Dart Method chaining errors
code = re.sub(r'(?<!\\)\$(?=[0-9])', r'\\$', code)
code = re.sub(r'TextAlign\.Center', 'TextAlign.center', code)
code = re.sub(r'crossAlignment:', 'crossAxisAlignment:', code)
code = re.sub(r'EdgeInsets\.vertical\((.*?)\)', r'EdgeInsets.symmetric(vertical: \1)', code)
code = re.sub(r'Colors\.emerald', 'Colors.teal', code)
code = re.sub(r'decoration:\s*(const\s*)?OutlineInputBorder\(', r'decoration: InputDecoration(border: OutlineInputBorder(', code)
code = re.sub(r'(\w+)\s*=\s*StringBuffer\(\)\.writeln\(', r'final \1 = StringBuffer();\n\1.writeln(', code)

if not code or "You have pushed the button this many times" in code:
    raise Exception("Gemini generated default counter code! Retrying required.")

# App ID එකක් සදාගැනීම
app_id = re.sub(r'[^a-zA-Z0-9]', '_', app_name.lower()).strip('_')

os.makedirs("lib", exist_ok=True)
os.makedirs(f"apps/{app_id}", exist_ok=True)

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

with open(f"apps/{app_id}/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"📱 *App Name:* {app_name}\n🆔 *App ID:* `{app_id}`\n\n📝 *Description:* {description}\n\n🧪 *Testing Checklist:*\n{checklist}")
    
