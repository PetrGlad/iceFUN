: boot
    begin
        3
        begin
            dup io@
            dup h# a + io!
            -1 +
            dup 0 <
        until
    again
;

: <end> ;