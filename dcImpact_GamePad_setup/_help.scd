/*
to change: init::
	- root folder
	- auto read subfolders !!
	- auto check for valid mono files
	- D'n'D folder
	- set chan for patches in zuordnungen !
*/


Impact.help file




Buffer based sounds:	

	bufPlay:	(0, 1)
		LX	segment position of buffer played
		LY	segment size of buffer played. in middle pos it is equal to sample length
		RX	pitch
		RY	amp
		ut12 reverse direction of sample playback
		ut11 + RY		lag: smoothes out pitch movements
		
		ut13	change buffer: previous buffer from the list
		ut14	change buffer: next buffer from the list
	
	bufGranulator:	(2, 3)
	
		LX	progress. 
				middle pos is normal progress, 
				half left is freeze. around here you get the value posted: 0 is absolute freeze,
				all left is 1x reverse,
				all right is 3x fast forward.
		LY	pitch
		RX	density. coresponds to length of grains. 
				right of middle you get overlaps,
				left of middle you hear gaps between the grains
		RY	number of grains per second
		ut12 reverse direction of sample playback.
		
		ut11 + RY		amp (!)
		ut11 + RX		lag
		ut12 + LX		random position in the sample for the grain
		ut12 + LY		time jitter. breaks the mertonomical sequence of the 
	
		ut13	change buffer: previous buffer from the list
		ut14	change buffer: next buffer from the list


Synthetic sounds:
	
	formSing:		(4)
		LX	root Freq
		LY	formant Filter Freq
		RX	number of harmonics
		RY	amp
		ut12	Frequency random deviation; in semitones


	allArmSoft:	(5)
		LX	topFreq
		LY	diveFreq
		RX	filter Freq
		RY	amp
		
	
	kiteHi:		(7)
		LX	hack
		LY	filter Freq
		RX	move
		RY	amp
	
	
q[\post] = true;
q[\post] = false;


////////////////////////////////////////////////////////////////////////////

Buffers:

Buffers for Buffer-based synths (bufferPlayer, Granulator) are stored in a flat list where they can be indexed fon 0 to n. By default, there are 2 Buffers reserved for live-sampling: jam0 and jam1; they are always the first 2 buffers in the list.
See below for how to load samples from one of your samplefolders to RAM.


////////////////////////////////////////////////////////////////////////////

to  load samples:

ut12 	activates a shift for the left 4 buttons (hatswitch). press it and keep it pressed:
by pressing the N/S keys (up or down) , you select a subfolder of samples to choose from.
watch the post window. 
if you like the currently selected subfolder, you press the EAST button (right), to load the content of this subfolder, usually a few mono-sanples, into memory, overwriting the buffers that might have been there before.
by pressing the WEST (left) button, you ADD this subfolder to the existing buffers in memory. Do this only when you have enough RAM available!

////////////////////////////////////////////////////////////////////////////

recording:

ut11		shifts 