;; Caesar cipher    -*- mode: nasm; -*-
;; This program will get input from user and encrypt it using caesar cipher.
;; The program does not handle non-letter characters, leaves them intact.
;; strtoi function will convert any ascii numeric string into number,
;; if the string is invalid, it will return 0. strtoi will read the string
;; until it encounters a non-numeric ascii character.
;; encrypt function will encrypt the string using caesar cipher. It does not
;; See line comments for more detailed description

global main
global strtoi
global encrypt

;; syscall numbers for better readability
%define SC_WRITE 1
%define SC_READ 0

;; file descriptors for standard input and standard output
%define STDOUT 1
%define STDIN 0

;; length of strings
%define FIRST_PROMPT_LENGTH 19
%define SECOND_PROMPT_LENGTH 24
%define INFO_MESSAGE_LENGTH 17
%define ENCRYPTION_MESSAGE_LENGTH 12
%define ERROR_LENGTH 38
%define BUFFER_LENGTH 400

section .data
        first_prompt db 'Enter shift value: ', 0
        second_prompt db 'Enter original message: ', 0
        info_message db 'Current message: ', 0
        encryption_message db 'Encryption: ', 0
        error_message db 'Error: please enter valid information', 10, 0

section .bss
        buffer resb BUFFER_LENGTH         ; 400-byte buffer for storing string

section .text

;;;
;; main -- entrypoint of the program
;; get the shift count and string from stdin, write encrypted string to stdout.
;;;
main:
        push rbp
        mov rbp, rsp

        ; write first prompt
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, first_prompt
        mov rdx, FIRST_PROMPT_LENGTH
        syscall

        ; get shift count from user
        mov rax, SC_READ
        mov rdi, STDIN
        mov rsi, buffer
        mov rdx, BUFFER_LENGTH
        syscall

        ; check for errors
        cmp rax, 0
        jle .error

        ; convert string to number
        mov rdi, buffer         ; string
        mov rsi, rax            ; length
        call strtoi

        ; check number, must be in range (0, 26)
        cmp rax, 26
        jae .error

        push rax                ; save shift count

        ; write second prompt
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, second_prompt
        mov rdx, SECOND_PROMPT_LENGTH
        syscall

        ; read original string
        mov rax, SC_READ
        mov rdi, STDIN
        mov rsi, buffer
        mov rdx, BUFFER_LENGTH
        syscall

        ; check for errors
        cmp rax, 30             ; must be >= 30 characters
        jl .error

        push rax                ; save length of string

        ; write 'Current message: '
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, info_message
        mov rdx, INFO_MESSAGE_LENGTH
        syscall

        ; write message
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, buffer         ; print buffer
        pop rdx                 ; restore length from stack, into rdx
        push rdx                ; save again to use later
        syscall

        ; write 'Encryption: '
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, encryption_message
        mov rdx, ENCRYPTION_MESSAGE_LENGTH
        syscall

        ; do the caesar encryption
        mov rdi, buffer
        pop rsi                 ; restore length of string from stack
        pop rdx                 ; restore shift count from stack
        push rsi                ; save the length, again.
        call encrypt

        ; write encrypted message
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, buffer
        pop rdx                 ; restore length from stack
        syscall

        xor rax, rax            ; exit code = 0 (success)

        jmp .end

.error:
        ; output the error message
        mov rax, SC_WRITE
        mov rdi, STDOUT
        mov rsi, error_message
        mov rdx, ERROR_LENGTH
        syscall

        mov rax, 1              ; exit code = 1 (error)

.end:
        mov rsp, rbp
        pop rbp
        ret
;; -------------------------------------------------------------------

;;;
;; encrypt -- encrypt the string using caesar cipher
;; rdi: string, rsi: length of string, rdx: shift count
;;;
encrypt:
        push rbp
        mov rbp, rsp

        xor rcx, rcx            ; set position to zero
        mov r8, rdx             ; r8 => shift count
        mov r9, rsi             ; r9 => length of string
        mov r10, rdi            ; r10 => string pointer

.repeat:
        cmp rcx, r9             ; check bounds
        jae .end                ; terminate if position >= length

        ; load byte at current position
        mov rsi, r10
        add rsi, rcx            ; rsi = rdi[rcx]
        lodsb                   ; load byte into rax

        cmp rax, 'a'            ; lowercase?
        jae .lowercase
        cmp rax, 'A'            ; uppercase?
        jae .uppercase
        jmp .continue           ; leave character intact if it is not a letter.

.uppercase:
        cmp rax, 'Z'            ; check if this is really a letter
        ja .continue
        ; shift the letter
        sub rax, 'A'
        add rax, r8
        xor rdx, rdx            ; zero out upper part of dividend
        mov rbx, 26             ; divisor is rbx (26)
        div rbx                 ; remainder is rdx
        mov rax, rdx
        add rax, 'A'
        ; get character address
        mov rdi, r10
        add rdi, rcx            ; current character address
        stosb                   ; store shifted letter
        jmp .continue

.lowercase:
        cmp rax, 'z'
        ja .continue
        ; shift the letter
        sub rax, 'a'
        add rax, r8
        xor rdx, rdx            ; zero out upper part of dividend
        mov rbx, 26             ; divisor is 26
        div rbx                 ; remainder is rdx
        mov rax, rdx
        add rax, 'a'
        ; get character address
        mov rdi, r10
        add rdi, rcx            ; current character address
        stosb                   ; store shifted letter

.continue:
        inc rcx                 ; advance the position in string.
        jmp .repeat

.end:
        mov rsp, rbp
        pop rbp
        ret

;; -------------------------------------------------------------------

;;;
;; strtoi -- convert string to integer
;; rdi: string, rsi: length of string
;;;
strtoi:
        xor rcx, rcx            ; initialize string position to zero.
        mov rbx, rsi            ; we will use rsi for another purposes below
        xor r8, r8              ; r8 will hold the result, initialize to zero.
.repeat:
        cmp rcx, rbx            ; compare position and length
        jae .end                ; terminate if position >= length

        ; get a byte from string
        mov rsi, rdi            ; rsi = string start
        add rsi, rcx            ; to get byte at position rdi+rcx
        lodsb                   ; load the byte into rax

        ; check the character code to calculate result
        ; rax must be in range ['0', '9']
        cmp rax, '0'            ; compare rax with character code of '0'
        jl .end                 ; terminate if rax < '0'
        cmp rax, '9'            ; compare rax with character code of '9'
        ja .end                 ; terminate if rax > '9'

        sub rax, '0'            ; get numeric value of character code.
        imul r8, r8, 10         ; multiply result by 10
        add r8, rax             ; add digit to result

        inc rcx                 ; advance position
        jmp .repeat

.end:
        mov rax, r8
        ret

;; -------------------------------------------------------------------
