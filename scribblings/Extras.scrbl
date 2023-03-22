#lang scribble/manual

@title{Extras}

@section{Program Examples}

@subsection{Hello World!}
Prints out "Hello World!"
@codeblock|{
#lang RifL

0s: 3h 3h F Ah 10h 10h F Ah 10h 8h F Ah Ah 4h F Ah Ah Ah F 8h 7h F > "!dlroW"
    3h 2h F > space
    Ah Ah Ah F Ah 10h 8h F Ah 10h 8h F Ah 10h Ah F 7h 2h > "olleh"
    F R F Ac Jd
}|

@subsection{Truth Machine}
Takes an input.
If input starts with 0 or #f, print input & terminate.
Otherwise print input infinitely.
@codeblock|{
#lang RifL

0s: 2s F, 0s, F, > Results of if statement
    0d, F, > load concatenation
    2c, F, Ad, Jd > Take data input onto 2c
    2c, F, 0s, F, 0s, Ks > Copy top arg 2c onto As
    >0d, F, input,< R, Qc > Concat 0d + input
    >2s, F, 0s, F, 0d, input,< Qh >If top arg input is not 0, 2c. Else As.
    >2s or 0s< Js > Move to As or 2s
    2c, F Ac, Jd > Print deck 2c

2s: 2s, F, 2s, R, Ks > Copy 2s deck onto 2s deck
    2c, F, Ac, Jd > Print out deck 2c
    2s, F, 2s, R, Ks > Copy 2s deck onto 2s deck
}|

@subsection{Fibonacci}
Takes a positive whole number input,
and outputs the nth number of the Fibonacci
sequence, where n0 = 0 and n1=1.
@codeblock|{
#lang RifL

0s: 2c, F Ad, Jd > input data to 2c
    Ah, F, 0s, R Ks > copy Ah onto 0s

Ac: 0s, F, 1s, F > 0th and 1st term of Fib

2c: >input deck

Ah: >(if input less than 2)
    Ad, F, 2d, F, > load if results
    2c, F 0s, R Ks > copy input to 0s
    >input< F 1s, F, As, Qs > greater of input and 1
    >result< F, 1s, F, Ad Qs > is input less than 2?
    >Ad, F, 2d, F, result< Qh >if result, Ad, else 2d
    >result< F, 0s R Ks > copy result deck onto 0s

Ad: >(true case: print result)
    Ac, F, 0s, F, > load for Ks
    2c, F, 0s, R, Ks > copy input to 0s
    >Ac, F, 0s, F, input< Ks > get input arg of Ac onto 0s
    R, Ac, Jd > print out input arg of Ac

2d: Ac, F, 3c, F, 1s Ks > copy 2nd args of Ac onto deck 3c
    Ac, F, 0s, F, 1d Ks > move full 2s onto 0s
    >2s args< F, As, Qc > add args of 2s together
    F, R, Ac F 0h Ks > move result onto Ac
    3c, F, Ac, F, 0h, Ks > move 3s onto 2s
    2c, F, 0s, F, 0h, Ks > move input to 0s
    >input< F, 1s, F Ac Qc > input - 1
    R, 2c, F, 0h, Ks > move result onto 2c
    Ah, F, 0s, R Ks > copy Ah onto 0s
           }|

@subsection{Quine}
A RifL program that prints out itself (ignoring "#lang RifL").
@codeblock|{
#lang RifL
10s: 10s FR As R Ks As FR 2s FR 2d Ad Ks As FR 2s R Ks 2s FR As R Ks 3h 2h FR 5h 8h FR Ah Ah 5h FR As 10s FR R Ac Jd As FR As Jd 10s FR As R Ks
}|

