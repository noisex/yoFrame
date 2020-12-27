local L, yo, n = unpack( select( 2, ...))

--if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts

function infoText:infoLauncher()

	for infosName in pairs( infoText.texts) do

		if not infoText.infos then break end

		local infosObj  = infoText.infos[infosName]
		if infosObj and infosObj.Disable then
			infosObj.Disable( infosObj)
		end
	end

	table.sort( infoText.infosSorted)

	for i = 1, yo.InfoTexts.countLeft do
		local infosName = yo.InfoTexts["left" .. i]

		if not infoText.infos then break end

		local infosObj  = infoText.infos[infosName]
		if infosObj and infosObj.Enable and yo.InfoTexts.enable then
			infosObj.parent 		= n.infoTexts.LeftInfoPanel
			infosObj.parentCount	= yo.InfoTexts.countLeft
			infosObj.textSide		= ( i == 1 and "LEFT") or ( i == yo.InfoTexts.countLeft and "RIGHT") or "CENTER"
			infosObj.textShift		= ( i == 1 and 5) or (i == yo.InfoTexts.countLeft and -15) or 0
			infosObj.shift 			= infoText.shift
			infosObj.index 			= i
			infosObj.Enable( infosObj)
		end
	end

	for i = 1, yo.InfoTexts.countRight do
		local infosName = yo.InfoTexts["right" .. i]

		if not infoText.infos then break end

		local infosObj  = infoText.infos[infosName]
		if infosObj and infosObj.Enable and yo.InfoTexts.enable then
			infosObj.parent 		= n.infoTexts.RightInfoPanel
			infosObj.parentCount	= yo.InfoTexts.countRight
			infosObj.shift 			= infoText.shift
			infosObj.textSide		= ( i == 1 and "LEFT") or ( i == yo.InfoTexts.countRight and "RIGHT") or "CENTER"
			infosObj.textShift		= ( i == 1 and 5) or (i == yo.InfoTexts.countRight and -15) or 0
			infosObj.index 			= i
			infosObj.Enable( infosObj)
		end
	end
end

infoText:infoLauncher()