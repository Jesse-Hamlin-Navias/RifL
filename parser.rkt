#lang br
(require RifL/tokenizer brag/support syntax/readerr)

(define (next lex)
  (let ([token (lex)])
    (if (or (eof-object? token) (not (token-struct-skip? (srcloc-token-token token))))
        token
        (next lex))))

(define (lex-wrap lex)
  (let ([holder '()])
    (lambda (cmd)
      (match cmd
        ['peek (if (null? holder)
                   (begin (set! holder (next lex)) holder)
                    holder)]
        ['pop (if (null? holder)
                  (next lex)
                  (let ([top holder]) (set! holder '()) top))]
))))

;returns (RifL-program (debug (deck ...)))
;debug: (setting ...)
;deck: (name stack)
(define (parse path port lexer)
  (define lex (lex-wrap lexer))
  (define cur-token '())
  (define search '())

  (define (RifL-program)
    #`(RifL-program #,(debug) #,@(begin (set-up) (decks)))
    )

  (define (debug)
    ;(display "debug") (newline)
    (define (debuger)
      (let ([top-tok (lex 'peek)])
        (if (eof-object? top-tok) '()
            (match (type top-tok)
              ['NEWLINE  (begin (lex 'pop) (debuger))]
              [(? flag?) (cons (value (lex 'pop)) (debuger))]
              [else '()])
            )))

    ;check out syntax-parse as alternative
    (let ([flags (debuger)])
      ;(display "flags: ") (print flags) (newline)
      (match flags
        [(list a ...) #`(debug #,@a)]
        [else (complain path cur-token (format error-string (value cur-token) (type cur-token) path))]))
    )
  
  (define (decks)
    ;(display "decks") (newline)
    (if (eof-object? (lex 'peek)) '()
        (cons (deck) (decks)))
    )

  (define (deck)
    ;(display "deck") (newline)
    #`(convert-to-deck
       (convert-to-name #,@(name-check (search-return)))
       (convert-to-stack #,@(append (mand-line) (stack)))))

  (define (name-check list)
    (define (name-checker list suit)
      (cond [(null? list) '()]
            [(equal? (tail (string->list (car list))) suit)
             (cons (car list) (name-checker (cdr list) suit))]
            [else (complain path cur-token (format error-string (value cur-token) (type cur-token) path))]
            ))
    
    (if (and (not (equal? "R" (car list))) (not (equal? "FR" (car list))))
        (cons (car list) (name-checker (cdr list) (tail (string->list (car list)))))
        (complain path cur-token (format error-string (value cur-token) (type cur-token) path)))
    )

  (define (tail list)
    (car (reverse list)))
  
  (define (stack)
    ;(display "stack") (newline)
    (append (line) (if (or (eof-object? cur-token) (not (null? search))) '() (stack)))
    )

  (define (mand-line)
    ;(display "mand-line") (newline)
    (set! cur-token (lex 'pop))
    (if (eof-object? cur-token) (search-return)
        (match (type cur-token)
          [(? entry?)  (begin (search-append! cur-token) (comma) (line))]
          ['NEWLINE  (search-return)]
          [else (complain path cur-token (format error-string (value cur-token) (type cur-token) path))]))
    )

  (define (line)
    ;(display "line") (newline)
    (set! cur-token (lex 'pop))
    (if (eof-object? cur-token) (search-return)
        (match (type cur-token)
          [(? entry?) (begin (search-append! cur-token) (comma) (line))]
          ['NEWLINE (search-return)]
          ['DIVIDER '()]
          [else (complain path cur-token (format error-string (value cur-token) (type cur-token) path))]))
    )

  (define (set-up)
    ;(display "set-up") (newline)
    (define (name)
      ;(display "name") (newline)
      (set! cur-token (lex 'pop))
      (if (eof-object? cur-token) (complain path cur-token (format error-string (value cur-token) (type cur-token) path))
          (match (type cur-token)
            [(? entry?) (begin (search-append! cur-token) (comma) (name))]
            ['DIVIDER (void)]
            [else (complain path cur-token (format error-string (value cur-token) (type cur-token) path))])))
    
    (if (eof-object? (lex 'peek)) '() (name))
   )

  (define (search-append! tok)
    (set! search (append search (list (value tok)))))
  
  (define (search-return)
    (let ([a search]) (set! search '()) a))

  (define (comma)
    ;(display "comma") (newline)
    (if (and (not (eof-object? (lex 'peek))) (eq? 'COMMA (type (lex 'peek)))) (lex 'pop) (void)))
  
  (define (entry? tok)
    ;(display "entry?") (newline)
    (match tok
      ['S-PIP-CARD #t]
      ['C-PIP-CARD #t]
      ['H-PIP-CARD #t]
      ['D-PIP-CARD #t]
      ['ROYAL-CARD #t]
      ['JOKER      #t]
      ['FACE-DOWN  #t]
      [else #f])
    )

  (define (flag? tok)
    (match tok
      ['STEP #t]
      ['RSTEP #t]
      ['END #t]
      [else #f]))

  (RifL-program)
  )
(provide parse)
;---------------------------------------------------------------

;srcloc: (source line column position span)

(define error-string "Encountered parsing error near \"~a\" (token ~a) while parsing ~a")

(define (complain path token/port msg)
  (if (srcloc-token? token/port)
      (raise-read-error msg path (srcloc-line (srcloc-token-srcloc token/port))
                        (srcloc-column (srcloc-token-srcloc token/port))
                        (srcloc-position (srcloc-token-srcloc token/port))
                        (srcloc-span (srcloc-token-srcloc token/port)))
      (void))
  (define-values (line col pos) (port-next-location token/port))
  (raise-read-error msg path line col pos 1)
  )

(define (value token) (token-struct-val (srcloc-token-token token)))

(define (type token)  (token-struct-type (srcloc-token-token token)))

(define (parse-to-datum lex-list)
  (define (fake-lex lex-list)
    (let ([lex-list2 (append lex-list (list eof))])
      (lambda () (let ([tok (car lex-list2)])
                   (if (eof-object? (car lex-list2)) eof
                       (begin
                         (set! lex-list2 (cdr lex-list2))
                         tok)
                  ))
      )
    ))
  (syntax->datum (parse "" "" (fake-lex lex-list)))
  )
(provide parse-to-datum)