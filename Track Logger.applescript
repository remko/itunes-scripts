(*
	'Track Logger'
	Remko Tronçon (http://el-tramo.be)
	
	This script logs the currently playing track to ~/.psi/tune.
  It is intended for using with Psi (http://psi-im.org), which broadcasts the
  currently playing tune.
*)

global frequency -- how often we should check iTunes
global data_file -- The file containing our data
set data_file to (alias ((path to home folder as text) & ".psi:")) & "tune"
set frequency to 10

on idle
	tell application "Finder"
		if (get name of every process) contains "iTunes" then
			tell application "iTunes"
				if player state is playing then
					try
						my writeTrack()
					on error -- playing but not started track yet
						my writeTrack()
					end try
				else
					my writeStop()
					set idle_time to 15
				end if
			end tell
			set idle_time to frequency
		else
			writeStop()
			set idle_time to 60
		end if
	end tell
end idle

on writeTrack()
	tell application "iTunes"
		set theTitle to name of current track
		set theArtist to artist of current track
		set theAlbum to album of current track
		set theTrack to track number of current track as text
		set theTime to time of current track
	end tell
	try
		set the target_file to the data_file as text
		set the open_target_file to open for access file target_file with write permission
		set eof of the open_target_file to 0
		write theTitle & "
" & theArtist & "
" & theAlbum & "
" & theTrack & "
" & theTime & "
" to the open_target_file as «class utf8»
		close access the open_target_file
		return true
	on error error_message number error_number
		display dialog error_message
		return error_message
	end try
end writeTrack

on writeStop()
	try
		set the target_file to the data_file as text
		set the open_target_file to open for access file target_file with write permission
		set eof of the open_target_file to 0
		close access the open_target_file
		return true
	on error error_message number error_number
		display dialog error_message
	end try
end writeStop

on quit
	my writeStop()
	continue quit
end quit
