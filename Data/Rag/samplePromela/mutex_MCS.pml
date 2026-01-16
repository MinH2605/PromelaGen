/*
NAME
  mutex_MCS : Mellor-Crummey and Scott's mutex algorithm

DESCRIPTION
  linked-list-based queue-lock mutual exclusion algorithm
  by Mellor-Crummey and Scott.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/15(Fri) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

#define NIL  255

typedef Qnode {
  byte next;
  bit locked;
};

Qnode Nodes[N];
byte Tail;
byte in_cs;

init {
  atomic {
    byte i = 0;
    Tail = NIL;

    do
    :: i < N -> run P(i); Nodes[i].next = NIL; i++;
    :: else  -> break;
    od
  }
}

proctype P(byte id) {
  byte pred;
NonCritical:
  Nodes[id].next = NIL;
  d_step { pred = Tail; Tail = id; }
Wait:
  if
  :: pred != NIL ->
     Nodes[id].locked = true;
     Nodes[pred].next = id;
     if
     :: d_step { Nodes[id].locked == false; in_cs++; }
     fi;
  :: atomic { pred == NIL -> in_cs++; }
  fi;
Critical:
  if
  :: Nodes[id].next == NIL ->
     if
     :: atomic { Tail == id -> Tail = NIL; in_cs--; }
        goto NonCritical;
     :: Tail != id ->
        if
        :: Nodes[id].next != NIL;
        fi;
     fi;
  :: Nodes[id].next != NIL;
  fi;
  atomic { Nodes[Nodes[id].next].locked = false; in_cs--; }
  goto NonCritical;
}
