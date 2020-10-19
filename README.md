
Processing fadecandy testcard
-----------------------------

This is a sketch and fadecandy server json file to allow testing of separate 2 x 2 grids before they are brought together to form a 4 x 3 grid.

WIP: fadecandy BTESVDGCYOEXZNCX (green, bottom left) is configured.

Cmd Line
--------

rem Windows

    Processing_fadecandy_testcard\bin>fcserver.exe fcserver-4x3.json

    path %PATH%;D:\Apps\processing-3.5.4
    processing-java.exe --sketch=%cd%\Processing_fadecandy_testcard --run exit=60

\# raspi (vnc)

    processing-java --sketch=./Processing_fadecandy_testcard --run exit=60

\# raspi (ssh i.e. headless)

    xvfb-run processing-java --sketch=./Processing_fadecandy_testcard --run exit=60

