//** import google.generativeai as genai

genai.configure(api_key="AIzaSyDDXqEw67La5mkxK-Yy53q0nUhJIunZwow")

model = genai.GenerativeModel("gemini-2.0-flash")
response = model.generate_content("Dame ideas de productos para una fiesta de cumpleaños")
print(response.text) //
