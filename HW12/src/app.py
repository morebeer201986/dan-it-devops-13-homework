from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)
FILE_NAME = "students.csv"
FIELDNAMES = ["id", "first_name", "last_name", "age"]


# --- Helper functions --- 

def read_students():
    if not os.path.exists(FILE_NAME):
        return []

    with open(FILE_NAME, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        return list(reader)


def write_students(students):
    with open(FILE_NAME, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(students)


def generate_id(students):
    if not students:
        return 1
    return max(int(student["id"]) for student in students) + 1


# --- GET ---

@app.route("/students", methods=["GET"])
def get_students():
    students = read_students()

    student_id = request.args.get("id")
    last_name = request.args.get("last_name")

    if student_id:
        for student in students:
            if student["id"] == student_id:
                return jsonify(student)
        return jsonify({"error": "Student not found"}), 404

    if last_name:
        filtered = [s for s in students if s["last_name"] == last_name]
        if not filtered:
            return jsonify({"error": "Student not found"}), 404
        return jsonify(filtered)

    return jsonify(students)


# --- POST ---

@app.route("/students", methods=["POST"])
def create_student():
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    if set(data.keys()) != {"first_name", "last_name", "age"}:
        return jsonify({"error": "Invalid or missing fields"}), 400

    students = read_students()
    new_student = {
        "id": str(generate_id(students)),
        "first_name": data["first_name"],
        "last_name": data["last_name"],
        "age": str(data["age"])
    }

    students.append(new_student)
    write_students(students)

    return jsonify(new_student), 201


# --- PUT ---

@app.route("/students/<int:student_id>", methods=["PUT"])
def update_student(student_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    if set(data.keys()) != {"first_name", "last_name", "age"}:
        return jsonify({"error": "Invalid or missing fields"}), 400

    students = read_students()

    for student in students:
        if int(student["id"]) == student_id:
            student["first_name"] = data["first_name"]
            student["last_name"] = data["last_name"]
            student["age"] = str(data["age"])
            write_students(students)
            return jsonify(student)

    return jsonify({"error": "Student not found"}), 404


# --- PATCH ---

@app.route("/students/<int:student_id>", methods=["PATCH"])
def update_age(student_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    if set(data.keys()) != {"age"}:
        return jsonify({"error": "Invalid or missing fields"}), 400

    students = read_students()

    for student in students:
        if int(student["id"]) == student_id:
            student["age"] = str(data["age"])
            write_students(students)
            return jsonify(student)

    return jsonify({"error": "Student not found"}), 404


# --- DELETE ---

@app.route("/students/<int:student_id>", methods=["DELETE"])
def delete_student(student_id):
    students = read_students()
    new_students = [s for s in students if int(s["id"]) != student_id]

    if len(new_students) == len(students):
        return jsonify({"error": "Student not found"}), 404

    write_students(new_students)
    return jsonify({"message": "Student deleted successfully"})


if __name__ == "__main__":
    app.run(debug=True)