@subsection{Brainfuck}
An interpreter for the esoteric language Brainfuck.
This is a very limited interpreter. It does not handle
errors, so any Brainfuck code that would result in an
error will have undefined outputs.
It takes character inputs, but because of RifL's strange
data input interpretation, numbers and the strings "#t" or "#f"
will cause errors to the Brainfuck code.
The interpreter can take multiple input characters at a time,
and will only ask for a new input when it has run out of
inputted characters to use.
Inputting nothing when the interpreter asks for input characters
will result in an error.
@codeblock|{
#lang RifL
>Brainfuck

>cells
0s: 0c, Js, 0h > Move to 0c as starting deck, initialize 0 with 0h
As: 0h > initialize 1 with 0h

>functions
0c: 4d, F, Ad, Jd > new start, take data input
    >If code index = code size, stop
    1c 0c, F, 2c, F,> load if results
    4d, Jh > get code size
    R, 3d, F, 0s Ks > copy code size to 3d 
    F, 2d, F, 0c, R Ks > copy code index to here
    >code size F code index< F Ad Qs > code size = code index equivalent
    >0c, F, 2c, F, (index=size)< Qh
    >0c or 2c< F, 0c, R Ks > copy 2c onto 0c if code index is less than code size

Ac: >If code index = code size, stop
    1c 0c, F, 2c F> load if results
    2d, F, 0c, F 0h, Ks > move code index here
    >code index,< F, As, F, As, Qc > code index + 1
    F, R, 2d, F, 0s, Ks > copy code index + 1 to 2d
    F 3d, F, 0c, R Ks > copy code size to here
    >index F code size< F Ad Qs > code index = code size equivalent
    >0c, F, 2c, F, (index=size)< Qh
    >0c or 2c< F, 0c, R Ks > copy 2c onto here if code index is less than code size

2c: Ac, F, 3c, F > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    >cur char< F, 4h 3h, F, Ac Qs> lesser of 43 and cur char
    >result< F, 4h 3h, F, Ah, Qs > greater or equal to 43
    F,
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    >cur char< F, 4h 6h, F, As Qs> greater of 46 and cur char
    >result< F, 4h 6h, F, Ah, Qs > less than or equal to 46
    >greater or equal 43< >F< >less or equal 46< F, Ac Qs> AND
    >Ac, F, 3c,< >Ad or 0d< Qh > if cur char is between, Ac, else 3c
    >Ac or 3c< F, 0c, R, Ks > copy Ac or 3c onto 0c

3c: 4c, F, 5c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 9h 1h, F, Ah, Qs > cur char == 91
    >4c, F, 5c, F,< >91 or 0d< Qh > if cur char == 91 4c, else 5c
    >4c or 5c< F, 0c, R, Ks > copy 4c or 5c onto 0c

4c: 2d, F 0c, R Ks > copy code index to 0c
    >F, As, F, As, Qc > index + 1
    F, Ah Qd > index to hearts
    F, R, 5d, F 0h Ks> move heart index to 5d
    Ac, F, 0c, R Ks > copy Ac onto 0c

5c: 6c, F, 7c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 9h 3h, F, Ah, Qs > cur char == 93
    >6c, F, 7c, F,< >93 or 0d< Qh > if cur char == 93 6c, else 7c
    >6c or 7c< F, 0c, R, Ks > copy 6c or 7c onto 0c

6c: 5d, F, 0c, F, 0s, Ks > copy last [ pos onto 0c
    F, Ah, Qd > to hearts
    R > load
    2d, F, 0c, R, Ks F, Ah, Qd > copy ] pos to hearts
    >R, F, index hearts< F, 0h, Ks > move last [ pos+1 onto deck hearts ]
    >>>>
    2d, F, 0c, R, Ks F, Ah, Qd > copy ] pos+1 to hearts
    R > load
    5d, F, 0c, F, 0h Ks > move last [ pos to 0c
    >R< >last [ pos< F, 0h, Ks > copy ] pos+1 to deck [
    Ac, F, 0c, R Ks > copy Ac onto 0c

7c: Ac, F, 8c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 6h 0h, F, Ah, Qs > cur char == 60
    >Ac, F, 8c, F,< >61 or 0d< Qh > if cur char == 61 Ac, else 8c
    >Ac or 8c< F, 0c, R, Ks > copy Ac or 8c onto 0c

8c: Ac, F, 9c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 6h 2h, F, Ah, Qs > cur char == 62
    >Ac, F, 9c, F,< >62 or 0d< Qh > if cur char == 62 Ac, else 9c
    >Ac or 9c< F, 0c, R, Ks > copy Ac or 9c onto 0c

9c: 4d, F, R, > load deletion
    2d, F, 0c, R Ks > copy code index
    >index< F, Ah, Qd > turn index to hearts 
    >4d, F, R,< >index h< Ks > delete cur char
    2d, F, 0c, F, 0h, Ks > move code index 0c
    >index< F, As, F, Ac, Qc > index - 1
    F, R, 2d, F, 0h, Ks > move index - 1 to 2d
    3d, F, 0c, F 0h, Ks > move code size 0c
    >index< F, As, F, Ac, Qc > size - 1
    F, R, 3d, F, 0h, Ks > move size - 1 to 3d
    Ac, F, 0c, R Ks > copy Ac onto 0c

1c 0c: 2d, R, 0h Ks > delete code index
       Ac > -1
       R, 2d, F, 0h, Ks > set code index = -1
       1c 1c F, 0c, R Ks > copy 11c onto 0c

1c 1c: >If code index = code size, stop
       0c, F, 1c 2c F > load if results
       2d, F, 0c, F 0h, Ks > move code index here
       >code index,< F, As, F, As, Qc > code index + 1
       F, R, 2d, F, 0s, Ks > copy code index + 1 to 2d
       F 3d, F, 0c, R Ks > copy code size to here
       >index F code size< F Ad Qs > code index = code size equivalent
       >0c, F, 1c 2c, F, (index=size)< Qh
       >0c or 1c 2c< F, 0c, R Ks > copy 1c 2c onto here if code index is less than code size

1c 2c: 4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
       F, Ac, Qd > turn cur char to clubs
       >cur char as deck,< F, 0c, R, Ks > copy cur char deck onto 0c
       >cur char happens<
       1c 1c F, 0c, R, Ks > copy 11c onto 0c

4c 3c: > + > 43
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index,< F, 0c, F, 0h, Ks > move cell index [data] to 0c
       >cur data< F, As, F, As, Qc > cur-data++
       R, > load move
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell-index,< F, 0h, Ks > move top of R to cell index

4c 2c: 4c 2c, F, 4c 2c, R Ks > copy this onto this
       5d, R, R, Ks > delete 5d
       5d, F, Ad, Jd > input data onto 5d
       0c, Js > move back to 0c
       4c 2c, F, 4c 2c, R Ks > copy this onto this

4c 4c: > , > 44
       4c 2c, F, 0c, F, > load ifs
       5d, Jh> get # args 5d
       >5d< F, 0s, F, Ad, Qs > # args = 0
       >4c 2c, F, 0c, F,< >true or false< Qh > if true, get input, then replace, if false, just replace
       Js > move to 42c or stay here
       >replace \/
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index< R, R, Ks > delete cell [index]
       5d, F, > load
       0d, F, 0c, R, Ks > copy cell index to 0c
       >5d, F, cell-index< F, 0h, Ks > move top 5d to cell [index]

4c 5c: > - > 45
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index,< F, 0c, F, 0h, Ks > move cell index [data] to 0c
       >cur data< F, As, F, Ac, Qc > cur-data--
       R, > load move
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell-index,< F, 0h, Ks > move top of R to cell index

4c 6c: > . > 46
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index< F, 0c, F, 0h, Ks > move cell [index] to 0c
       >cur data< F, Ah, Qd > turn cur-data to heart
       R, > load
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell index,< F, 0h, Ks > move top of Stack to cell index
       0d, F, 0c, R, Ks > copy cell index to 0c
       F, Ac, Jd > print cell index

6c 0c: > < > 60
       0d, F, 0c, F, 0h, Ks > move cell index to 0c
       F, As, F, Ac, Qc > cell index--
       R, 0d, F, 0h, Ks > move top stack onto 0d

6c 2c: > > > 62
       0d, F, 0c, F, 0h, Ks > move cell index to 0c
       F, As, F, As, Qc > cell index++
       R, 0d, F, 0h, Ks > move top stack onto 0d
       6c 3c, F, 6c 4c, F,> load if
       0d, F, 0c, F, R, Ks > Copy cell index to 0c
       F, 1d, F, 0c, F, R, Ks > Copy max cell index to 0c
       >cell index, F, max cell,< F, Ad, Qs > max cell = cell index?
       >6c 3c, F, 6c 4c, F, max=index< Qh > if max=index -63, else -64
       >-63 or -64< F, 0c, R, Ks > Copy 63 or 64 onto 0c

6c 3c: 1d, F, 0c, F, 0h, Ks > move max cell index to 0c
       F, As, F, As, Qc > max cell++
       R, 1d, F 0h, Ks > move new max cell to 1d
       0h, R, > load
       1d, F, 0c, R, Ks > copy max cell to 0c
       >R, max cell< F, 0h, Ks > move 0h from stack to max-cell
       

9c 1c: > [ > 91
       9c 2c F, 9c 0c F, > load
       0d, F, 0c, R, Ks > get copy of cell index
       >cell index< F, 0c, R, Ks > get value at deck [cell index]
       >value< F, 0s, F, Ad Qs > is value = 0
       >9c 2c F, 9c 0c F, val=0< Qh > if so, 92c, else 90
       F, 0c, R Ks > copy either 92c or 90c onto 0c

9c 2c: 2d, F, 0c, F 0h, Ks > move code index to 0c
       >code index< F, Ah Qd > hearted
       >[ key< F, 0c, R, Ks > get value at deck [code index]
       R, 2d, F, 0h, Ks > set code index to resulting number

9c 3c: > ] > 93
       9c 5c F, 9c 4c F,
       0d, F, 0c, R, Ks > get copy of cell index
       >cell index< F, 0c, R, Ks > get value at deck [cell index]
       >value< F, 0s, F, Ad Qs > is value = 0
       >9c 5c F, 9c 4c F, val=0< Qh > if so, 95c, else 94c
       F, 0c, R Ks > copy either 95c or 94c onto 0c

9c 4c: 2d, F, 0c, F 0h, Ks > move code index to 0c
       >code index< F, Ah Qd > hearted
       >[ key< F, 0c, R, Ks > get value at deck [code index]
       R, 2d, F, 0h, Ks > set code index to resulting number

>variables & constants
0d: 0s > cell index
1d: As > largest cell tracker. +1 if reach new max
2d: 0s > code index
3d:    > code size
4d:    > bf code
           }|

@section{Development}
RifL was started in my Sophomore year of college, with
the goal of creating an esoteric language that could
be run physically. It was partially finished there,
and the first build was completed 3 years later.

I intend RifL to receive updates in the future, for
a few reasons:

First, the functionality of RifL is not complete.
I intentionally left some Royal cards incomplete
or not implemented at all. This is the first
language I have designed, and as such, I know
that letting some of the functionality grow out
of user needs rather than design ideas is healthy.
In a language like RifL that can have only 12 functions,
leaving myself some open space is required to do this.

Second, the parser is slow. When running RifL code
of large enough size, including the Brainfuck interpreter,
you may find it annoying having to wait a few seconds.
I used @hyperlink["https://docs.racket-lang.org/brag/"]{Brag} to
build my interpreter, but it turns out Brag is not efficient
with run time or memory usage.
I will rebuild the parser in a future update when I am feeling
interested in this project again.

Third, debugging systems. The current debugging systems
RifL gives you to step through code is crude and inefficient.
In the future I will provide more natural feeling ways
to see what RifL code is doing while it is running. Luckily,
you can just run RifL code physically for yourself to see what is
happening. That is always the best approach for debugging RifL.

@section{Aknowledgments}
@hyperlink["https://drablab.org/keithohara/"]{Keith O'Hara}, my
computer science professor of my design of programming languages,
as well as my thesis advisor, and all around great guy. If you
ever get a chance to learn from this man, take that opportunity.
He is what so few manage to be: a good programer, an excellent teacher,
and a great person. If you see him, tell him I say hi.

@hyperlink["https://beautifulracket.com/"]{Matthew Butt­erick} and
his great online textbook, beautiful racket, as well as the
@hyperlink["https://docs.racket-lang.org/br/"]{Beautiful Racket}
and @hyperlink["https://docs.racket-lang.org/brag/"]{Brag} libraries.
If you are interested in building a coding language in Racket,
I recommend you start here.

@hyperlink["https://www.greghendershott.com/fear-of-macros/index.html"]{Greg Hendershott},
a good online teacher and expert in the weird and strange
world of Racket and Racket macros. I have not yet had the
pleasure of meeting this Racket wizard in his tower, but
if you do, listen carefully.
