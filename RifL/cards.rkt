#lang br
(provide (struct-out card)
         (struct-out face_down)
         joker?
         eq_suit?
         eq_pip?
         number-card?
         parse_name?
         name?
         deck?)

(struct card (pip ;int: the number value of the card. #f if Joker
              suit ;symbol: the suit of the card. r if Joker (so Joker? should see if suit is R)
              bool ;boolean: the true or false value of the card
              royal? ;boolean: if the suit is royal. #f is Joker
              func ;#f if not royal. If royal, is the definition of that royal. <- is there some effecient way to nest execute in royal?
              ))
;One things I could do is have all non-royal cards have the executer in their func
;value, and all the royal functions in func call the executer, like I have it rn.
;This way, the executer doesnt have to test for royal, instead just treat all face up card the same?
;This is close but not quite it because it doesnt handle how royals dont go on the stack.

(struct face_down (card))

(define (flip c)
  (if (face_down? c)
      (face_down-card c)
      (face_down c)))

(define (joker? c) (not (card-pip c)))

(define (eq_suit? c1 c2) (eq? (card-suit c1) (card-suit c2)))

(define (eq_pip? c1 c2)  (eq? (card-pip  c1) (card-pip  c2)))

;Takes a string 'card' and returns 'true' if its a number card
(define (number-card? c) (not (or (joker? c) (card-royal? c))))

