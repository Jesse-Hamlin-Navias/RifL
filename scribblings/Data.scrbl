#lang scribble/manual

@title{Data}

RifL code is broken up into @seclink["Arguments"]{arguments}. Each
@seclink["Arguments"]{argument} is either:

@itemlist[@item{A sequence of number cards (A-10)}
          @item{A single @seclink["Jokers"]{Joker}}
          @item{A single @secref{Royal} card}]

Data is a specific type of @seclink["Arguments"]{argument}; either
a sequence of number cards, or a single @seclink["Jokers"]{Joker}.
Each data @seclink["Arguments"]{argument} can be interpreted in different
ways, depending on the context.
This chapter will cover all the different ways
data can be interpreted, as well as a guide to the most common
contexts in which that interpretation will happen.

@section{Leading Suit}
Many Royal cards rely on the suit of a data @seclink["Arguments"]{argument}.
However, a sequence of number cards can have different
suits in it:

@verbatim{
0s 1c 2h 3d
          }

To resolve this, when the documentation refers to
the suit of a sequence of number cards, the suit
of the top card of the sequence is all that matters.
In the above example, the suit of the sequence
would be spades, since the top cards is 0s.

A detail to remember is that @seclink["Arguments"]{arguments} that go
into the @seclink["The_Stack"]{stack} get reversed. To account for this,
the leading suit
of an @seclink["Arguments"]{argument} in the @seclink["The_Stack"]{stack} is determined
by the bottom card of the sequence, not the top.

@section{Jokers}
Jokers, like the number cards, represent information, but are wild cards, and are interpreted
differently in different contexts, and are not valid in all contexts.
Jokers is somewhat comparable to the 'null value found in other programming languages,
although that comparison sells short the usefulness of the Joker.

Jokers act like a 5th suit. When the documentation uses the suit of an
argument, the interpretation of a Joker will also be listed. Sometimes a Joker in certain
contexts will result in an error, which stops the code from running

@section{Interpretations}

@subsection{Cards}
This is the default interpretation if
none is listed.
No interpretation is made.
The @seclink["Arguments"]{argument} is taken literally
as the cards in the sequence.
This is most often used when the suit
of an @seclink["Arguments"]{argument} is the only thing that matters.

@subsection{Name}

Interprets the card sequence as the name of a deck space
on the table. The sequence R represents the @seclink["The_Stack"]{stack}.
Name interpretations are either @seclink["The_Stack"]{stack} inclusive and
will accept R, others are @seclink["The_Stack"]{stack} exclusive and
will not accept R.

@verbatim{
1s > the 1 of spades deck
2c 0c 3c > the 203 of clubs deck
R > the stack
          }

A card sequence that has more than one suit type in
it is invalid for a name. A card sequence that starts
with a ten card is invalid for a name, unless the
sequence is a single ten card.

@verbatim{
2c 0s 3s > error
0s 1s > error
0s 0s > error
0s > 0 of spades deck
          }

@subsection{Integer}
Interprets the card sequence as a zero or positive whole number,
unless the @seclink["Leading_Suit"]{leading suit} is clubs, in which case the
number is a negative zero or negative whole number.

@verbatim{
3s > 3
3c > -3
3h > 3
3d > 3
0s 4c > 4
0c 4s > -4
0s > 0
0c > -0
          }

R is invalid for Integers.

@verbatim{
R > error
          }

When converting integers into cards, RifL
converts zero and positive integers
into all spades, but converts negative
numbers into all clubs.

@subsection{Real Number}
Interprets the card sequence as zero or a positive whole number,
unless the @seclink["Leading_Suit"]{leading suit} is spades or clubs, and the suit
of a card in the sequence is diamonds. In that case,
the first diamonds card represents the decimal point
(and not a digit), and all cards after the first diamonds
card are the fractional part of the number.
If the @seclink["Leading_Suit"]{leading suit} of a real number is clubs, the
number is negative.

@verbatim{
3s > 3
3s 0d > 3
3s 0d 0s > 3
3s 0d 1s 4s 1s 5s 9s > 3.14159
3c 0d 1c 4c 1c 5c 9c > -3.14159
3h 0d 1h 4h 1h 5h 9h > 3,014,159
3d 0d 1d 4d 1d 5d 9d > 3,014,159
0s 0d 1c             > 0.1
0s 0d 0d 1c          > 0.01
0d 0d 1c             > 1
          }

R is invalid for a real number.

@verbatim{
R > error
          }

When converting numbers into cards, RifL
always converts whole numbers into the @secref{Integer}
card form. Positive non-whole numbers get
converted into spades, with the decimal point
being a 0d. Negative non-whole numbers get
converted into clubs, with the decimal
point being a 0d.

@subsection{Boolean}
The 0d, and any data @seclink["Arguments"]{argument}
with only tens cards that
has a @seclink["Leading_Suit"]{leading suit} of diamonds evaluates as #false.
R evaluates as null. All other @seclink["Arguments"]{arguments}
evalutate as #true.

@verbatim{
0s > #t
0c > #t
0h > #t
0d > #f
0d 0s 0h 0c > #f
0d 0s 0h 1c > #t
1d > #t
R  > null
}

When converting booleans into cards, RifL
converts true into 1d, and false into
0d.

@subsection{Character}
Interprets the argument as zero or a positive
whole number, and uses that number to reference
the @hyperlink["https://en.wikipedia.org/wiki/ASCII"]{ASCII}.

@verbatim{
6h 5h > 'A'
1h 2h 2h > 'z'
}

Inteprets R as no character.
@verbatim{
R > ''
}

Character interpretation is only used with card sequences
that have a @seclink["Leading_Suit"]{leading suit} of hearts, or with @secref{Jokers}.

When converting characters into cards, RifL
converts the character into its @hyperlink["https://en.wikipedia.org/wiki/ASCII"]{ASCII} number,
and then turns that number into a hearts
sequence.