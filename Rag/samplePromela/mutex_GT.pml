/*
NAME
  mutex_GT : Graunke and Thakkar's mutex algorithm

DESCRIPTION
  array-based queue-lock mutual exclusion algorithm by Graunke and Thakkar.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/15(Fri) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

typedef Tailtype {
  byte last;
  bit b;
};

bit Slots[N];
Tailtype Tail;
byte in_cs;

init {
  atomic {
    byte i = 0;
    Tail.last = 0;
    Tail.b    = false;

    do
    :: i < N -> run P(i); Slots[i] = true; i++;
    :: else -> break;
    od
  }
}

proctype P(byte id) {
  byte prev;
  bit b, temp;
NonCritical:
  atomic {
    prev = Tail.last; b = Tail.b;
    Tail.last = id; Tail.b = Slots[id];
  }
Wait:
  if
  :: atomic { Slots[prev] != b; in_cs++; }
  fi;
Critical:
  d_step { temp = 1 - Slots[id]; in_cs--; }
  Slots[id] = temp;
  goto NonCritical;
}
