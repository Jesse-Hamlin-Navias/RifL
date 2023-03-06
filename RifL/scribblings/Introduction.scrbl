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
which have no suit). The pips are: A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, and R.
A means Ace, J is Jack, Q is Queen, K is King, and R is Joker.
The numbers signify themselves. The four suits are: spades, clubs, hearts, diamonds, and they are
represented by the four letters: s, c, h, d.

@verbatim{
As > The Ace of Spades
10d > The Ten of Diamonds}

Aces can also be written as 1, so As can be written as 1s instead.
Tens can be written as 0, so the 10d can be written as 0d instead.

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
as face-down cards, except in special cases where the Kh is used.

@section{Cards as Numbers}

RifL represents numbers using the cards A to 10. Aces will represent the digit 1,
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
spades is the bottom card. This deck represents the number 506.

Decks can have multiple pieces of information in them, separated 
by face-down cards. Face-down cards work much the same way the
spaces between words and numbers work, signifying and end to one
piece of information and the beginning of the next.

@verbatim{
5s, F, 10s, F, 6s}

In this deck, the Five of spades is the top card, the Six of
spades is the bottom card. This deck represents the number 5,
followed by the number 0, followed by the number 6. This deck
is not the number 506, but three separate and distinct values.

The number of face-down cards between values does not matter unless
your code uses the Kh. The following two decks are essentially identical:

@verbatim{
Deck 1: 5s, F, 10s, F, 6s
Deck 2: F, 5s, F, F, F, 10s, F, F, 6s F, F}

Royal Cards and Jokers are special in regards to spacing. They don't
need face-down cards between them and other information to be separated.
The following two decks are essentially identical:

@verbatim{
Deck 1: 5s, F, R, F, R, F, Ks, F, Qc, F, As
Deck 2: 5s, R, R, Ks, Qc, As}

Face-down cards between Jokers and Royal cards is optional, however
it is almost always best practice to separate everything out with
face-down cards, but when the Kh is later covered, this flexibility
will become useful.

@section{Instructions}

Number cards, that is from A-10, represent numbers and information.
Jokers also represent information, but are wild cards, and are interpreted
differently in different contexts, and are not valid in all contexts.
Royal cards, that is Jacks, Queens and Kings, are instructions to
manipulate that information. RifL resolves these instructions from
the top of a deck to the bottom.

To illustrate this, the Qc will stand as an example.
The Qc is the math royal card, used to add, subtract, multiply, and
divide numbers. Subtracting the number 3 from 5 in RifL looks as follows:

@verbatim{
5s F 3s F Ac F Qc
}

The Qc takes three arguments. From top to bottom, the first two arguments
are numbers (5 and 3 in this example), while the third argument ignores card
pip and only looks at suit (clubs in this example). This third argument determines
if the Qc adds, subtracts, multiplies, or divides the first two arguments. A club
tells the Qc to subtract.

@verbatim{
5s F 3s F Ac F Qc > Represents 5 - 3
}

@section{Postfix Notation}

RifL is coded in what is known as Postfix-notation.
In Postfix, the operators are written after the operands.
5 - 3 is written as 5 3 - in postfix. 2 * 5 - 3 is written
as 2 5 * 3 - in postfix. 13 - (2 * 5) is written as
13 2 5 * - in postfix.

This system may feel unintuitive at first, but it is very useful.
Postfix notation is always clear about the order of operations.
With classic infix notation, parentheses are needed to clarify if the order is
different than just reading left to right. Postfix never encounters this problem,
and so it is much better for writing code.

The Qc interprets a heart in its third argument as multiplication, so
the above three examples written in RifL look like this:

@verbatim{
Deck 1: 5s F 3s F Ac Qc > 5 3 -
Deck 2: 2s F 5s F Ah Qc F 3s F Ac Qc > 2 5 * 3 -
Deck 3: As 3s F 2s F 5s F Ah Qc F Ac Qc > 13 2 5 * -}

