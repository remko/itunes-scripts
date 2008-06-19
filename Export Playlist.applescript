(*
	'Export Playlist'
	Remko Tronçon (http://el-tramo.be)
	
	This script exports all files from the current playlist to 
	a folder pointed to by the user. The files are named according 
	to the scheme '<index> - <artist> - <title>.<type>', which
	ensures that the alphabetical order is the same as the playlist order.
*)

tell application "System Events"
	if (get name of every process) contains "iTunes" then
		tell application "iTunes"
			set targetFolder to (choose folder name with prompt "Select the folder to export your playlist to")
			set allTracks to every track of front window's view
			set widthOfIndex to length of ((length of allTracks) as string)
			repeat with theTrack in allTracks
				set trackName to name of theTrack
				set trackArtist to artist of theTrack
				set trackIndex to my padNumber(index of theTrack, widthOfIndex)
				set trackFile to location of theTrack
				tell application "Finder"
					duplicate trackFile to targetFolder
					set trackFileName to name of trackFile
					set trackType to name extension of trackFile
					set trackNewFileName to (trackIndex & " - " & trackArtist & " - " & trackName & "." & trackType)
					set name of (alias ((targetFolder as string) & trackFileName)) to trackNewFileName
				end tell
			end repeat
		end tell
	end if
end tell

on padNumber(theNumber, theWidth)
	set numberText to (theNumber as string)
	set padding to theWidth - (length of numberText)
	repeat padding times
		set numberText to "0" & numberText
	end repeat
	return numberText
end padNumber