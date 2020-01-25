#ifndef STATE
#   define EXECUTE 0
#   define SKIP 1
#   define RSKIP 2
#   define STATE EXECUTE
#endif
#
#if STATE == EXECUTE
execute: cell = T0, cell index = Tr
#   if C0 == '>'
opcode >
#       include "shift_T.h"
#   elif C0 == '<'
opcode <
#       include "rshift_T.h"
#   elif C0 == '+'
opcode +
#       define T0_NEXT ((T0 + 1) & 0xff)
#       include "literals/T0.h"
#   elif C0 == '-'
opcode -
#       define T0_NEXT ((T0 - 1) & 0xff)
#       include "literals/T0.h"
#   elif C0 == '.'
opcode .
#       define PRINT T0
#       include "print.h"
#   elif C0 == ','
opcode ,
#       define T0_NEXT I0
#       include "literals/T0.h"
#       include "shift_I.h"
#   elif C0 == '['
opcode [
#       if T0 == 0
#           undef STATE
#           define STATE SKIP
#           define NESTCOUNT 0
#       endif
#   elif C0 == ']'
opcode ]
#       if T0 != 0
#           undef STATE
#           define STATE RSKIP
#           define NESTCOUNT 0
#           include "rshift_C.h"
#       endif
#   elif C0 == 'X'
opcode X
#       define HALT 1
#   endif
#   if STATE == EXECUTE
#       include "shift_C.h"
#   endif
#elif STATE == SKIP
skip: nest = NESTCOUNT
#   if C0 == '['
skipcode [
#       define NESTCOUNT_NEXT (NESTCOUNT + 1)
#       include "literals/NESTCOUNT.h"
#   elif C0 == ']'
skipcode ]
#       if NESTCOUNT == 0
#           undef STATE
#           define STATE EXECUTE
#           undef NESTCOUNT
#       else
#           define NESTCOUNT_NEXT (NESTCOUNT - 1)
#           include "literals/NESTCOUNT.h"
#       endif
#   endif
#   include "shift_C.h"
#elif STATE == RSKIP
rskip: nest = NESTCOUNT
#   if C0 == ']'
rskipcode ]
#       define NESTCOUNT_NEXT (NESTCOUNT + 1)
#       include "literals/NESTCOUNT.h"
#   elif C0 == '['
rskipcode [
#       if NESTCOUNT == 0
#           undef STATE
#           define STATE EXECUTE
#           undef NESTCOUNT
#       else
#           define NESTCOUNT_NEXT (NESTCOUNT - 1)
#           include "literals/NESTCOUNT.h"
#       endif
#   endif
#   if STATE == RSKIP
#       include "rshift_C.h"
#   endif
#endif
#
#if Cc == 0
#   undef HALT
#   define HALT 1
#endif
