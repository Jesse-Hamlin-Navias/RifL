#lang racket
;The Scanner-------------------------------------------------------
;Passed a string 's' and returns a tokenized list of 's'
(define (tokenize s)
  (token s 0 '()))

;Passed a string 's', a number 'count' which is a character pointer, and a token list 't'.
(define (token s count t)
  ;If the character pointer hasnt reached the end of the string
  (if (< count (string-length s))
      ;char = the character at in 's' at index 'count' 
      (let ((char (string-ref s count)))
              ;if 'char' is a letter or number, increase 'count' by 1
        (cond [(char-alphanumeric? char) (token s (+ count 1) t)]
              ;else if 'char' is an empty character
              [(or (eq? '#\space char) (eq? '#\tab char) (eq? '#\, char))
               ;if the first character of 's' is an empty character
               (if (= count 0)
                   ;chop of that first character of 's' and continue tokenizing
                   (token-inc s count t)
                   ;otherwise add everything before 'count' to 't' as a token,
                   ;then chop of everything in 's' thats before 'count' and keep tokenizing
                   (token-inc s count (j-append t (transform (string-head s count)))))]
              ;else if 'char' is a ":" or a newline character
              [(or (eq? '#\: char) (eq? '#\newline char))
               ;if the first character of 's' is a ":" or a newline character
               (if (= count 0)
                   ;Add the ":" or newline to 't', then keep tokenizing from after it
                   (token-inc s count (j-append t (string char)))
                   ;otherwise tokenize everything before the current count, then tokenize everything starting at the ":" or newline
                   (begin (set! t (j-append t (car (token (string-head s count) 0 '())))) (token (string-tail s count) 0 t)))]
              ;else if 'char' is a ">", interpret everything after until a newline as a comment
              [(eq? '#\> char)
               (if (= count 0)
                   (comment s count t)
                   (comment s count (j-append t (transform (string-head s count)))))]
              ;else we've encountered characters that are not in our langue, print an error
              [else (begin (print char) (print error))]
        )
      )
      ;if weve emptiede the string 's', tokenize anything thats left and return 't'
      (if (< 0 (string-length s)) (j-append t (transform s)) t)
  )
)

;Passed a string 's', a character pointer 'count', and tokens 't'.
;Moves 'count' up through a string 's' until 'count' finds a new line in 's' (the end of a comment)
;or exceeds the string, at which point token-inc is called, starting at the end of the comment,
;or in the case of running out of string, at the end of string.
(define (comment s count t)
  ;(display "comment: ") (print s) (display " ") (print count) (display " ") (print t) (newline)
  (if (or (>= count (string-length s)) (eq? '#\newline (string-ref s count)))
      (token-inc s (- count 1) t)
      (comment s (+ 1 count) t)))

;Passed a string 's', the character pointer 'count', and tokens 't'.
;Continues tokenizing onto 't' starting after character 'count' in 's', while reseting 'count' to 0.
(define (token-inc s count t)
  (token (string-tail s (+ 1 count)) 0 t))

;Passed a character 'char'. Returns 'true' if 'char' is in the alphebet or a digit.
(define (char-alphanumeric? char)
  (or (char-alphabetic? char) (char-numeric? char)))

;Passed two of anything. Appends 's' to 't' without unrapping 's'
;'(1 2 3) '(4 5 6) -> '(1 2 3 (4 5 6))
(define (j-append t s)
  (if (null? t)
      (cons s t)
      (cons
       (car t) (j-append (cdr t) s))
  )
)

;Passed a string 's' and converts it into machine readable token
(define (transform s)
  (if (> (string-length s) 1)
      (cond ((equal? "F" (string-head s 1)) (string-append "F" (transform (string-tail s 1))))
            ((equal? "A" (string-head s 1)) (string-append "1" (string-tail s 1)))
            ((equal? "10" (string-head s 2)) (string-append "0" (string-tail s 2)))
            (else s))
      s
  )
)

(define (display-all . args)
  (define (mprinter output args)
    (if (null? args) (display output) (mprinter (string-append output (car args)) (cdr args)))
    )
  (mprinter "" args)
 ) 

;-----------------------------------------------------------------
;Parser-----------------------------------------------------------
;Passed a table 'table' and a token[s-list] 'tokens.
;Table should always be created from 'make-table'.
;Tokens come from tokenize
(define (parse table tokens)
               ;^stack + last

  ;This is the data structure of the entire language:
  ;(stack ((name_0 * pile) ... (name_n * pile)))
  ;And this is the process that creates that:
  ;(cons stack (cons (cons (car t) set!) (recurse)))
  ;  ^last       ^table^deck ^name  ^pile  ^call table
  
  ;\/ tabler
  ;Passed a token[s-list] 'tokens' and a string 'lastname'
  ;Takes the tokens and splits it by newline characters, ie each deck
  ;Each of those lines are passed to 'decker'
  (define (tabler tokens lastname)
        ;(display "tabler: tokens ") (print tokens) (newline) (table 'display)
    ;t-start is the first line in tokens. t-end is all the lines after
    (let ((next-line (list-head-by-element tokens "\n"))
          (after (list-tail-by-element tokens "\n")))
            ;if there are no more lines left, return 'table'
      (cond [(null? next-line) table]
            ;[(null? t-end) (decker t-start lastname t-end)]
                                               ;\/recurse
            ;otherwise, add 't-start' into a deck, 'lastname' and 'after' are data carryover
            [else (decker next-line lastname after)]
            )))
  
  ;\/ decker
  ;Passed a list 't', a string 'lastname', and a carry-over list 't-end'
  (define (decker t lastname t-end)
    ;(display "decker ") (print t) (newline) (table 'display)
    ;(print t) (newline) (print name) (newline)
    ;name is the name of the deck before the ":" in 't'
    ;deck are the cards in the list after the ":"
    ;If there is no ":" in t, name = 't' and deck = '()
    (let ((name (list-head-by-element t ":"))
          (deck (list-tail-by-element t ":")))
            ;if there is nothing left to turn into decks, call tabler to output the table
      (cond [(zero? (string-length (car name))) (tabler t-end lastname)]
            ;if there is no ":", set deck equal to 't' and name to '()
            [(null? deck) (let ((deck name) (name '()))
               ;if 'deck' is formated correctly, add it to the table using the last name we found & call tabler
               (if (deck? deck)
                    (begin (table 'reverse-insert-data (table 'find lastname) deck) (tabler t-end lastname))
                    (if (zero? (string-length lastname))
                        (display-all "No deck name given for: " deck)
                        (display-all deck ": not a valid deck"))
                    ))]
            ;if there is a name and a deck, add 'deck' to the table and set the name we found as the last found name
            [(deck? deck) (if (name? name)
                              (begin
                                (table 'insert-data (table 'find name) (reverse deck))
                                (tabler t-end name))
                              (display-all name ": not a valid deck name"))]
            )
    ))
  
  ;Start the processes with all tokens and no last name found.
  (tabler tokens "")
)

;Chop off characters after index 'end' (inclusive)
(define (string-head string end)
  (substring string 0 end))

;Chop off characters at and before index 'start' (exclusive)
(define (string-tail string start)
  (substring string start (string-length string)))

;Finds the first instance of 's' in list 't', and returns all elements after 's' as a list
;If 's' is not in 't', return empty list
(define (list-tail-by-element t s)
  (cond ((null? t) '())
        ((equal? s (car t)) (cdr t))
        (else (list-tail-by-element (cdr t) s))))

;Finds the first instance of 's' in list 't', and returns all elements before 's' as a list
;If 's' is not in 't', return 't'
(define (list-head-by-element t s)
  (cond ((null? t) t)
        ((equal? s (car t)) '())
        (else (cons (car t) (list-head-by-element (cdr t) s)))))

;Passed a list 'l', returns reversed 'l' without reversing the contents of sub lists
(define (reverse l)
  (if (= (length l) 0)
     '()
     (j-append (reverse (cdr l)) (car l))
  ))

;-----------------------------------------------------------------------------------
;Closures----------------------------------------------------------------------------
;Passed nothing, returns an empty stack, which is local to the make-stack call
(define (make-stack)
   (let ((s '()))

     ;Used in lambda closure below
     (define (drop stack)
       (cond ((null? stack) '())
             ((null? (cdr stack)) (car stack))
             (else (drop (cdr stack)))))

     ; takes in 2 arguments: cmd (push, pop, top, display) rest (operator or operand), any number of arguments
     (lambda (cmd . rest) 
              ;if 'cmd' = top, return first token of 's'
      (cond  ((eq? 'top cmd)      (car s))
              ;if 'cmd' = length, return length of 's'
              ((eq? 'length cmd)   (length s))
              ;if 'cmd' = display, display 's'
              ((eq? 'display cmd)  (begin (display s) (newline)))
              ;if 'cmd' = push, put the first element of 'rest' ontop of 's'
              ((eq? 'push cmd)     (set! s (cons (car rest) s)))
              ;if 'cmd' = pop, then we remove the first element of 's' and return it
              ((eq? 'pop cmd)      (let ((v (car s))) (begin (set! s (cdr s)) v)))
              ;if 'cmd' = insert, put the first element of 'rest' on the bottom of 's'
              ((eq? 'insert cmd)     (set! s (j-append s (car rest))))
              ;if 'cmd' = drop, then we remove the last non '() element of 's' and return it
              ((eq? 'drop cmd)     (drop s))
              ;if 'cmd' = copy, then we return a copy of the stack as a list
              ((eq? 'copy cmd)      s) 
              ;else, the cmd is not proper input
              (else                (error 'unsupported-stack-op))
      )
    )
  )
)

;Passed nothing, returns an empty table, which is local to the make-table call
(define (make-table)
  ;This is the structure of a table: (stack ((name_0 * pile) ... (name_n * pile)))
  (let ((table (cons (make-stack) '())))
   ; takes in 2 arguments: cmd (push, pop, top, display) rest (operator or operand), any number of arguments

    (define (find-deck decks name)
      ;(display "find-deck: ") (print decks) (newline)
      (cond ((null? decks) (begin (set! table (j-append table (cons name (make-stack)))) (find-deck (cdr table) name)))
            ((equal? (caar decks) name) (cdar decks))
            (else (find-deck (cdr decks) name))))

    ;This returns the first argument of the given stack
    (define (get-data stack)
      (define (get-data2 stack)
        (cond ((= (stack 'length) 0) '())
              ((joker? (stack 'top)) '())
              ((face-down? (stack 'top)) '())
              (else (let ((card (stack 'pop))) (cons card (get-data2 stack))))))
    
      (cond ((= (stack 'length) 0) '())
            ((joker? (stack 'top)) (cons (stack 'pop) '()))
            ((face-down? (stack 'top)) (begin (stack 'pop) (get-data stack)))
            (else (let ((card (stack 'pop))) (reverse (cons card (get-data2 stack))))))
      )

    (define (print-struc str)
      (cond ((null? str) '())
            ((pair? str) (begin (print-struc (car str)) (print-struc (cdr str))))
            ((procedure? str) (str 'display))
            ((string? str) (begin (print str) (newline)))))
    
    (define (insert-data pile l)
      ;(display "insert-data: ") (pile 'display) (print l) (newline)
      (if (null? l) pile (begin (pile 'push (car l)) (insert-data pile (cdr l)))))

    (define (reverse-insert pile l)
      ;(display "insert-data: ") (pile 'display) (print l) (newline)
      (if (null? l) pile (begin (pile 'insert (car l)) (reverse-insert pile (cdr l)))))
    
    (lambda (cmd . rest) 
             ;if cmd = stack, return first element of table
      (cond  ((eq? 'stack cmd)      (car table))
             ;if cmd = find, return stack in table with matching name, or create new stack with name
             ((eq? 'find cmd)  (find-deck (cdr table) (car rest)))
             ;if cmd = get-data, pop top data of rest (rest must be a pile, not just a name)
             ((eq? 'get-data cmd)  (get-data (car rest)))
             ;if cmd = get-stack, pop top data of the table's stack
             ((eq? 'get-stack cmd)  (get-data (car table)))
             ;if cmd = instert-data, push data (second argument) onto pile (first argument)
             ((eq? 'insert-data cmd) (insert-data (car rest) (cadr rest)))
             ;if cmd = print, print table
             ((eq? 'print cmd) (print table))
             ;if cmd = display, display table
             ((eq? 'display cmd) (print-struc table))
             ;if cmd = reverse-insert-data, push rest onto the bottom of given deck
             ((eq? 'reverse-insert-data cmd) (reverse-insert (car rest) (cadr rest)))
             ;else, the cmd is not proper input
             (else                (begin (print cmd) (error 'unsupported-stack-op)))
             )
      )
  )
)
;------------------------------------------------------------------------------------------------------
;P--------------------------------------------------------------------------------------------

;Takes a string 'c', and returns 'true' if its a card
(define (card? c)
  (let ((p (string-head c 1)))
    (cond ((= (string-length c) 0) #f)
          ((number-card? c) #t)
          ((face-down? c) #t)
          ((face-card? c) #t)
          ((joker? c) #t)
          (else #f)
    )
  ))

;Takes a string 'card' and returns 'true' if its a number card
(define (number-card? card)
  (let ((p (pip card)))
  (if (or (equal? p "1") (equal? p "2") (equal? p "3") (equal? p "4") (equal? p "5") (equal? p "6") (equal? p "7") (equal? p "8") (equal? p "9") (equal? p "0"))
      (suit? (string-tail card 1))
      #f)))

;Takes a string 'card' and returns 'true' if its a face card
(define (face-card? card)
  (let ((p (pip card)))
    (if (or (equal? "J" p) (equal? "Q" p) (equal? "K" p)) (suit? (string-tail card 1)) #f)))

;Takes a string 'card' and returns 'true' if its a face down card
(define (face-down? card)
  (cond ((= (string-length card) 1)
              (equal? card "F"))
        ((and (equal? "F" (string-head card 1)) (not (equal? '#\F (string-ref card 1))))
              (card? (string-tail card 1)))
        (else #f)))

;Takes a string 'card' and returns 'true' if its a Joker
(define (joker? card)
  (equal? card "R"))

;Takes a string 'su' and returns 'true' if its a suit ("s" "c" "h" "d")
(define (suit? su)
  (or (equal? "s" su) (equal? "c" su) (equal? "h" su) (equal? "d" su)))

;Takes a card and returns the number value
(define (pip card)
  (string-head card 1))

;Takes a card and returns the suit, or "n" if the card is a Joker or face down
(define (suit card)
  (if (or (joker? (pip card)) (face-down? (pip card)))
      "n"
      (string-tail card 1)))

;Takes a list of strings and returns 'true' if its a valid name for a deck
(define (name? t)
  (define (name?er t)
    (or (zero? (length t)) (and (name?er (cdr t)) (number-card? (car t)))))
  (if (> (length t) 0) (name?er t) #f))

;Takes a list of strings and returns 'true' if its a valid deck
(define (deck? t)
  (or (zero? (length t)) (and (deck? (cdr t)) (card? (car t)))))
;---------------------------------------------------------------------------------------------------
;Conversions----------------------------------------------------------------------------------------

;Passed a list of cards and returns corresponding data (numbers, strings, bool)
(define (cards->data cards)
  ;(display "cards->data: ") (print cards) (newline)
  (cond [(null? cards) '()]
        [(or (equal? (suit (car cards)) "s")
             (equal? (suit (car cards)) "c"))
         (cards->number cards)]
        [(equal? (suit (car cards)) "d") (cards->bool cards)]
        [(equal? (suit (car cards)) "h") (cards->string cards)]
        [else '()])
  )

;Passed a number, string/char, or bool and returns the coresponding pile of cards
(define (data->cards data)
  (cond [(integer? data) (integer->cards data)]
        [(real? data) (decimal->cards data)]
        [(boolean? data) (bool->cards data)]
        [(or (string? data) (char? data)) (string->cards data)]
        [else '()])
  )

;Passed a pile of cards, returns the coresponding decimal or int
(define (cards->number cards)
  (define (card-decimal? cards)
    (cond [(null? cards) false]
          [(equal? (suit (car cards)) "d") true]
          [else (card-decimal? (cdr cards))])
  )
  (if (card-decimal? cards) (cards->decimal cards) (cards->integer cards))
)

;Passeds an integer, returns the coresponding integer
(define (integer->cards num)
  ;(display "integer->cards: ") (print num) (newline)
  (define (int->c num count)
    ;(display "int->c ") (print num) (display ", ") (print count) (newline)
    (if (> count num) (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "s")
              '())
        (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "s")
              (int->c (- num (modulo num count)) (* count 10))))
    )
  (define (-int->c num count)
    ;(display "int->c ") (print num) (display ", ") (print count) (newline)
    (if (> count num) (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "c")
              '())
        (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "c")
              (int->c (- num (modulo num count)) (* count 10))))
    )
  (if (> 0 num) (reverse (-int->c (* -1 num) 10)) (reverse (int->c num 10)))
 )

;Passed a pile of cards, returns the coresponding integer
(define (cards->integer cards)
  (define (c->int cards count)
    (if (null? cards) 0
        (+
         (* (string->number (pip (car cards))) count)
         (c->int (cdr cards) (* 10 count))))
    )
  (if (equal? (suit (car cards)) "c") (* -1 (c->int (reverse cards) 1)) (c->int (reverse cards) 1))
)

;Passed a decimal number, returns the coresponding pile of cards
(define (decimal->cards num)
  ;(display "integer->cards: ") (print num) (newline)
  (define (dec->c num count)
    ;(display "int->c ") (print num) (display ", ") (print count) (newline)
    (if (> count num) (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "s")
              '())
        (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "s")
              (dec->c (- num (modulo num count)) (* count 10))))
    )
  (define (-dec->c num count)
    ;(display "int->c ") (print num) (display ", ") (print count) (newline)
    (if (> count num) (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "c")
              '())
        (cons (string-append (number->string (/ (modulo num count) (/ count 10))) "c")
              (-dec->c (- num (modulo num count)) (* count 10))))
    )
  (define (fracmag num)
    (define (fracmag-help num count)
      (if (equal? (floor (* count num)) (* count num))
          count
          (fracmag-help num (* count 10)))
    )
    (fracmag-help num 1)
  )
  (if (> 0 num)
      (reverse (append (-dec->c
                        (exact-floor (-
                           (* (* -1 num) (fracmag (* -1 num)))
                           (* (floor (* -1 num)) (fracmag (* -1 num)))))
                        10)
                     (cons "1d" (-dec->c (exact-floor (* -1 num)) 10))))
      (reverse (append (dec->c
                        (exact-floor (-
                           (* num (fracmag num))
                           (* (floor num) (fracmag num))))
                        10)
                     (cons "1d" (dec->c (exact-floor num) 10)))))
 )

;Passed a pile of cards, returns the coresponding decimal number
(define (cards->decimal cards)
  (define (c->dec cards)
    (define (c->dec-helper cards count)
      (if (null? cards) 0
          (+
           (* (string->number (pip (car cards))) count)
           (c->dec-helper (cdr cards) (* 10 count))))
      )
     (c->dec-helper cards 1)
   )
  (define (finddecp cards)
    (define (finddecp-helper cards count)
      (cond [(null? cards) (begin (print cards) (print error))]
            [(equal? (suit (car cards)) "d") count]
            [else (finddecp-helper (cdr cards) (+ 1 count))])
    )
    (finddecp-helper cards 0)
  )
  (define (sublist list start end)
    (cond [(> start 0) (sublist (cdr list) (- start 1) (- end 1))]
          [(> end 0) (cons (car list)
                           (sublist (cdr list) 0 (- end 1)))]
          [else '()])
    )
  (define (compose-c->dec cards)
    (define decp (finddecp cards))
    (real->double-flonum
     (+
       (c->dec (reverse (sublist cards 0 decp)))
       (/
        (c->dec (reverse (sublist cards (+ 1 decp) (length cards))))
        (expt 10 (- (length cards) decp 1)))
     ))
  )
  (if (equal? (suit (car cards)) "c")
      (* -1 (compose-c->dec cards))
      (compose-c->dec cards)
  )
)

;Passed a char, returns the coresponding pile of cards
(define (string->cards str)
  (integer->cards (char->integer str)))

;Passed a pile of cards, returns the coresponding char
(define (cards->string cards)
  (integer->char (cards->integer cards)))

;Passed a boolean, returns the coresponding pile of cards
(define (bool->cards b)
  (if b (cons "1d" '()) (cons "0d" '())))

;Passed a pile of cards, returns the coresponding boolean
(define (cards->bool cards)
  ;(display "cards->bool: ") (print cards) (newline)
  (not (or (equal? (car cards) "0s") (equal? (car cards) "0d") (equal? (pip (car cards)) "F") (equal? (pip (car cards)) "R"))))
;----------------------------------------------------------------------------------
;Executer---------------------------------------------------------------------------

;Passed a table[closure] and a name[s-list] of a deck, ie the pointer.
;Should only be called using rifL
(define (execute table name)
  ;(newline) (display "pointer: ") (print name) (newline)
  ;Gets the pile that the pointer is pointing to
  (let ((pile (table 'find name)))
    ;(table 'display) (newline)
    (define (executer table name)
      ;(display "pile: ") (print name) (newline) (table 'display) (newline)
      ;if the current pile is empty, end executing and return the stack
      (if (= (pile 'length) 0) (table 'stack)
          ;otherwise if the top card of the current pile is a face card, perform an operation
          (cond ((face-card? (pile 'top)) (evaluate (pile 'pop) pile table name))
                ;((face-card? (pile 'top)) (begin (table 'display) (evaluate (pile 'pop) pile table name)))
                ;otherwise move the top card of the current pile onto the stack and call execute again
                ((card? (pile 'top)) (begin ((table 'stack) 'push (pile 'pop)) (executer table name)))
          )
      )
    )
    (executer table name)
  )
)

;Could speed up by matching the value and then matching the suit
;Passed a face card 'card', the current pile, the table, and the name of the current pile.
;Executes code from the stack based on the given face card.
(define (evaluate card pile table name)
  (cond ((equal? "Js" card) (Jack-spade table))
        ((equal? "Jc" card) (Jack-club table name))
        ((equal? "Jh" card) (Jack-heart table name))
        ((equal? "Jd" card) (Jack-diamond table name))
        ((equal? "Qs" card) (Queen-spade table name))
        ((equal? "Qc" card) (Queen-club table name))
        ((equal? "Qh" card) (Queen-heart pile table name))
        ((equal? "Qd" card) (Queen-diamond pile table name))
        ((equal? "Ks" card) (King-spade pile table name))
        ((equal? "Kc" card) (King-club pile table name))
        ((equal? "Kh" card) (King-heart pile table name))
        ((equal? "Kd" card) (King-diamond pile table name))
        (else (display-all "error: tried to use " card " as a face card"))
        )
)

;[X], Js -> moves the pointer to deck [X]
(define (Jack-spade table)
  (let ((name (table 'get-stack)))
    ;(display "name: ") (print name) (newline)
    (if (name? name)
        (execute table name)
        (display-all "error: Jack of Spades tries to use" name " as an argument"))
   )
)

;[X], [Y], Jc -> puts the name of the deck that is to the right [X] times and up [Y] times onto the stack.
;If [X] or [Y] is negative, move in the opposite direction. If [X] or [Y] that are Jokers act as 0.
;Moving below an Ac deck throws an out of bounds error.

;Bugs:
;If a negative number down is returning a positive deck, its because double digit negative inputs arnt working
(define (Jack-club table name)
  (let ((vertical   (table 'get-stack))
        (horizontal (table 'get-stack))
        (num        (abs (cards->integer name))))
    ;(display-all "name: " (number->string num) "\n" "vertical: " (number->string (cards->integer vertical)))
    (define (suit-cycle suit count)
      (if (equal? count 0) suit
          (cond [(equal? suit "s") (suit-cycle "c" (- count 1))]
                [(equal? suit "c") (suit-cycle "h" (- count 1))]
                [(equal? suit "h") (suit-cycle "d" (- count 1))]
                [(equal? suit "d") (suit-cycle "s" (- count 1))]))
    )
    (define (compose-name suit cards)
      (if (equal? cards '()) '("F")
          (cons (string-append (pip (car cards)) suit)
                (compose-name suit (cdr cards))))
    )
    (cond  [(equal? vertical '()) (display "error: No arguments for Jack of Clubs")]
           [(equal? horizontal '())  (display "error: Missing second argument for Jack of Clubs")]
           [(> 1 (+ (cards->integer vertical) num)) (print "error: Out of bounds deck name")]
           (else
            (begin
              (begin
                (begin
                  (if (equal? (car horizontal) "R")
                      (set! horizontal 0)
                      (set! horizontal (cards->integer horizontal)))
                  (if (equal? (car vertical) "R")
                      (set! vertical 0)
                      (set! vertical (cards->integer vertical))))
                  (table 'insert-data (table'stack) (compose-name
                                                     (suit-cycle (suit (car name)) (modulo horizontal 4))
                                                     (integer->cards (+ num vertical))))
                )
              (execute table name)))
           )
    )
)

;Needs in depth testing
(define (Jack-heart table name)
  (let ((deck (table 'get-stack)))
    (define (Jh)
      (table 'insert-data (table 'stack)
                 (integer->cards (length (table 'find deck))))
    )
    (if (name? deck)
        (begin (Jh) (execute table name))   
        (begin (print deck) (print "error: Jack of Hearts")))
    )
)

;[X] Jd, inputs or outputs the stack based on the leading suit of [X]
;spades: output cards,  clubs: output data, hearts:input cards, diamonds:input data

;Bugs:
;Currently cards as inputs, ie hearts, does not work. It has strange behavior
;Currently double digit negative numberd inputs get outputed as positive integers (-13->13)
(define (Jack-diamond table name)
  (let ((port (table 'get-stack)))
    (define (Jd port table name)
      ;(display "Jd: ") (print port) (newline)
      ;(display "table: ") (print ((table 'stack) 'copy)) (newline)
      (cond ((equal? (suit (car port)) "s") (begin ((table 'stack) 'display) (execute table name)))
            ((equal? (suit (car port)) "c") (output ((table 'stack) 'copy) table name))
            ;The problem with hearts is that i use tokenize on the input string. My origional tokenize
            ;is looking for deck names, and as such cuts off the first card thinking its a name
            ;This does not explain all of the weirdness, but some
            ;Writing a custom tokenize just for this card will likely fix all the other issues.
            ((equal? (suit (car port)) "h") (begin (table 'insert-data (table 'stack) (reverse (tokenize (read-string "")))) (execute table name)))
            ((equal? (suit (car port)) "d") (insert-input (tokenize2 (read-line))))
            (else (begin (display "Jack of Diamonds: ") (print port))))
      )

    (define (insert-input list)
      ;(display "insert-input: ") (print list) (newline)
      (if (zero? (length list))
          (begin (newline) (execute table name))
          (begin
            (begin
              (table 'insert-data (table 'stack) (car list))
              (table 'insert-data (table 'stack) (cons "F" '())))
            (insert-input (cdr list))))
      )

    (define (transform2 s)
      ;(display "transform2: ") (print s) (newline)
      (cond [(null? s) '()]
            [(equal? s "#t") (bool->cards #t)]
            [(equal? s "#f") (bool->cards #f)]
            [(integer? (string->number s)) (integer->cards (string->number s))]
            [else (string->cards s)])
      )

    ;(define (read-string s)
      ;(display "read-string: ") (print s) (newline)
      ;(if (eof-object? (peek-char)) s (begin (set! s (string-append s (string (read-char)))) (read-string s)))
      ;)

    (define (tokenize2 s)
     ;(display "tokenize2: ") (print s) (newline)
      (token2 s 0 '()))

    (define (token2 s count t)
      ;(display "token2: ") (print s) (display " ") (print count) (display " ") (print t) (newline)
      (if (< count (string-length s))
          (let ((char (string-ref s count)))
            (cond ((or (eq? '#\space char) (eq? '#\newline char))
                   (if (= count 0)
                       (token-inc2 s count t)
                       (token-inc2 s count (j-append t (transform2 (string-head s count))))))
                  ((char? char) (token2 s (+ count 1) t))
                  (else (begin (print char) (print "Error: tokenize2")))
                  )
            )
          (if (< 0 (string-length s)) (j-append t (transform2 s)) t)
          )
      )

    (define (token-inc2 s count t)
     ;(display "token-inc2: ") (print s) (display " ") (print count) (display " ") (print t) (newline)
      (token2 (string-tail s (+ 1 count)) 0 t))

    (define (output list table name)
      ;(display "output: ") (print list) (newline)
      (define (outputer list out)
        ;(display "outputer: ") (print list) (display " ") (print out) (newline)
        (cond [(zero? (length list)) (if (null? out)
                                         (begin (newline) (execute table name))
                                         (begin (begin (display (cards->data out))
                                                       (newline))
                                                (execute table name)))]
              [(face-down? (car list)) (if (null? out) (outputer (cdr list) '())
                                           (begin (display (cards->data out))
                                              (outputer (cdr list) '())))]
              [(joker? (car list)) (if (null? out)
                                       (begin (display (cards->data out))
                                              (outputer (cdr list) '()))
                                       (begin
                                         (begin (display (cards->data out))
                                                     (print '()))
                                              (outputer (cdr list) '())))]
              [(face-card? (car list)) (outputer (cdr list) out)]
              [else (outputer (cdr list) (cons (car list) out))])
      )
      (outputer list '())
    )
    
    (if (null? port)
        (print "error: Jack of Diamonds")
        (Jd port table name))
    )
  )

(define (Queen-spade table name)
  (let ((first (table 'get-stack))
        (second (table 'get-stack)))
    (define (Qs)
      (cond [(joker? (car first)) (0? second)]
            [(joker? (car second)) (0? first)]
            [(> (cards->integer first) (cards->integer second)) (0? first)]
            [(< (cards->integer first) (cards->integer second)) (0? second)]
            [else (cons "R" '())])
      )
    (define (0? cards)
      (if (or (equal? (car cards) "0s") (equal? (car cards) "0d"))
          (cons "0c" (cdr cards))
          cards))
    (if (or (null? first) (null? second))
        (print "error: Queen of Spades")
        (table 'insert-data (table 'stack) (Qs)))
    (execute table name)
    )
  )

;Needs double check
;Need Joker as third conditional
(define (Queen-club table name)
  (let ((first (table 'get-stack))
        (second (table 'get-stack))
        (third (table 'get-stack)))
    (define (Qc)
      (if (joker? (car first))
          (set! first 0)
          (set! first (cards->integer first)))
      (if (joker? (car second))
          (set! second 0)
          (set! second (cards->integer second)))
      (cond [(equal? (suit (car third)) "s") (integer->cards (+ first second))]
            [(equal? (suit (car third)) "c") (integer->cards (- first second))]
            [(equal? (suit (car third)) "d") (integer->cards (* first second))]
            [(equal? (suit (car third)) "h") (integer->cards (/ first second))]
       )
     )
    (if (or (null? first) (null? second))
        (print "error: Queen of Clubs")
        (begin (table 'insert-data (table 'stack) (Qc))
               (execute table name))
    )
  )
)

(define (Queen-heart pile table name)
  (let ((conditional (table 'get-stack))
        (fail (table 'get-stack))
        (success (table 'get-stack)))
    ;(display "f, s, c: ") (print fail) (print success) (print conditional) (newline)
    (if (or (null? fail) (null? success) (null? conditional)) (print "error: Queen of Hearts")
        ;(if (bool (car conditional)) (insert-data pile success) (insert-data pile fail)))
        (if (cards->bool conditional) (table 'insert-data (table 'stack) success) (table 'insert-data (table 'stack) fail)))
  )
  (execute table name)
)

(define (Queen-diamond pile table name)
  (let ((number (table 'get-stack))
        (flip (table 'get-stack)))
    (define (Qd)
      (if (joker? (car number))
          (set! number (list "0s" '()))
          (set! number (cards->integer number)))
      (if (joker? (car flip))
          (set! flip (list "0s" '()))
          (set! flip (cards->integer second)))
      (cond [(equal? (pip (car number)) "d")
             (table 'insert-data (table 'stack)
                    (suit-transform (fliper number flip) "d"))]
            [(equal? (pip (car number)) "h")
             (table 'insert-data (table 'stack)
                    (suit-transform (fliper number flip) "h"))]
            [else (table 'insert-data (table 'stack)
                         (fliper number flip))]
            ))
    (define (fliper number flip)
      (integer->cards (if (> number flip)
                          (- flip (- number flip))
                          (+ flip (- flip number)))))
    (define (suit-transform cards suit)
      (if (null? cards) '()
          (cons (string-append (pip (car cards)) suit)
                (suit-transform (cdr cards) suit)))
      )
    (if (or (null? number) (null? flip))
        (print "error: Queen of Diamonds")
        (Qd))
    (execute table name)
    )
  )

(define (King-spade pile table name)
  (let ((onto (table 'get-stack))
        (from (table 'get-stack)))
    ;(display "onto, from: ") (print onto) (print from) (newline)
    ;(display "pile: ") (pile 'display) (newline)
    (define (Ks pile table name)
      (if (joker? (car onto)) (set! onto (table 'stack)) (set! onto (table 'find onto)))
      (if (joker? (car from)) (set! from (reverse ((table 'stack) 'copy))) (set! from (reverse ((table 'find from) 'copy))))
      ;(display "Onto, From: ") (print onto) (display ", ") (print from) (newline)
      (Ks2 table name from))
    (define (Ks2 table name from)
      (if (null? from) (execute table name) (begin (onto 'push (car from)) (Ks2 table name (cdr from))))
    )
    (if (or (null? onto) (null? from))
        (print "error: King of Spades")
        (Ks pile table name))
  )
)

(define (King-club pile table name)
  (let ((onto (table 'get-stack))
        (count (table 'get-stack))
        (from (table 'get-stack)))
    (define (Kc)
      (if (joker? (car from)) (set! from (table 'stack)) (set! from (table 'find from)))
      (if (joker? (car onto)) (set! onto (table 'stack)) (set! onto (table 'find onto)))
      (if (joker? (car count))
          (infiniteloop)
          (begin (set! count (cards->integer count)) (loop count))
          ))
    (define (infiniteloop)
      (if (zero? (from 'length))
          (execute table name)
          (begin (begin (table 'insert-data onto (table 'get-data from))
                        (table 'insert-data onto (cons "F" '())))
                 (infiniteloop))
          )
      )
    (define (loop count)
      (if (zero? count)
          (execute table name)
          (if (zero? (from 'length))
              (begin (begin (table 'insert-data onto (cons "R" '()))
                        (table 'insert-data onto (cons "F" '())))
                 (loop (- count 1)))
              (begin (begin (table 'insert-data onto (table 'get-data from))
                        (table 'insert-data onto (cons "F" '())))
                 (loop (- count 1)))
              )
          )
      )
    (if (or (null? onto) (null? count) (null? from))
        (print "error: King of Clubs")
        (Kc))
    )
  )

(define (King-heart pile table name)
  (let ((onto (table 'get-stack))
        (count (table 'get-stack))
        (from (table 'get-stack)))
    (define (Kh)
      (if (joker? (car from)) (set! from (table 'stack)) (set! from (table 'find from)))
      (if (joker? (car onto)) (set! onto (table 'stack)) (set! onto (table 'find onto)))
      (if (joker? (car count))
          (infiniteloop)
          (begin (set! count (cards->integer count)) (loop count))
          ))
    (define (infiniteloop)
      (if (zero? (from 'length))
          (execute table name)
          (begin (onto 'push (from 'pop)) (infiniteloop))
          )
      )
    (define (loop count)
      (if (zero? count)
          (execute table name)
          (if (null? (from 'top))
              (print "error: King of Spades")
              (begin (onto 'push (from 'pop)) (loop (- count 1)))
              )
          )
      )
    (if (or (null? onto) (null? count) (null? from))
        (print "error: King of Spades")
        (Kh))
    )
  )

(define (King-diamond pile table name)
  (let ((onto (table 'get-stack))
        (count (table 'get-stack))
        (from (table 'get-stack)))
    ;(display "onto, count, from: ") (print onto) (display " ")
    ;(print count) (display " ") (print from) (newline)
    (define (Kd pile table name)
      (if (joker? (car onto)) (set! onto (table 'stack)) (set! onto (table 'find onto)))
      (if (joker? (car from)) (set! from (table 'stack)) (set! from (table 'find from)))
      (if (joker? (car count))
          (begin (set! from (reverse (from 'copy))) (infiniteloop from))
          (begin (set! count (cards->integer count)) (insert (loop count)))
          ))
    (define (infiniteloop from)
      (if (null? from) (execute table name) (begin (onto 'push (car from)) (infiniteloop (cdr from))))
    )
    (define (loop count)
      (if (> count 0)
          (if (zero? (from 'length)) (cons (cons "R" '()) (loop (- count 1)))
              (cons (table 'get-data from) (loop (- count 1))))
          '())        
      )
    (define (insert copy)
      (if (null? copy)
          (execute table name)
          (begin (begin (begin (table 'insert-data onto (car copy))
                                (table 'insert-data from (car copy)))
                        (begin (table 'insert-data onto (cons "F" '()))
                                (table 'insert-data from (cons "F" '()))))
                 (insert (cdr copy)))
      ))
    (if (or (null? onto) (null? from))
        (print "error: King of Spades")
        (Kd pile table name))
    )
  )

;------------------------------------------------------------------------------------------------
;Riffle---------------------------------------------------------------------------------
(define (rifL code)
  (execute (parse (make-table) (tokenize code)) (cons "1s" '())))
;--------------------------------------------------------------------------------
;Testing-------------------------------------------------------------------------

;test
(define (test s)
  (display "HUMAN:") (newline)
  (display s)
  (newline) (newline)
  (display "STRING:") (newline)
  (print s)
  (newline) (newline)
  (display "SCANNER") (newline)
  (begin (set! s (tokenize s)) (print s))
  (newline) (newline)
  (display "PARSER") (newline)
  (begin (set! s (parse (make-table) s)) (s 'print))
  (newline) (newline)
  (display "PRETTY PARSER") (newline)
  (s 'display)
  (newline) (newline)
  (display "EXECUTE") (newline)
  (execute s (cons "1s" '())))

;run
(define (run s)
  (display s)
  (newline) (newline)
  (rifL s))

(define (fib x)
  (if (< x 2)
      x
      (+ (fib (- x 1)) (fib (- x 2)))
  ))

;fibonacci
(define fibonacci "As: 2d, Jd, R, As, F, 2s, Kc As, F, As, Ks 2s, F, As, R Kd F, R, Qs, R, Qs, F, As, F, 4c, Qh, Jh 2s, F, As, R, Kd F, 2s, Qs, F, 2s, Qs, F, Ad, F, Ac, Qh, Jh As, F, As, Ks
Ac: Ac, F, Ac, Ks 3c, F, 2c, Ks 2s, F, As, F, 2c, Kc As, Jh Ac, F, Ac, Ks
2c: F, 2c, Jd
3c: F, Qc,
4c: 5c, F, 2c, Ks 2c, Jh
5c: 0s, F
Ad: Ad, F, Ad, Ks 2s, F, As, F, R, Kc F, 1c, Qc F, R, R, Ks R, As, F, 2s, Kc F, 1c, Qc R, As, F, 2s, Kc As, Jh Ad, F, Ad, Ks")

;output test
(define input-test "As:\tAd, Jd, Ad, Jd, As, Jd, Ac, Jd")

;Jc test
(define Jc-test "As:\tAd, Jd, Ad, Jd, Jc, As, Jd, Ac, Jd\n2c:\tAd, Jd, Ad, Jd, Jc, As, Jd, Ac, Jd")

;Jc test for when moving pointer works
(define Jc+Js-test "As:\tAd, Jd, Ad, Jd, Jc, As, Jd, Ac, Jd, Js\n2c:\tAd, Jd, Ad, Jd, Jc, As, Jd, Ac, Jd")

;truth-machine
(define truth-machine "As:\t2d, Jd, Jh > input As or 10s, go to that deck\n\tAs, F > push 1 to stack\n\tAs, F, As, Ks > copy As onto As\n\t2c, Jd > output stack\n\tAs, F, As, Ks > copy As onto As\n10s:\t10s, F, 2c, Jd > output 0")