#lang br
(require "lexer.rkt" brag/support rackunit)

(define (lex str)
  (apply-port-proc basic-lexer str))

(check-equal? (lex "") empty)
(check-equal?
 (lex " ")
 (list (srcloc-token (token 'WHITESPACE " ")
                     (srcloc 'string 1 0 1 1))))
#;(check-equal?
 (lex ">rem ignored\n")
 (list (srcloc-token (token 'REM ">rem ignored")
                     (srcloc 'string 1 0 1 12))
       (srcloc-token (token 'NEWLINE "\n")
                     (srcloc 'string 1 12 13 1))))
#;(check-equal?
 (lex ">rem ignored<")
 (list (srcloc-token (token 'COMMENT ">rem ignored<")
                     (srcloc 'string 1 0 1 13))))
(check-equal?
 (lex "As\n")
 (list (srcloc-token (token 'PIP-CARD "As")
                     (srcloc 'string 1 0 1 2))
       (srcloc-token (token 'NEWLINE "\n")
                     (srcloc 'string 1 2 3 1))))
(check-equal?
 (lex "As")
 (list (srcloc-token (token 'PIP-CARD "As")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "2c")
 (list (srcloc-token (token 'PIP-CARD "2c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "3h")
 (list (srcloc-token (token 'PIP-CARD "3h")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "2d")
 (list (srcloc-token (token 'PIP-CARD "2d")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "5s")
 (list (srcloc-token (token 'PIP-CARD "5s")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "6c")
 (list (srcloc-token (token 'PIP-CARD "6c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "7c")
 (list (srcloc-token (token 'PIP-CARD "7c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "8c")
 (list (srcloc-token (token 'PIP-CARD "8c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "9c")
 (list (srcloc-token (token 'PIP-CARD "9c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "10c")
 (list (srcloc-token (token 'PIP-CARD "10c")
                     (srcloc 'string 1 0 1 3))))
(check-equal?
 (lex "0c")
 (list (srcloc-token (token 'PIP-CARD "0c")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "Js")
 (list (srcloc-token (token 'ROYAL-CARD "Js")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "Qc")
 (list (srcloc-token (token 'ROYAL-CARD "Qc")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "Kh")
 (list (srcloc-token (token 'ROYAL-CARD "Kh")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "R")
 (list (srcloc-token (token 'JOKER "R")
                     (srcloc 'string 1 0 1 1))))
(check-equal?
 (lex "FR")
 (list (srcloc-token (token 'FACE-DOWN "FR")
                     (srcloc 'string 1 0 1 2))))
(check-equal?
 (lex "FAs")
 (list (srcloc-token (token 'FACE-DOWN "FAs")
                     (srcloc 'string 1 0 1 3))))
(check-equal?
 (lex "F10s")
 (list (srcloc-token (token 'FACE-DOWN "F10s")
                     (srcloc 'string 1 0 1 4))))