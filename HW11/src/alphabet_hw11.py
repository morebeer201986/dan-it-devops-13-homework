class Alphabet:
    
    # == Configuring the initial settings ==
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = list(letters)
        
    # == Let's print letters ==
    def print(self):
        print(self.letters)
        
    # Counting the number of letters
    def letters_num(self):
        return len(self.letters)


# == English Alphabet Class ==
class EngAlphabet(Alphabet):
    
    # == A hidden variable with a certain number of letters ==
    _letters_num = 26
    
    def __init__(self):
        # == We pass the name ‘En’ and the letters themselves to the base class ==
        super().__init__('En', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        
    # == Check if the letter is in English ==
    def is_en_letter(self, letter):
        # == We capitalize the letter to avoid mistakes ==
        big_letter = letter.upper() 
        
        # == A simple check using if/else ==
        if big_letter in self.letters:
            return True
        else:
            return False
            
    # == Let's return our hidden variable _letters_num ==
    def letters_num(self):
        return EngAlphabet._letters_num
        
    # == Static method ==
    @staticmethod
    def example():
        return "Hello, this is an example text in English."



if __name__ == "__main__":
    
    # == Create our English alphabet ==
    my_abc = EngAlphabet()
    
    # == Printing letters ==
    print("Letters of alphabet:")
    my_abc.print()
    
    # Number of letters
    print("\nNumber of letters:")
    print(my_abc.letters_num())
    
    # Checking 'Q'
    print("\nIs ‘Q’ an English letter??")
    print(my_abc.is_en_letter('Q'))
    
    # Chacking 'Ї'
    print("\nIs ‘Ї’ an English letter??")
    print(my_abc.is_en_letter('Ї'))
    
    # Example text
    print("\nExample text:")
    print(EngAlphabet.example())