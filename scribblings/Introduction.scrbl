#lang scribble/manual

@title{Introduction}

The best way to start learning RifL is from a top down view.
You will need to be familiar with a 52 card deck (along with Jokers),
so if you are unfamiliar, go and grab one now and look through it.
This chapter overviews how RifL operates, and teaches you to read,
write, and execute RifL code both physically and on a computer.

@section{Card Notation}

To write and read RifL code, a notation system for cards is needed.
All cards have a pip value, followed by a suit letter (except for Jokers
which have no suit). The pips are:

@centered{@tabular[#:sep @hspace[2]
         (list (list @bold{Pip} "Ace" "2" "3" "4" "5" "6" "7" "8" "9" "10" "Jack" "Queen" "King" "Joker")
               (list @bold{Symbol}  "A"   "2" "3" "4" "5" "6" "7" "8" "9" "10" "J"    "Q"     "K"    "R"))]}


The four suits are:

@centered{@tabular[#:sep @hspace[2]
         (list (list @bold{Suit}   "spades" "clubs" "hearts" "diamonds")
               (list @bold{Symbol} "s"      "c"     "h"      "d"))]}

Some example cards:

@verbatim{
As > The Ace of Spades
10d > The Ten of Diamonds}

Aces can also be written as 1, and Tens can be written as 0:

@verbatim{
1s > The Ace of Spades
0d > The Ten of Diamonds}

All of the cards we have discussed so far as face-up. Cards in RifL
can also be face-down. Face-down cards are written with a F in front.

@verbatim{
FJc > The face-down Jack of Clubs
F0d > The face-down Ten of Diamonds}

A face-down Joker can be written as FR, or shorthanded as just F.

@verbatim{
FR > A face-down Joker
F  > Also a face-down Joker}

Most of the time RifL code does not rely on the value of face-down cards,
so it's ok to just write F whenever we need a face-down card. When running
RifL physically, in most cases you can use whatever extra cards you have
as face-down cards, except in special cases where the @secref{Kh} is used.

@section{Cards as Numbers}
RifL represents numbers using the number cards, that is from A-10. Aces will represent the digit 1,
Two cards the digit 2, and so on. However Ten cards will represent the digit 0.
The cards are laid out left to right, with the rightmost card representing
the 1s places, the second card the 10s place, the third card the 100s place,
and so on.

@verbatim{
As 2s > 12, the number twelve
As 2s 3s > 123, the number one-hundred and twenty-three
9s 10s > 90, the number ninety}

Leading zeros can be ignored.

@verbatim{
10s > 0
10s 6s > 6
10s 5s 10s 6s > 506
10s 10s > 0}

@section{Decks}

RifL code is separated into decks of cards, with the top card
written at the left, and the bottom card written on the right.

@verbatim{
5s, 10s, 6s}

In this deck, the Five of spades is the top card, the Six of
spades is the bottom card. This deck has one argument, the number 506.

Each deck has a name, written before the cards of the deck, followed by a ":".
The name of a deck is a positive whole number and a suit.

@codeblock|{
#lang RifL
0s: 5s, 10s, 6s > The zero spade deck, with the number 506 in it
1s: 10s, 6s > The 1 spade deck, with the number 6 in it
3s 2s: 4s, 6s > The 32 spade deck, with the number 46 in it
           }|

The cards in a deck's name must all be of the same suit. Additionally,
a deck's name cannot use leading zeros.

Decks can have multiple arguments, each separated 
by face-down cards. Face-down cards work much the same way the
spaces between words and numbers work, signifying an end to one
piece of information and the beginning of the next.

@codeblock|{
0s: 5s, F, 10s, F, 6s}|

In this zero spade deck, the Five of spades is the top card, the Six of
spades is the bottom card. This deck represents the number 5,
followed by the number 0, followed by the number 6. This deck
is not the number 506, but three separate and distinct arguments.

The number of face-down cards between arguments does not matter unless
your code uses the @secref{Kh}. The following two decks are essentially identical:

@codeblock|{
#lang RifL
0s: 5s, F, 10s, F, 6s
1s: F, 5s, F, F, F, 10s, F, F, 6s F, F}|

Royal Cards and Jokers are special in regards to spacing. They don't
need face-down cards between them and other arguments.
The following two decks are essentially identical:

@codeblock|{
#lang RifL
0s: 5s, F, R, F, R, F, Ks, F, Qc, F, As
1s: 5s, R, R, Ks, Qc, As}|

