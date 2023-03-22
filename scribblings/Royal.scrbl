#lang scribble/manual

@title{Royal}

@section{Instruction Notation}
Each Royal card below lists its form, which
shows the number of arguments it takes, and
gives each argument a name. Named arguments are
written between square brackets.

After the form, the instructions, that is
the digital/physical process to follow is listed.
Arguments might be written with data types before them,
which is an instruction to convert the argument
into that data type.

Anytime an argument gets put on top of the stack,
the argument must be reversed in order first.

@section{Jacks}

@subsection{Js}

@bold{Form: [Deck], Js}

@bold{Instruction:} Move the pointer to [Name (stack exclusive) Deck].

@subsection{Jc}

@bold{Form: [X], [Y], Js}

@bold{Instruction:} Starting at the current deck space, count to the right
[Integer X] times, and up [Integer Y] times. Diamonds wrap around to spades.
Negative [Integer X] moves left. Negative [Integer Y] moves down.
Push the name of the landed on deck space onto the stack.
If the landed on deck space is below the bottom row of the table,
throw an error.

@subsection{Jh}

@bold{Form: [Deck], Jh}

@bold{Instruction:} Count the number of arguments of [Name (stack inclusive) Deck].
Turn that integer into cards,
and put it on top of the stack.

@subsection{Jd}

@bold{Form: [Deck], [Operation], Jd}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Print Cards} Output the [Name (stack inclusive Deck] as a list of cards.
Outputting a deck does not change it.

@italic{Clubs: Print Data} Output the [Name (stack inclusive Deck] as interpreted data. If the
named deck is the stack, it gets outputted in reversed order.
Data with the leading suit spades or clubs
gets interpreted as a Real number. Data with the leading suit hearts and Jokers
gets interpreted as a character. Data with the leading suit diamonds gets
interpreted as a boolean. Royal cards do not get outputted.
Outputting a deck does not change it.

@italic{Hearts: Read Cards} Take an input of cards and puts
it on top of the [Name (stack inclusive Deck]. If the named deck is the stack,
reverse the inputted cards before putting them on top of the stack.

@italic{Diamonds: Read Data} Take an input of characters,
and transform it into cards, and put it on top of the named deck.
If the named deck is the stack, reverse the cards before putting it
on top of the stack.
Every character gets turned into its ascii number, then that
number gets turned into a card sequence with the suit hearts.
A face-down R is put between each datum read in.

However, there are special characters that get turned into
cards differently.

@itemlist[@item{A string of characters that are all digits
          gets turned into a number, then turned into a spades card sequence.
          If the string of digits starts with a #\- the cards are
          club suit. If a #\. appears before the digits, the
          card sequence starts with a 10s (or 10c if the digits
          have a #\- before them), then a 10d, then the digits as cards.
          If a #\. appears in between digits, a 10d is placed in
          between those digits.}
          @item{The string "#t" gets turned into the card As.
           The string "#f" gets turned into the card 10d.}]


@italic{Joker:} Error

@italic{This card is likely to be updated in the future.
Use 10 cards for [Operation] for future proofing.}


@section{Queens}

@subsection{Qs}

@bold{Form: [A], [B], [Operation] Qs}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Greater-than/OR:} If [A] & [B] have the same leading suit, put the larger
of [Real A] & [Real B] onto stack. If they
are both equal to 0, the one with less cards is the larger value.

If [A] & [B] have different leading suits, put the one with the
"larger" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Clubs: Less-than/AND:} If [A] & [B] have the same leading suit, put the smaller
of [Real A] & [Real B] onto stack. If they
are both equal to 0, the one with more cards is the smaller value.

If [A] & [B] have different leading suits, put the one with the
"smaller" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Hearts: Equal/XNOR:} If [A] is exactly the same as [B],
put [A] on top of the stack. Otherwise, put 0d on top of the stack.

@italic{Diamonds: Equivalent/NOT:} If both [Boolean A] & [Boolean B] are false,
put Ad on top of the stack. Otherwise, if [Integer A] is the same as [Integer B],
put [A] on top of the stack. Otherwise, put 10d on top of the stack.

@italic{Joker:} Error

@subsection{Qc}

@bold{Form: [A], [B], [Operation] Qc}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Add:} Put [Real A] + [Real B] on top of the stack.

