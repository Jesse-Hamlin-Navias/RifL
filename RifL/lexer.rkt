#lang br
(require brag/support)

(define basic-lexer
  (lexer-srcloc
   ["\n" (token 'NEWLINE lexeme)]
   ["," (token lexeme lexeme)]
   [whitespace (token 'WHITESPACE lexeme)]
   [(from/stop-before ">" (:or "\n" "<")) (token lexeme #:skip? #t)]
   ["<" (token lexeme #:skip? #t)]
   [":" (token 'DIVIDER lexeme)]
   [(:: "F"
        (:or "R"
             (:: (:or "A" "2" "3" "4" "5" "6" "7"
                      "8" "9" "10" "J" "Q" "K")
                 (:or "s" "c" "h" "d"))))
    (token 'FACE-DOWN lexeme)]
   [(:: "F1" (:or "s" "c" "h" "d"))
    (token 'FACE-DOWN (string-append "FA" (substring lexeme 2 3)))]
   [(:: "F0" (:or "s" "c" "h" "d"))
    (token 'FACE-DOWN (string-append "F10" (substring lexeme 2 3)))]
   ["F" (token 'FACE-DOWN "FR")]
   [(:: (:or "A" "2" "3" "4" "5" "6"
             "7" "8" "9" "10") "s")
    (token 'S-PIP-CARD lexeme)]
   [(:: (:or "A" "2" "3" "4" "5" "6"
             "7" "8" "9" "10") "c")
    (token 'C-PIP-CARD lexeme)]
   [(:: (:or "A" "2" "3" "4" "5" "6"
             "7" "8" "9" "10") "h")
    (token 'H-PIP-CARD lexeme)]
   [(:: (:or "A" "2" "3" "4" "5" "6"
             "7" "8" "9" "10") "d")
    (token 'D-PIP-CARD lexeme)]
   ["1s" (token 'S-PIP-CARD "As")]
   ["1c" (token 'C-PIP-CARD "Ac")]
   ["1h" (token 'H-PIP-CARD "Ah")]
   ["1d" (token 'D-PIP-CARD "Ad")]
   ["0s" (token 'S-PIP-CARD "10s")]
   ["0c" (token 'C-PIP-CARD "10c")]
   ["0h" (token 'H-PIP-CARD "10h")]
   ["0d" (token 'D-PIP-CARD "10d")]
   [(:: (:or "J" "Q" "K") (:or "s" "c" "h" "d")) (token 'ROYAL-CARD lexeme)]
   ["R" (token 'JOKER lexeme)]))
    

(provide basic-lexer)