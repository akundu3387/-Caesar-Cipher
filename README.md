# -Caesar-Cipher
April 20, 2022

Implemented a basic encryption scheme known as a caesar cipher. 

The caesar cipher involves shifting every letter in the given string by a given number in the alphabet.

Program is written in NASM Assembly Language for 64 bit Intel Architecture

------------------------------------------------------------------------------------------------------------------
**Project Details**

- Asks the user for a location between 0-25 (includes error checking)

- Asks the user for a string and displays the unedited string that the user entered. string from the user will be more than 30 characters long (spaces
included)

- displays an edited string to the user edited in the following way:

Shift every letter in the message by the indicated number of positions in the
alphabet. When a letter gets shifted past the beginning or end of the alphabet,
wrap around to the other end to continue. For example, a 6 would shift any 'e'
characters to 'k'. The shift must be applied to all letters in the message. Do not
change any non-alphabet characters in the message, and preserve all
capitalization.

------------------------------------------------------------------------------------------------------------------

**To Assemble Program:**

- Assemble it using: nasm –f elf64 filename.asm

- Link to create executable: gcc –m64 –o filename filename.o

- Execute program: ./caesar 

------------------------------------------------------------------------------------------------------------------
**Sample run 1:**

Enter shift value: 6

Enter original message: This is the original message.

Current message: This is the original message.

Encryption: Znoy oy znk uxomotgr skyygmk.


**Sample run 2:**

Enter shift value: 10

Enter original message: This is the original message.

Current message: This is the original message.

Encryption: Drsc sc dro ybsqsxkv wocckqo.