@italic{Clubs: Subtract:} Put [Real A] - [Real B] on top of the stack.

@italic{Hearts: Multiply:} Put [Real A] * [Real B] on top of the stack.

@italic{Diamonds: Divide:} Put [Real A] / [Real B] on top of the stack.
If [Real B] is zero, throw an error.

@italic{Joker: Concatenate:} Put [A] on top of the stack,
then put [B] on top of the stack. Do not put any
face-down cards between them.


@subsection{Qh}

@bold{Form: [A], [B], [Proposition] Qh}

@bold{Instruction:} If [Boolean Proposition] is #t,
put [A] on top of the stack. If
[Boolean Proposition] if #f, put [B] on top of the stack.
If [Boolean Proposition] is null, do nothing.


@subsection{Qd}

@bold{Form: [Sequence], [Modifier] Qd}

@bold{Instruction:} If [Sequence] or [Modifier] is a Joker,
throw an error. Otherwise, make a copy of [Sequence],
except the suit of every card in the copy of [Sequence] is the
same as the leading suit of [Modifier]. Put the copy of [Sequence]
on top of the stack.

@italic{This card is likely to be updated in the future,
such that [Modifier] had multiple functions. Use 10 cards
for [Modifier] for future proofing.}

@section{Kings}

@subsection{Ks}

@bold{Form: [Origin], [Destination], [Operation] Ks}

@bold{Instruction:} Find the [Integer Operation] argument of [Name (stack inclusive) Origin].
If there are not enough arguments in [Name (stack inclusive) Origin], throw an error.
The leading suit of [Operation] changes the function.

@italic{Spades: Copy One:} If [Destination] is a Joker, do nothing.
Otherwise copy the found argument and the face-down
cards directly below it and put it on top of [Name (stack exclusive) Destination].
If [Name (stack inclusive) Origin] is the stack, instead copy the found argument and the
face-down cards directly above it, reverse all of those cards,
and put it on top of [Name (stack exclusive) Destination].

@italic{Clubs: Copy Up To:} If [Destination] is a Joker, do nothing.
Otherwise, copy all the cards above and including
the found argument, and put it on top of [Name (stack exclusive Destination].
If [Name (stack inclusive) Origin] is the stack, reverse all of those cards before
putting it on top of [Name (stack exclusive Destination].

@italic{Hearts: Move One:} Remove the the found argument and the face-down
cards directly below it from [Name (stack inclusive) Origin]: if [Destination]
is a Joker, the removed cards go nowhere, otherwise
put them on top of [Name (stack exclusive) Destination].
If [Name (stack inclusive) Origin] is the stack,
reverse the found cards before moving them.

@italic{Diamonds: Move Up To:} Remove all the cards above and including
the found argument, as well as the face down cards directly below it.
If [Destination] is a Joker, the removed cards go nowhere,
otherwise put them on top of [Name (stack exclusive) Destination].
If [Name (stack inclusive) Origin] is the stack, reverse all of those cards before
putting them on top of [Name (stack exclusive) Destination].

@italic{Joker: Copy Whole:} If [Destination] is a Joker, delete
[Name (stack inclusive) Origin].
Otherwise copy [Name (stack inclusive) Origin] and put it on top
of [Name (stack exclusive) Destination].
If [Name (stack inclusive) Origin] is the stack,
reverse the copy before putting in on top of [Name (stack exclusive) Destination]


@subsection{Kc}

@italic{Currently does nothing. Will be added in the future.}


@subsection{Kh}

@bold{Form: [Deck], Ks}

@bold{Instruction:} Flip [Name (stack inclusive) Deck] over.


@subsection{Kd}

@bold{Form: [Deck], Kd}

@bold{Instruction:} Shuffle [Name (stack inclusive) Deck].