;Takes a list of structs and returns #t if its a valid deck name. Slower than name?
;Bug: Currently both name? functions take a list of just 10s of repeating size as a valid name.
;     this is only a bug if there is no 0 decks, which is still undecided, and if I care if there are leading
;     0s on a number.
(define (parse_name? t)
  (define (name?er2 t)
    (and (andmap card? t) (andmap number-card? t) (for/and ([i (cdr t)]) (eq? (card-suit i) (card-suit (car t)))))
    )
  (if (> (length t) 0) (name?er2 t) #f))

;Takes a list of #<cards> and returns #t if its a valid deck name. Faster than parse_name?
(define (name? t)
  (define (name?er2 t)
    (and (andmap number-card? t) (for/and ([i (cdr t)]) (eq? (card-suit i) (card-suit (car t)))))
    )
  (if (> (length t) 0) (name?er2 t) #f))

;Takes a list of cards and returns 'true' if its a valid deck
(define (deck? t)
  (or (zero? (length t)) (and (or (face_down? (car t)) (card? (car t))) (deck? (cdr t)))))

(define-for-syntax (create_card_data id)
  (if (= id 0) (cons "R" (list (lambda x #f) (lambda x 'r) #f #f (void)))
      (let* ((pip (modulo id 13))
              (pip_string (cond [(= pip 1) "A"]
                                [(= pip 11) "J"]
                                [(= pip 12) "Q"]
                                [(= pip 0) "K"]
                                [else (number->string pip)] ))
              (suit (let ((suit_1 (/ id 13)))
                      (cond [(<= suit_1 1) "s"]
                            [(<= suit_1 2) "c"]
                            [(<= suit_1 3) "h"]
                            [else "d"])))
              )
         (cons (string-append pip_string suit)
               (cond [(zero? pip) (list (lambda x 'K)  (lambda x (string->symbol suit)) #t #t (lambda x (print (string-append pip_string suit))))]
                     [(= pip 10)  (if (equal? suit "d")
                                  (list (lambda x 0)   (lambda x (string->symbol suit)) #f #f (void))
                                  (list (lambda x 0)   (lambda x (string->symbol suit)) #t #f (void)))]
                     [(= pip 11)  (list (lambda x 'J)  (lambda x (string->symbol suit)) #t #t (lambda x (print (string-append pip_string suit))))]
                     [(= pip 12)  (list (lambda x 'Q)  (lambda x (string->symbol suit)) #t #t (lambda x (print (string-append pip_string suit))))]
                     [else        (list (lambda x pip) (lambda x (string->symbol suit)) #t #f (void))]))
         )
      )
  )

;Creates all card structs (up and face_down) with the initial call of (make_cards 52)
;current problems: Tries to replace 's with something, will only take "s" (same for all suits and royal symbols)
(define-syntax (make_cards stx)
  (syntax-case stx ()
    [(_ id)
     (if (> (syntax->datum #'id) -1)
         (with-syntax ([(name_1 pip suit bool royal ex) (create_card_data (syntax->datum #'id))])
           (with-syntax ([name_2 (datum->syntax #'id (syntax->datum #'name_1))]
                         [next_num (datum->syntax #'id (- (syntax->datum #'id) 1))])
             #'(begin
                 (display "\"")
                 (display name_2) (display "\" ")
                 (display "(card ") (display " ")
                 (display (pip)) (display " '")
                 (display (suit)) (display " ")
                 (display bool) (display " ")
                 (display royal) (display " ")
                 (display "pip-func") (display ")")
                 (newline)
                 (make_cards next_num))))
         (if (> (syntax->datum #'id) -54)
             (with-syntax ([(name_1 pip suit bool royal ex) (create_card_data (+ (syntax->datum #'id) 53))])
               (with-syntax ([F_name (datum->syntax #'id (string-append "F" (syntax->datum #'name_1)))]
                             [next_num (datum->syntax #'id (- (syntax->datum #'id) 1))])
                 #'(begin
                     ;(print (symbol->string (hash-set! card-hash F_name (face_down (card (pip) (suit) bool royal ex)))))
                     (display "\"")
                     (display F_name) (display "\" ")
                     (display "(face_down (card ")
                     (display (pip)) (display " '")
                     (display (suit)) (display " ")
                     (display bool) (display " ")
                     (display royal) (display " ")
                     (display "pip-func") (display "))")
                     (newline)
                     (make_cards next_num))))
             #'(void)))
     ])
  )

(define pip-func (lambda (cur-card stack pointer grid)
                   (display (card-pip cur-card)) (display (card-suit cur-card)) (display " ")
                   (stack 'push cur-card)))
;(make_cards 52)
(define card-hash (hash
                   "Kd" (card  'K 'd #t #t pip-func)
                   "Qd" (card  'Q 'd #t #t pip-func)
                   "Jd" (card  'J 'd #t #t pip-func)
                   "10d" (card  0 'd #f #f pip-func)
                   "9d" (card  9 'd #t #f pip-func)
                   "8d" (card  8 'd #t #f pip-func)
                   "7d" (card  7 'd #t #f pip-func)
                   "6d" (card  6 'd #t #f pip-func)
                   "5d" (card  5 'd #t #f pip-func)
                   "4d" (card  4 'd #t #f pip-func)
                   "3d" (card  3 'd #t #f pip-func)
                   "2d" (card  2 'd #t #f pip-func)
                   "Ad" (card  1 'd #t #f pip-func)
                   "Kh" (card  'K 'h #t #t pip-func)
                   "Qh" (card  'Q 'h #t #t pip-func)
                   "Jh" (card  'J 'h #t #t pip-func)
                   "10h" (card  0 'h #t #f pip-func)
                   "9h" (card  9 'h #t #f pip-func)
                   "8h" (card  8 'h #t #f pip-func)
                   "7h" (card  7 'h #t #f pip-func)
                   "6h" (card  6 'h #t #f pip-func)
                   "5h" (card  5 'h #t #f pip-func)
                   "4h" (card  4 'h #t #f pip-func)
                   "3h" (card  3 'h #t #f pip-func)
                   "2h" (card  2 'h #t #f pip-func)
                   "Ah" (card  1 'h #t #f pip-func)
                   "Kc" (card  'K 'c #t #t pip-func)
                   "Qc" (card  'Q 'c #t #t pip-func)
                   "Jc" (card  'J 'c #t #t pip-func)
                   "10c" (card  0 'c #t #f pip-func)
                   "9c" (card  9 'c #t #f pip-func)
                   "8c" (card  8 'c #t #f pip-func)
                   "7c" (card  7 'c #t #f pip-func)
                   "6c" (card  6 'c #t #f pip-func)
                   "5c" (card  5 'c #t #f pip-func)
                   "4c" (card  4 'c #t #f pip-func)
                   "3c" (card  3 'c #t #f pip-func)
                   "2c" (card  2 'c #t #f pip-func)
                   "Ac" (card  1 'c #t #f pip-func)
                   "Ks" (card  'K 's #t #t pip-func)
                   "Qs" (card  'Q 's #t #t pip-func)
                   "Js" (card  'J 's #t #t pip-func)
                   "10s" (card  0 's #t #f pip-func)
                   "9s" (card  9 's #t #f pip-func)
                   "8s" (card  8 's #t #f pip-func)
                   "7s" (card  7 's #t #f pip-func)
                   "6s" (card  6 's #t #f pip-func)
                   "5s" (card  5 's #t #f pip-func)
                   "4s" (card  4 's #t #f pip-func)
                   "3s" (card  3 's #t #f pip-func)
                   "2s" (card  2 's #t #f pip-func)
                   "As" (card  1 's #t #f pip-func)
                   "R" (card  #f 'r #f #f pip-func)
                   "FKd" (face_down (card 'K 'd #t #t pip-func))
                   "FQd" (face_down (card 'Q 'd #t #t pip-func))
                   "FJd" (face_down (card 'J 'd #t #t pip-func))
                   "F10d" (face_down (card 0 'd #f #f pip-func))
                   "F9d" (face_down (card 9 'd #t #f pip-func))
                   "F8d" (face_down (card 8 'd #t #f pip-func))
                   "F7d" (face_down (card 7 'd #t #f pip-func))
                   "F6d" (face_down (card 6 'd #t #f pip-func))
                   "F5d" (face_down (card 5 'd #t #f pip-func))
                   "F4d" (face_down (card 4 'd #t #f pip-func))
                   "F3d" (face_down (card 3 'd #t #f pip-func))
                   "F2d" (face_down (card 2 'd #t #f pip-func))
                   "FAd" (face_down (card 1 'd #t #f pip-func))
                   "FKh" (face_down (card 'K 'h #t #t pip-func))
                   "FQh" (face_down (card 'Q 'h #t #t pip-func))
                   "FJh" (face_down (card 'J 'h #t #t pip-func))
                   "F10h" (face_down (card 0 'h #t #f pip-func))
                   "F9h" (face_down (card 9 'h #t #f pip-func))
                   "F8h" (face_down (card 8 'h #t #f pip-func))
                   "F7h" (face_down (card 7 'h #t #f pip-func))
                   "F6h" (face_down (card 6 'h #t #f pip-func))
                   "F5h" (face_down (card 5 'h #t #f pip-func))
                   "F4h" (face_down (card 4 'h #t #f pip-func))
                   "F3h" (face_down (card 3 'h #t #f pip-func))
                   "F2h" (face_down (card 2 'h #t #f pip-func))
                   "FAh" (face_down (card 1 'h #t #f pip-func))
                   "FKc" (face_down (card 'K 'c #t #t pip-func))
                   "FQc" (face_down (card 'Q 'c #t #t pip-func))
                   "FJc" (face_down (card 'J 'c #t #t pip-func))
                   "F10c" (face_down (card 0 'c #t #f pip-func))
                   "F9c" (face_down (card 9 'c #t #f pip-func))
                   "F8c" (face_down (card 8 'c #t #f pip-func))
                   "F7c" (face_down (card 7 'c #t #f pip-func))
                   "F6c" (face_down (card 6 'c #t #f pip-func))
                   "F5c" (face_down (card 5 'c #t #f pip-func))
                   "F4c" (face_down (card 4 'c #t #f pip-func))
                   "F3c" (face_down (card 3 'c #t #f pip-func))
                   "F2c" (face_down (card 2 'c #t #f pip-func))
                   "FAc" (face_down (card 1 'c #t #f pip-func))
                   "FKs" (face_down (card 'K 's #t #t pip-func))
                   "FQs" (face_down (card 'Q 's #t #t pip-func))
                   "FJs" (face_down (card 'J 's #t #t pip-func))
                   "F10s" (face_down (card 0 's #t #f pip-func))
                   "F9s" (face_down (card 9 's #t #f pip-func))
                   "F8s" (face_down (card 8 's #t #f pip-func))
                   "F7s" (face_down (card 7 's #t #f pip-func))
                   "F6s" (face_down (card 6 's #t #f pip-func))
                   "F5s" (face_down (card 5 's #t #f pip-func))
                   "F4s" (face_down (card 4 's #t #f pip-func))
                   "F3s" (face_down (card 3 's #t #f pip-func))
                   "F2s" (face_down (card 2 's #t #f pip-func))
                   "FAs" (face_down (card 1 's #t #f pip-func))
                   "FR" (face_down (card #f 'r #f #f pip-func))
                   ))
(provide card-hash)