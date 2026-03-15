import random

def guess_the_number():
    # === The program generates a number between 5 and 10 ===
    correct_number = random.randint(1, 100)
    
    # === The program allows you to make 5 attempts ===
    for attempt in range(5):
        # === Asking the user to enter a number ===
        guess = int(input("Enter your guess: "))
        
        # === Checking the selected number ===
        if guess == correct_number:
            print("Congratulations! You guessed the right number.")
            return  # === We exit the function because the player has won ===
        elif guess < correct_number:
            print("Too low")
        else:
            print("Too high")
            
    # === Цей рядок буде виконано лише в тому випадку, якщо цикл завершився (після 5 спроб), а число не було вгадано ===
    print("Sorry, you've run out of attempts. The correct number was", correct_number)


guess_the_number()