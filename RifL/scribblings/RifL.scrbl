#lang scribble/manual

@title{RifL: a playing card stack language}
@author{Jesse P. Hamlin-Navias}

@defmodulelang[RifL]

RifL is a tactile auto-imperative esoteric coding language.

Tactile means that RifL can be fully represented with real-world
objects: RifL is written in playing cards. You can spread cards out
on a table and perform RifL code by hand.

Auto-imperative means that RifL code sets a state, and then
augments its own state. The cards represent information, but
can also represent instruction to transform that information.

Esoteric means that the language is not meant for practical use.
RifL is intended as a educational tool, to teach to students who
learn best physically. It is also meant as an affordable method of introducing
programming concepts. RifL can help teach computer memory and algorithms.

If you wish to run RifL code physically, you will need a bunch
of decks of cards (they don't need to all be the same brand, size, or
even complete decks, just make sure you have Jokers), as well
as masking tape, a sharpie, and the documentation below.

The first chapter, Introduction, teaches you how to read,
write, and execute RifL code both physically and on a computer.
The second chapter, Data, explains how RifL turns cards into
numbers, words, and references. The final chapter, Royals, thoroughly covers
how RifL can manipulate that data.

@include-section["Introduction.scrbl"]
@include-section["Data.scrbl"]
@include-section["Royal.scrbl"]