@section{The Stack}

To resolve instructions, RifL uses a special deck called the stack.
RifL proceeds in steps. Each step, RifL looks at the top of our deck,
and if it is not a Royal card, puts that card on top of the stack.
If the top card of our deck is a Royal card, RifL pulls information
from the top of the stack to fill the Royal card's needed arguments,
and then follows that Royal
card's instructions. The Royal card does not go on top of the stack.
RifL would process 5 - 3 as follows:

@verbatim{
Stack:  > Starts empty
Deck: 5s F 3s F Ac Qc

> Step 1
Stack: 5s
Deck: F 3s F Ac Qc

> Step 2
Stack: F 5s
Deck: 3s F Ac Qc

> Step 3
Stack: 3s F 5s
Deck: F Ac Qc

> Step 4
Stack: F 3s F 5s
Deck: Ac Qc

> Step 5
Stack: Ac F 3s F 5s
Deck: Qc

> Step 6
Stack: 2s
Deck:  > Empty
}

The Qc inserts the answer, 2, back onto the stack.
RifL stops running when its current deck is empty. Notice
how the stack holds the information in backwards order. When
the Qc is at the top of the deck, RifL retrieves the first three
pieces of information from the stack, and reverses them. For
this reason, multi-digit numbers are reversed in the stack.

2 * 34 would resolve like this:

@verbatim{
Stack: > Starts Empty
Deck: 2s F 3s 4s F Ah Qc

> Step 6
Stack: Ah F 4s 3s F 2s
Deck: Qc

> Step 7
Stack: 8s 6s > The number 68
Deck: > Empty
          }

@section{Structure of Code}

The decks are laid on a table, with the following structure:

@verbatim{image}

The table has four columns from left to right: spades, clubs, hearts, diamonds.
Each row is given a number, starting at the bottom with 1, and increasing upwards indefinitely.
This gives the bottom left deck space the identifier 1 of spades, or rewritten,
the name As. The deck space directly above that
has the name 2s, and so on. Each deck space on the table has a card sequence identity.

The pointer determines which deck RifL takes the top card from and moves onto
the stack. The pointer is the name of a space on the table.
In any RifL program, the pointer always starts at the As deck.
The Js moves the pointer to other deck spaces, so the pointer can change
over the runtime of a RifL program.

If the table starts with an empty As deck, the program will
immediately terminate, since RifL programs end when the current deck is empty.

Some Royal cards can refer not only to decks in the table, but also
the stack. The stack has the card reference R. The Royal card
specifications later in the documentation will always declare
if royal cards that refer to decks can refer to the stack.

@section{Writing RifL Code}

When writing RifL, each non-empty deck will have its name, followed by a colon,
followed by the cards in that deck from top to bottom:

@verbatim{
As: 2c, 4c, Js       > The deck 1 of spades, with some cards in it
2c 4c: 1d, F, As, Jd > The deck 24 of clubs, with some cards in it
}

Cards can optionally have a comma after them, depending
if you find that more readable.

Decks can be broken up into any number of lines, but a new deck
must always start on a new line.

@verbatim{
As: As 3s F 2s F 5s > The number 13, 2, 5
    F Ah Qc > Multiply
    F Ac Qc > Subtract
2s: R R R   > The 2 of spades deck
          }

Anything that follows a > will not be
read by the RifL executor, until either a line break or a <.
These are called comments.

@verbatim{
>This is a comment
>This is also a comment< As: 3c >That was a deck
          }

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
deck spaces. Place the token on the As deck space.
Most RifL programs will need extra sets of cards, so keep a
handful of decks ready. When running physically, Face-down cards
can be any card, unless the code you are running uses the Kh.

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

If at anytime a Royal card requires an argument from the stack,
and there are no more arguments in the stack, the code has
hit an error and the code stops. If at any time a Royal card
makes its way into the stack, the code hits an error and stops.

