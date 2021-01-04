: boot
    begin
        d# 3
        begin
            dup io@
            over
            h# 10 + io!
            d# -1 +
            dup d# 0 <
        until
    again
;

: <end> ;