import requests

BASE_URL = "http://127.0.0.1:5000/students"
results = []

def log_response(response):
    text = f"Status: {response.status_code}\nResponse: {response.json()}\n\n"
    print(text)
    results.append(text)


# --- GET all students ---
log_response(requests.get(BASE_URL))

# --- Create three students ---
log_response(requests.post(BASE_URL, json={
    "first_name": "Thirion","last_name": "Lanister","age": 20
}))

log_response(requests.post(BASE_URL, json={
    "first_name": "John","last_name": "Snow","age": 22
}))

log_response(requests.post(BASE_URL, json={
    "first_name": "Aria","last_name": "Stark","age": 19
}))

# --- GET all ---
log_response(requests.get(BASE_URL))

# --- PATCH second student (id=2) ---
log_response(requests.patch(f"{BASE_URL}/2", json={"age": 25}))

# --- GET second student ---
log_response(requests.get(BASE_URL, params={"id": 2}))

# --- PUT third student (id=3) ---
log_response(requests.put(f"{BASE_URL}/3", json={
    "first_name": "Sansa","last_name": "Stark","age": 21
}))

# --- GET third student ---
log_response(requests.get(BASE_URL, params={"id": 3}))

# --- GET all ---
log_response(requests.get(BASE_URL))

# --- DELETE first student (id=1) ---
log_response(requests.delete(f"{BASE_URL}/1"))

# --- GET all ---
log_response(requests.get(BASE_URL))


# Write results to file
with open("results.txt", "w") as f:
    f.writelines(results)