Face-down cards between Jokers and Royal cards is optional, however
it is almost always best practice to separate everything out with
face-down cards, but when the @secref{Kh} is later covered, this flexibility
will become useful.

@section{Jokers}
Jokers, like the number cards, represent information, but are wild cards, and are interpreted
differently in different contexts, and are not valid in all contexts.
Jokers is somewhat comparable to the 'null value found in other programming languages,
although that comparison sells short the usefulness of the Joker.

@section{Instructions}
Royal cards, that is Jacks, Queens and Kings, are instructions to
manipulate information in decks. RifL resolves these instructions from
the top of a deck to the bottom.

To illustrate this, the @secref{Qc} will stand as an example.
The @secref{Qc} is the math royal card, used to add, subtract, multiply, and
divide numbers. Subtracting the number 3 from 5 in RifL looks as follows:

@codeblock|{
#lang RifL
0s: 5s F 3s F Ac F Qc
}|

The @secref{Qc} takes three arguments. From top of the zero spade deck to bottom, the first two arguments
are numbers (5 and 3 in this example), while the third argument ignores card
pip and only looks at suit (clubs in this example). This third argument determines
if the @secref{Qc} adds, subtracts, multiplies, or divides the first two arguments. A club
tells the @secref{Qc} to subtract.

@codeblock|{
#lang RifL
0s: 5s F 3s F Ac F Qc > Represents 5 - 3
}|

@subsection{Postfix Notation}

Most logical operators are usually written in
@hyperlink["https://en.wikipedia.org/wiki/Infix_notation"]{Infix Notation}.
RifL is coded in what is known as
@hyperlink["https://en.wikipedia.org/wiki/Reverse_Polish_notation"]{Postfix Notation}.
In Postfix, the operators are written after the operands.

@centered{@tabular[#:sep @hspace[2]
         (list (list @bold{Infix}   @bold{Postfix})
         (list "5 - 3"        "5 3 -")
         (list "2 * 5 - 3"    "2 5 * 3 -")
         (list "13 - (2 * 5)" "13 2 5 * -"))]}

This system may feel unintuitive at first, but it is very useful.
It is always clear in postfix notation the order of operations.
With infix notation, parentheses are needed to clarify if the order is
different than reading left to right. Postfix never encounters this problem,
and so it is much better for writing code.

The @secref{Qc} interprets a heart in its third argument as multiplication, so
the above three examples written in RifL look like this:

@codeblock|{
#lang RifL
0s: 5s F 3s F Ac Qc > 5 3 -
1s: 2s F 5s F Ah Qc F 3s F Ac Qc > 2 5 * 3 -
2s: As 3s F 2s F 5s F Ah Qc F Ac Qc > 13 2 5 * -}|

@subsection{The Stack}

To resolve instructions, RifL uses a special deck called the stack.
RifL proceeds in steps. Each step, RifL looks at the top of the current deck,
and if it is not a Royal card, puts that card on top of the stack.
If the top card of the current deck is a Royal card, RifL pulls information
from the top of the stack to fill the Royal card's needed arguments,
and then follows that Royal
card's instructions.
After following the Royal's instructions, none
of the used arguments nor the Royal card goes on top of the stack.
RifL would process 5 - 3 as follows:

@codeblock|{
>Stack:  > Starts empty
0s: 5s F 3s F Ac Qc

> Step 1
>Stack: 5s
0s: F 3s F Ac Qc

> Step 2
>Stack: F 5s
0s: 3s F Ac Qc

> Step 3
>Stack: 3s F 5s
0s: F Ac Qc

> Step 4
>Stack: F 3s F 5s
0s: Ac Qc

> Step 5
>Stack: Ac F 3s F 5s
0s: Qc

> Step 6
>Stack: 2s
0s:  > Empty
}|

The @secref{Qc} inserts the answer, 2, back onto the stack.
RifL stops running when its current deck is empty. Notice
how the stack holds the information in backwards order. When
the @secref{Qc} is at the top of the deck, RifL retrieves the first three
pieces of information from the stack, and reverses them. For
this reason, multi-digit numbers are reversed in the stack.

2 * 34 would resolve like this:

@codeblock|{
>Stack: > Starts Empty
0s: 2s F 3s 4s F Ah Qc

> Step 6
>Stack: Ah F 4s 3s F 2s
0s: Qc

> Step 7
>Stack: 8s 6s > The number 68
0s: > Empty
          }|

