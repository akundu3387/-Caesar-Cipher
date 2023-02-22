# -Caesar-Cipher
Implemented a basic encryption scheme known as a caesar cipher. 

The caesar cipher involves shifting every letter in the given string by a given number in the alphabet.

Program is written in NASM Assembly Language for 64 bit Intel Architecture

------------------------------------------------------------------------------------------------------------------

- Asks the user for a location between 0-25 (includes error checking)

- Asks the user for a string and displays the unedited string that the user entered. string from the user will be more than 30 characters long (spaces
included)

- displays an edited string to the user edited in the following way:
- 
Shift every letter in the message by the indicated number of positions in the
alphabet. When a letter gets shifted past the beginning or end of the alphabet,
wrap around to the other end to continue. For example, a 6 would shift any 'e'
characters to 'k'. The shift must be applied to all letters in the message. Do not
change any non-alphabet characters in the message, and preserve all
capitalization.
