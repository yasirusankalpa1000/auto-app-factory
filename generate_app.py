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

APP CONCEPT & CREATIVE DIRECTION:
- me oya hadana app eka vadiya market eke nathi vennath ona anika user davase godak velavak app eke radila inna ona ethakotane passe kaleka add mob dammama davasata ad mob valin salli hoyanna puluvan!
- Invent a highly PRACTICAL, VIRAL-READY, and USEFUL single-file Flutter utility app (main.dart) that solves an everyday micro-problem faced by ordinary people in daily life.
- Focus on clever, high-demand tools that make general users say "I needed an app for this!" and eagerly download it.
- The app must solve a real-life pain point with high practical value, ensuring wide appeal and trending potential on app stores.
- DO NOT limit yourself to any specific industry or technical niche. Think freely about daily human routines, micro-decisions, efficiency helpers, and practical calculations.
- STRICTLY AVOID generic oversaturated app ideas: NEVER generate simple Todo Lists, basic Notes Apps, standard Weather Apps, basic Calculators, Stopwatches, Flashlight Apps, or Counter Apps.

CRITICAL UI & CODE RULES:
1. DO NOT generate the default Flutter counter app ("You have pushed the button this many times").
2. The UI and logic MUST strictly match the generated APP_NAME and DESCRIPTION.
3. PERFECT MOBILE SCREEN RESPONSIVENESS & ZERO OVERFLOW:
   - Every screen body MUST be wrapped in `SafeArea` and `SingleChildScrollView` (or `ListView`) so vertical pixel overflow NEVER occurs on smaller mobile screens.
   - All `Text` widgets MUST be constrained using `Flexible`, `Expanded`, or `FittedBox`, and use `softWrap: true` or `overflow: TextOverflow.ellipsis` so words NEVER bleed or extend past horizontal screen edges.
   - Use `Wrap` widgets or scrollable horizontal rows for badges, chips, buttons, and tab bars to guarantee they stay within visible bounds.
4. DOLLAR SIGN ESCAPING: Always escape raw dollar signs in text strings with a backslash (e.g., use \\$12.99 instead of $12.99).
5. STRICT FLUTTER & DART SYNTAX RULES:
   - COLOR RULE: ONLY use official standard Flutter colors (e.g., `Colors.white`, `Colors.black`, `Colors.blue`, `Colors.green`, `Colors.teal`, `Colors.grey`, `Colors.white70`). NEVER invent non-existent color shades like `Colors.white90` or `Colors.emerald`!
   - FONT WEIGHT RULE: ONLY use standard Flutter FontWeights (`FontWeight.bold`, `FontWeight.normal`, `FontWeight.w600`, `FontWeight.w700`, `FontWeight.w800`, `FontWeight.w500`). NEVER use invalid properties like `FontWeight.extrabold` or `FontWeight.semibold`!
   - ICONS RULE: ONLY use core standard Flutter icons (e.g., `Icons.add`, `Icons.star`, `Icons.home`, `Icons.settings`, `Icons.person`, `Icons.check`, `Icons.edit`, `Icons.delete`, `Icons.favorite`, `Icons.info`, `Icons.search`, `Icons.share`, `Icons.refresh`, `Icons.widgets`, `Icons.apps`, `Icons.build`, `Icons.calculate`, `Icons.monetization_on`, `Icons.schedule`, `Icons.stars`). NEVER invent icon names!
   - WIDGET PARAMETER RULE: `style:` parameter MUST ONLY be used inside `Text(...)` widgets. NEVER pass `style:` to `Padding`, `Container`, `SizedBox`, `Column`, `Row`, or `Center`.
   - NEVER chain `.writeln()` on `StringBuffer()` initialization. Initialize `StringBuffer()` first, then call `.writeln()`.
   - For `decoration:` in input fields, ALWAYS wrap with `InputDecoration(border: OutlineInputBorder(...))`.
   - Use `TextAlign.center` (lowercase 'c'), NEVER `TextAlign.Center`.
   - In `Wrap` widget, use `crossAxisAlignment:`, NEVER `crossAlignment:`.
   - Use `EdgeInsets.symmetric(vertical: X)` or `EdgeInsets.all(X)`.
   - NEVER use LaTeX math syntax like `$\\le$` or `$\\ge$` in strings. Use standard symbols like `<=` or `>=`.
   - NEVER instantiate abstract classes like `StatefulWidget()`. If a placeholder is needed, return `SizedBox()`.
6. Ensure clean, modern Material 3 styling with proper padding, scrollable views, and responsive layouts.

Strictly follow this exact text output format:

===APP_NAME===
[Unique High-Demand App Name]

===DESCRIPTION===
[Detailed description of the everyday problem this app solves]

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

# Auto-fix common Gemini Syntax, FontWeights, Invalid Colors, Invalid Icons & Dart Method chaining errors
code = re.sub(r'(?<!\\)\$(?=[0-9])', r'\\$', code)
code = re.sub(r'\\\$([a-zA-Z_{])', r'$\1', code) 
code = re.sub(r'TextAlign\.Center', 'TextAlign.center', code)
code = re.sub(r'crossAlignment:', 'crossAxisAlignment:', code)
code = re.sub(r'CrossAlignment\.', 'CrossAxisAlignment.', code)
code = re.sub(r'EdgeInsets\.vertical\((.*?)\)', r'EdgeInsets.symmetric(vertical: \1)', code)
code = re.sub(r'Colors\.emerald', 'Colors.teal', code)
code = re.sub(r'Colors\.white[0-9]+', 'Colors.white70', code)
code = re.sub(r'Colors\.black[0-9]+', 'Colors.black87', code)
code = re.sub(r'decoration:\s*(const\s*)?OutlineInputBorder\(', r'decoration: InputDecoration(border: OutlineInputBorder(', code)
code = re.sub(r'(\w+)\s*=\s*StringBuffer\(\)\.writeln\(', r'final \1 = StringBuffer();\n\1.writeln(', code)

# New Auto-fixes for LaTeX math and StatefulWidget abstraction errors
code = re.sub(r'\$\\\\?le\$', '<=', code)
code = re.sub(r'\$\\\\?ge\$', '>=', code)
code = re.sub(r'StatefulWidget\(', 'SizedBox(', code)

# Fix non-existent FontWeights hallucinated by Gemini
code = re.sub(r'FontWeight\.\w*extra\w*', 'FontWeight.bold', code, flags=re.IGNORECASE)
code = re.sub(r'FontWeight\.\w*semi\w*', 'FontWeight.w600', code, flags=re.IGNORECASE)

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

# app_info.txt එක ලිමිට් කර ලියාදැක්වීම (Telegram limit එක නොවදින්න)
short_description = description[:500] + "..." if len(description) > 500 else description

with open("app_info.txt", "w", encoding="utf-8") as f:
    f.write(f"📱 *App Name:* {app_name}\n🆔 *App ID:* `{app_id}`\n\n📝 *Description:* {short_description}\n\n🧪 *Testing Checklist:*\n{checklist}")
    