@section{Structure of Code}

The decks are laid on a table, with the following structure:

@image{scribblings/RifL_Grid.png}

Each space on the table is a deck name, starting at 0 on the bottom
row and increasing indefinitely upwards. Each deck is given its name
based on which space of the table it occupies. Spaces on the table
are empty by default until a deck is put there.

@codeblock|{
#lang RifL
0s: 5s 10s 6s > This deck is in the bottom left space of the table
1s: > This deck is one above the 0s deck
0c: > This deck is one space to the right of the 0s deck
}|

When running RifL code, the pointer determines the current deck.
The current deck is the deck which RifL pulls from the top of.
The pointer always starts at the 10s deck, and
can change over the runtime of a RifL program.
If the table starts with an empty 10s deck, the program will
immediately terminate, since RifL programs end when the current deck is empty.

Some Royal cards can refer not only to decks in the table, but also
the stack. The stack has the card reference R. The @secref{Royal} card
specifications later in the documentation will always declare
if royal cards that refer to decks can refer to the stack.

@section{Writing RifL Code}

When writing RifL, each non-empty deck will have its name, followed by a colon,
followed by the cards in that deck from top to bottom:

@codeblock|{
#lang RifL
0s: 2c, 4c, Js       > The deck zero of spades, with some cards in it
2c 4c: 1d, F, As, Jd > The deck 24 of clubs, with some cards in it
}|

Cards can optionally have a comma after them, depending
if you find that more readable.

Decks can be broken up into any number of lines, but a new deck
must always start on a new line, and a deck's name, including the colon,
must all be on the same line.

@codeblock|{
10s: As 3s F 2s F 5s > The number 13, 2, 5
    F Ah Qc > Multiply
    F Ac Qc > Subtract
As: R R R   > The 1 of spades deck
}|

Anything that follows a > will not be
read by the RifL executor, until either a line break or a <.
These are called comments. Anything between a ( and a ) is also a comment.

@codeblock|{
#lang RifL
>This is a comment
>This is also a comment< 0s: 3c >That was a deck
(This
is also
a comment)
          }|

@section{Debugging}
If you are running RifL digitally, it can sometimes be hard
to figure out what is going wrong when your code is not
behaving as expected. Three debugging modes have been
included to help with this. To use one of these modes,
at the beginning of the RifL code (after "#lang RifL" but
before any decks), you can type any of the following:

@verbatim{
step-by-step
royal-by-royal
end-state
}

Step by step will print out the RifL table after
every step of running the code. This is the most
costly of the debugging modes.

Royal by royal will print out the RifL table when
the top card of the current deck is a Royal card.

End state will print out the RifL table when the
code is done executing or when RifL encounters an
error. This is the least costly of the debugging modes.

If you have multiple debugging modes enabled, they
must be written in the order shown above. Anytime
multiple debugging modes would print the RifL table
at the same time, the RifL table is only printed once.
Commenting out a debugging mode turns it off.

@section{Physically Running}

All the same rules of RifL apply when running RifL physically.
A good way to run RifL by hand is to draw the table out on
a large piece of paper, or take masking tape to mark out the grid
of the table, and a sharpie to write the name of each grid space
that you delineate on the masking tape. Grid spaces need to be
large enough to place decks of cards onto.
You'll need a space to one
side of the grid to use as your stack. Additionally, a token of some
sort is useful to mark which grid space the pointer is at. Finally,
you will need the list of what each Royal card does.

To begin, set up all the cards in the code in their corresponding
deck spaces. Place the token on the 0s deck space.
Most RifL programs will need extra sets of cards, so keep a
handful of decks ready. When running physically, Face-down cards
can be any card, unless the code you are running uses the @secref{Kh}.

At each step of RifL, take the top card of the deck the pointer is at,
and put it on top of the stack. If the top card of the pointer deck
is a Royal card, instead look up how many arguments it needs.
One by one take cards
from the top of the stack, and put them on top of a temporary pile. Do this
until you get the required number of arguments for the Royal card, and
the top card of the stack is a face-down card, a Joker, or the stack
is empty.
Then follow the instructions of the Royal card.
Once you are done following the instructions,
take the Royal card and any cards in that temporary pile
and put them in a discard to the side.

If at any time a Royal card requires an argument from the stack,
and there are no more arguments in the stack, the code has
hit an error and the code stops. If at any time a Royal card
makes its way into the stack, the code hits an error and stops.