#lang br
(require brag/support)

(define RifL-lexer
  (lexer-srcloc
   ["\n" (token 'NEWLINE lexeme)]
   ["," (token 'COMMA lexeme)]
   [whitespace (token lexeme #:skip? #t)]
   [(from/stop-before ">" (:or "\n" "<")) (token 'COMMENT lexeme #:skip? #t)]
   ["<" (token 'COMMENT lexeme #:skip? #t)]
   [":" (token 'DIVIDER lexeme)]
   [(:: "F"
        (:or "R"
             (:: (:or "A" "1" "2" "3" "4" "5" "6" "7"
                      "8" "9" "10" "0" "J" "Q" "K")
                 (:or "s" "c" "h" "d"))))
    (token 'FACE-DOWN lexeme)]
   ["F" (token 'FACE-DOWN "FR")]
   [(:: (:or "A" "1" "2" "3" "4" "5" "6"
             "7" "8" "9" "10" "0") "s")
    (token 'S-PIP-CARD lexeme)]
   [(:: (:or "A" "1" "2" "3" "4" "5" "6"
             "7" "8" "9" "10" "0") "c")
    (token 'C-PIP-CARD lexeme)]
   [(:: (:or "A" "1" "2" "3" "4" "5" "6"
             "7" "8" "9" "10" "0") "h")
    (token 'H-PIP-CARD lexeme)]
   [(:: (:or "A" "1" "2" "3" "4" "5" "6"
             "7" "8" "9" "10" "0") "d")
    (token 'D-PIP-CARD lexeme)]
   [(:: (:or "J" "Q" "K") (:or "s" "c" "h" "d")) (token 'ROYAL-CARD lexeme)]
   ["R" (token 'JOKER lexeme)]))
    
(provide RifL-lexer)