/*
NAME
  mutex_QL : queue-lock mutex algorithm

DESCRIPTION
  simple queue-lock mutual exclusion algorithm.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/01(Fri) Added ERROR option
  2008/07/29(Tue) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

#ifdef ERROR
#define WAIT_PLACE   ((my_place+(N-1))%N)
#else
#define WAIT_PLACE   (my_place)
#endif

#define HAS_LOCK     1
#define MUST_WAIT    0

bit flags[N];
byte next = 0;
byte in_cs = 0;

init {
  atomic {
    byte i;
    flags[0] = HAS_LOCK;

    do
    :: i < N -> run P(); i++;
    :: else  -> break;
    od
  }
}

proctype P() {
  byte my_place = 0;
NonCritical:
  atomic { my_place = next; next = (next+1) % N; }
Wait:
  if
  :: flags[my_place] == HAS_LOCK;
     atomic { flags[WAIT_PLACE] = MUST_WAIT; in_cs++; }
  fi;
Critical:
  atomic { flags[(my_place+1)%N] = HAS_LOCK; in_cs--; }
  goto NonCritical;
}
