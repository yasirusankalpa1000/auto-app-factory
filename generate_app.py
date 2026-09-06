import os
import re
import requests
import time

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY repository secret is missing!")

url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key={GEMINI_API_KEY}"

prompt = """
You are an expert Flutter developer and creative product designer.

APP CONCEPT & NICHE TARGET:
- Generate a highly UNIQUE, SPECIALIZED single-file Flutter utility app (main.dart) that solves a SPECIFIC, NICHE, or UNDERSERVED daily micro-problem.
- TARGET UNCOMMON PRACTICAL TOOLS (Examples: 3D Printing Filament & Cost Estimator, DIY Electronics Battery Power Duration Calculator, Freelance Project Hourly Rate vs Expense Analyzer, Printing DPI & Paper Aspect Ratio Helper, Solar Panel Angle & Power Yield Estimator, Micro-Habit Penalty Tracker, Recipe Batch & Ingredient Ratio Scaler, Audio Bitrate & File Size Calculator).
- STRICTLY AVOID generic oversaturated app ideas: NEVER generate Todo Lists, Notes Apps, Weather Apps, Standard Calculators, Stopwatches, Flashlight Apps, or Counter Apps.
- meka hadaddi mathaka athuva vadagath play store/onama app dana thanakata dammama minissu porakaka download karana vidiyata vadagath app ekak hadanna!anika me hadana app eka godak denekta prayojavavath ekak venna ona!meka market ekata avama misissu porakaka app eka ganna ona!
CRITICAL UI & CODE RULES:
1. DO NOT generate the default Flutter counter app ("You have pushed the button this many times").
2. The UI and logic MUST strictly match the generated APP_NAME and DESCRIPTION.
3. PERFECT MOBILE SCREEN RESPONSIVENESS & ZERO OVERFLOW:
   - Every screen body MUST be wrapped in `SafeArea` and `SingleChildScrollView` (or `ListView`) so vertical pixel overflow NEVER occurs on smaller mobile screens.
   - All `Text` widgets MUST be constrained using `Flexible`, `Expanded`, or `FittedBox`, and use `softWrap: true` or `overflow: TextOverflow.ellipsis` so words NEVER bleed or extend past horizontal screen edges.
   - Use `Wrap` widgets or scrollable horizontal rows for badges, chips, buttons, and tab bars to guarantee they stay within visible bounds.
4. DOLLAR SIGN ESCAPING: Always escape raw dollar signs in text strings with a backslash (e.g., use \\$12.99 instead of $12.99).
5. STRICT FLUTTER & DART SYNTAX RULES:
   - ICONS RULE: ONLY use core standard Flutter icons (e.g., `Icons.add`, `Icons.star`, `Icons.home`, `Icons.settings`, `Icons.person`, `Icons.check`, `Icons.edit`, `Icons.delete`, `Icons.favorite`, `Icons.info`, `Icons.search`, `Icons.share`, `Icons.refresh`, `Icons.widgets`, `Icons.apps`, `Icons.build`, `Icons.calculate`, `Icons.precision_manufacturing`). NEVER invent icon names!
   - WIDGET PARAMETER RULE: `style:` parameter MUST ONLY be used inside `Text(...)` widgets. NEVER pass `style:` to `Padding`, `Container`, `SizedBox`, `Column`, `Row`, or `Center`.
   - NEVER chain `.writeln()` on `StringBuffer()` initialization. Initialize `StringBuffer()` first, then call `.writeln()`.
   - Always use official Flutter color names (e.g., `Colors.green`, `Colors.teal`, `Colors.blue`).
   - For `decoration:` in input fields, ALWAYS wrap with `InputDecoration(border: OutlineInputBorder(...))`.
   - Use `TextAlign.center` (lowercase 'c'), NEVER `TextAlign.Center`.
   - In `Wrap` widget, use `crossAxisAlignment:`, NEVER `crossAlignment:`.
   - Use `EdgeInsets.symmetric(vertical: X)` or `EdgeInsets.all(X)`.
6. Ensure clean, modern Material 3 styling with proper padding, scrollable views, and responsive layouts.

Strictly follow this exact text output format:

===APP_NAME===
[Unique Niche App Name]

===DESCRIPTION===
[Detailed description of what problem this app specifically solves]

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

# API එක Busy වුණොත් තත්පර 25ක් ඉඳලා 3 පාරක් Auto Retry වෙන කොටස
max_retries = 3
data = {}

for attempt in range(max_retries):
    print(f"Sending Request to Gemini API (Attempt {attempt + 1}/{max_retries})...")
    try:
        response = requests.post(url, json=payload, headers=headers)
        data = response.json()
        if "error" not in data:
            break
        print(f"Attempt {attempt + 1} Failed: {data['error'].get('message', 'Unknown Error')}")
    except Exception as e:
        print(f"Attempt {attempt + 1} Connection Error: {e}")
        
    if attempt < max_retries - 1:
        print("Waiting 25 seconds before retrying...")
        time.sleep(25)

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

# Auto-fix common Gemini Syntax, Invalid Icons & Dart Method chaining errors
code = re.sub(r'(?<!\\)\$(?=[0-9])', r'\\$', code)
code = re.sub(r'TextAlign\.Center', 'TextAlign.center', code)
code = re.sub(r'crossAlignment:', 'crossAxisAlignment:', code)
code = re.sub(r'EdgeInsets\.vertical\((.*?)\)', r'EdgeInsets.symmetric(vertical: \1)', code)
code = re.sub(r'Colors\.emerald', 'Colors.teal', code)
code = re.sub(r'decoration:\s*(const\s*)?OutlineInputBorder\(', r'decoration: InputDecoration(border: OutlineInputBorder(', code)
code = re.sub(r'(\w+)\s*=\s*StringBuffer\(\)\.writeln\(', r'final \1 = StringBuffer();\n\1.writeln(', code)

# Fix non-existent Icons hallucinated by Gemini
code = re.sub(r'Icons\.sample_\w+', 'Icons.widgets', code)
code = re.sub(r'Icons\.custom_\w+', 'Icons.apps', code)

# Remove invalid style: parameter from Padding/Container
code = re.sub(r'Padding\(\s*style:[^,]+,', 'Padding(', code)

if not code or "You have pushed the button this many times" in code:
    raise Exception("Gemini generated default counter code! Retrying required.")

# App ID එකක් සාදාගැනීම
app_id = re.sub(r'[^a-zA-Z0-9]', '_', app_name.lower()).strip('_')

os.makedirs("lib", exist_ok=True)
os.makedirs(f"apps/{app_id}", exist_ok=True)

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

with open(f"apps/{app_id}/main.dart", "w", encoding="utf-8") as f:
    f.write(code)

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"📱 *App Name:* {app_name}\n🆔 *App ID:* `{app_id}`\n\n📝 *Description:* {description}\n\n🧪 *Testing Checklist:*\n{checklist}")
    
