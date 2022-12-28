#lang br
(require RifL/parser RifL/tokenizer brag/support rackunit)

(define str #<<HERE
As 2s: 2d, Jd, R As, F10s F, 2s, Kc As, F, As, Ks 2s, F, As, R Kd F, R, Qs, R, Qs, F, As, F, 4c, Qh, Jh 2s, F, As, R, Kd F, 2s, Qs, F, 2s, Qs, F, Ad, F, Ac, Qh, Jh As, F, As, Ks
Ac 3c: Ac, F, Ac, Ks 3c, F, 2c,
       Ks 2s, F, As, F, 2c
       Kc As, Jh Ac, F, Ac, Ks
2c: F, 2c, Jd
3c: F, Qc,
4c: 5c, F, 2c, Ks 2c, Jh
5c: 0s, F
Ad: Ad, F, Ad, Ks 2s, F, As, F, R, Kc F, Ac, Qc F, R, R, Ks R, As, F, 2s, Kc F, Ac, Qc R, As, F, 2s, Kc As, Jh Ad, F, Ad, Ks
HERE
)

(parse-to-datum (apply-tokenizer make-tokenizer str))

(define (parse-test str)
  (parse-to-datum (apply-tokenizer make-tokenizer str)))

(check-equal? (parse-test "") '(RifL-program))
(check-equal? (parse-test " ") '(RifL-program))
(check-equal? (parse-test "\n") '(RifL-program))
(check-equal? (parse-test "\n ") '(RifL-program))
(check-equal? (parse-test "< \n") '(RifL-program))
(check-equal? (parse-test "> comment \n\n") '(RifL-program))
(check-equal? (parse-test "> comment<") '(RifL-program))
(check-equal? (parse-test "As: 2s >comment\n 3s")
              '(RifL-program (deck (name "As") (stack "2s" "3s"))))
(check-equal? (parse-test "As: 2s >comment< 3s")
              '(RifL-program (deck (name "As") (stack "2s" "3s"))))
(check-equal? (parse-test "As:  2s")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "As:2s")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "As: 2s ")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "As: 2s\n")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "As: 2s \n")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "\n \n   As: 2s")
              '(RifL-program (deck (name "As") (stack "2s"))))
(check-equal? (parse-test "As: 2s\n3s: 4s")
              '(RifL-program (deck (name "As") (stack "2s"))
                             (deck (name "3s") (stack "4s"))))
(check-equal? (parse-test "As 2s:") '(RifL-program (deck (name "As" "2s")
                                                         (stack))))
(check-equal? (parse-test "As, 2s:") '(RifL-program (deck (name "As" "2s")
                                                         (stack))))
(check-equal? (parse-test "As, 2s :") '(RifL-program (deck (name "As" "2s")
                                                         (stack))))
(check-equal? (parse-test "1s: F0s, 0s") '(RifL-program (deck (name "As")
                                                         (stack "F10s" "10s"))))
(check-equal? (parse-test "As: FKs F FR") '(RifL-program (deck (name "As")
                                                         (stack "FKs" "FR" "FR"))))