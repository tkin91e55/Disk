Known issues:

(1) Need to have a algoritm to semi-auto generator disk pattern in standard
(2) Need to control the audio playing accurately
(3) (Solved) Need to have back side of the disk, use CircularDiskOutput.blend in DiskUV to modify
(4) Need to add state machine to control the flow of operation, mixing animation and sound properly
(5) Need to fix the inclined reflection problem, maybe even rotation.

Next Things To Do:

31/8/2014:
(1) update the Disk.simp
(2) it should be the disk creates cmd objects , and the the diskcontroller to handle the cmds (done)

7/9/2014:
(1) (Solved) there is problem that index of the diskcontroller iterator is not elegantly mechanized and not supporting the middle cancel function, i.e. when disk order a redo/undo command, index immediately done shifting already, even the disk state is not yet. Sugget using looking for target cmd and enusre the index will only do the shifting after confirm the target cmd will be executed.
So may just separate the current MoveNext() function to bool CanMoveNext() and void MoveNext() functions etc.

12/9/2014:
(1) relativeDiskSegment is not working safely for clear memory function.

2/11/2014:
(1) add web host page for hosting the web build, no concrete plan yet

