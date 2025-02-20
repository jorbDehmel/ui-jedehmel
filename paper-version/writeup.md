
# Proposal and Paper Mockup: JKnit GUI
Jordan Dehmel, UI Design, Spring '25, CMU

## Background

A few years ago, I was in "methods of applied mathematics 2"
with Dr. Gustafson in the CMU math department. In that class we
used `R` markdown (`rmd`), which is a beautiful language
regrettably embedded in one of my least favorite pieces of
software (`rstudio`). At the time I was using a computer with
16gb of storage, which `rstudio` took up a large portion of. Out
of frustration I wrote
[`jknit`](https://github.com/jorbDehmel/jknit), a ~150kb CLI
FOSS system for knitting `jmd` (a superset of `rmd`) documents.
Dr. Gustafson suggested that a cross-platform GUI version would
be a good option for usage in the class.

## Motivation and Users

This program is aimed at mathematicians and computer scientists
who want to create documents with running code in them (as per
Knuth's idea of "literate programming") without being limited by
bloated closed-source software. This differs from the use case
of jupyter notebooks, which usually aims to run interactively:
The goal of `jknit` is to compile to static documentation. The
GUI aims to be lightweight and intuitive, specifically targeting
those who do not have CLI experience (EG math students).

## Customers

The "customers" of this software would be universities. These
would be the institutions installing the software, even if no
money is changing hands. For the sake of IT, the GUI should aim
to be dependency-light, easily-managed, and minimally-invasive.

## Bias

As a computer scientist, I will almost certainly overestimate
the average math student's understanding of CS operations (EG
using the command line). Thus, rigorous documentation and
testing, as well as intuitive design will be necessary.
