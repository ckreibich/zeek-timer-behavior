A look at Zeek's table expiration timers
========================================

This Zeek script shows the behavior of `&create_expire` and `&expire_func` over
time. It traces the insertion of elements into a table using those attributes,
and reports their time of removal with actual resulting lifespan.

A line of the form

     3.282  + 4

means that at 3.282 seconds into the run a table element with key 4 got
inserted, and

    10.282  - 2,   9.000s

means that at 10.282 seconds into the run the table element with key 2 got
removed, having spent 9.0 seconds in the table.

By default it uses `&create_expire=5 secs`, for the following progression:

    $ zeek ./table_create_expire.zeek
     0.281  + 1
     1.281  + 2
     2.282  + 3
     3.282  + 4
     4.282  + 5
     5.282  + 6
     6.283  + 7
     7.283  + 8
     8.283  + 9
     9.284  +10
    10.282  - 2,   9.000s
    10.282  - 6,   4.999s
    10.282  - 3,   8.000s
    10.282  - 1,  10.001s
    10.282  - 4,   7.000s
    10.282  - 5,   6.000s
    10.285  +11
    11.285  +12
    12.286  +13
    13.286  +14
    14.286  +15
    15.287  +16
    16.287  +17
    17.288  +18
    18.288  +19
    19.288  +20
    20.282  -16,   4.995s
    20.282  - 8,  12.999s
    20.282  - 9,  11.999s
    20.282  -15,   5.996s
    20.282  -13,   7.996s
    20.282  - 7,  13.999s
    20.282  -10,  10.998s
    20.282  -14,   6.996s
    20.282  -12,   8.997s
    20.282  -11,   9.997s
    20.289  +21
    ...

You can see how timer expiration is batched at time of timer inspection
(governed by the `table_expire_interval` constant, predefined to 10 secs), that
the order of member expiration is not deterministic, and how each member's
lifespan is bounded by the given `&create_expire` interval as a lower bound and
`&create_expire + table_expire_interval` as an upper bound.

Try overriding the constants, for example:

    $ zeek ./table_create_expire.zeek expire_ival=1sec table_expire_interval=5sec
