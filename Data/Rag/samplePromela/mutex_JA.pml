/*
NAME
  mutex_L_JA : J. Anderson's nonatomic algorithm

DESCRIPTION
  Mutual exclusion with nonatomic operations by J. Anderson.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/19(Tue) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

typedef BitSet {
  bit _P[N];
  bit _Q[N];
  bit _T[N];
};

BitSet bs[N];
byte in_cs;

init {
  atomic {
    byte i = 0;

    do
    :: i < N -> run P(i); i++;
    :: else  -> break;
    od;
  }
}

inline Entry_1(u, v, x) {
  bs[u]._P[v] = true;
  bs[u]._Q[v] = true;
  x = bs[v]._T[u];
  bs[u]._T[v] = x;
  if
  :: x == true  -> bs[u]._P[v] = false; if :: bs[v]._P[u] == false; fi;
  :: x == false -> bs[u]._Q[v] = false; if :: bs[v]._Q[u] == false; fi;
  fi;
}

inline Entry_2(v, u, x) {
  bs[v]._P[u] = true;
  bs[v]._Q[u] = true;
  x = 1 - bs[u]._T[v];
  bs[v]._T[u] = x;
  if
  :: x == true  -> bs[v]._Q[u] = false; if :: bs[u]._P[v] == false; fi;
  :: x == false -> bs[v]._P[u] = false; if :: bs[u]._Q[v] == false; fi;
  fi;
}

inline Exit(u, v) {
  bs[u]._P[v] = false;
  bs[u]._Q[v] = false;
}

proctype P(byte id) {
  byte i;
  bit x;
NonCritical:
  i = 0;
Wait:
  do
  :: i < id -> Entry_2(id, i, x); i++;
  :: i == id -> i++;
  :: i > id && i < N -> Entry_1(id, i, x); i++;
  :: atomic { i == N -> in_cs++; } break;
  od;
Critical:
  atomic { in_cs--; i = 0; }
  do
  :: i < N && i != id -> Exit(id, i); i++;
  :: i == id -> i++;
  :: i == N -> goto NonCritical;
  od;
}
