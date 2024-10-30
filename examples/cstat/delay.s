/* This Assembly source file implements
   delay() for multiple target architectures */
   
        NAME delay

        PUBLIC _delay
        PUBLIC delay

#if defined(__IASMARM__)
        SECTION `.text`:CODE:NOROOT(2)
        THUMB
#elif defined(__IASMAVR__)
        RSEG CODE:CODE:NOROOT(1)
#elif defined(__IASMRISCV__)
        SECTION `.text`:CODE:REORDER:NOROOT(2)
        CODE
#elif defined(__IASMRL78__) || defined(__IASMRX__)
        SECTION `.text`:CODE:NOROOT(0)
        CODE
#endif


_delay:
delay:
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        BX LR

        END

