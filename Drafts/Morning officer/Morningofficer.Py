import os
import asyncio
import datetime
import requests
import pygame
import edge_tts
from dotenv import load_dotenv
from xml.etree import ElementTree
from google import genai

# ==========================================
# CONFIGURATION
# ==========================================
# Load API Key securely from .env file
load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

USER_NAME = "Freeze"
CITY_NAME = "lucknow"
# VOICE SELECTION: 
# "en-GB-RyanNeural" (British - Like Jarvis)
# "en-US-ChristopherNeural" (American - Clean)
VOICE_NAME = "en-GB-RyanNeural" 

# ==========================================
# MODULE 1: THE SENSES
# ==========================================
def get_time_date():
    now = datetime.datetime.now()
    return now.strftime("%A, %B %d, %I:%M %p")

def get_weather(city):
    try:
        url = f"https://wttr.in/{city}?format=%C+%t"
        response = requests.get(url, timeout=5)
        return response.text.strip() if response.status_code == 200 else "Weather unavailable"
    except:
        return "Weather sensors offline"

def get_news_headlines():
    try:
        url = "https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en"
        response = requests.get(url, timeout=5)
        root = ElementTree.fromstring(response.content)
        headlines = [item.find('title').text for item in root.findall('./channel/item')[:3]]
        return " | ".join(headlines)
    except:
        return "No news feed available."

# ==========================================
# MODULE 2: THE BRAIN (Gemini)
# ==========================================
def generate_briefing(weather, news, time_str):
    if not GEMINI_API_KEY:
        return "Sir, my security protocols are preventing me from thinking. Please check your API key."

    client = genai.Client(api_key=GEMINI_API_KEY)
    
    prompt = (
        f"Role: You are Jarvis, a sophisticated AI butler."
        f"User: {USER_NAME}."
        f"Context: Time: {time_str}. Weather: {weather}. News: {news}."
        f"Task: Give a 3-sentence morning briefing."
        f"Style: Very polite, British, slightly sarcastic wittiness."
    )
    
    try:
        response = client.models.generate_content(
            model="gemini-2.5-flash", 
            contents=prompt
        )
        return response.text
    except Exception as e:
        return f"Sir, I cannot connect to the cloud. Error: {e}"

# ==========================================
# MODULE 3: THE VOICE (Neural Upgrade)
# ==========================================
async def stream_audio(text):
    """Generates MP3 and plays it using Pygame"""
    print(f"\n[JARVIS]: {text}")
    output_file = "jarvis_voice.mp3"
    
    # 1. Generate Audio
    communicate = edge_tts.Communicate(text, VOICE_NAME)
    await communicate.save(output_file)
    
    # 2. Play Audio
    pygame.mixer.init()
    pygame.mixer.music.load(output_file)
    pygame.mixer.music.play()
    
    # Wait for audio to finish
    while pygame.mixer.music.get_busy():
        pygame.time.Clock().tick(10)
        
    pygame.mixer.quit()
    
    # 3. Cleanup
    if os.path.exists(output_file):
        os.remove(output_file)

def speak(text):
    """Wrapper to run async function in sync code"""
    asyncio.run(stream_audio(text))

# ==========================================
# MAIN EXECUTION
# ==========================================
if __name__ == "__main__":
    print(">> SYSTEM ONLINE (Neural Voice Active)...")
    
    # Gather Data
    current_time = get_time_date()
    weather = get_weather(CITY_NAME)
    news = get_news_headlines()
    
    # Generate Thought
    print(">> Processing...")
    briefing = generate_briefing(weather, news, current_time)
    
    # Speak
    speak(briefing)