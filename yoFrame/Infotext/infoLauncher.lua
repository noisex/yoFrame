local L, yo, N = unpack( select( 2, ...))

--if not yo.InfoTexts.enable then return end

local infoText = N.InfoTexts

infoText.texts["1empty"]	= "-none-"
infoText.infosSorted 	= {}

function infoText:infoLauncher()

	wipe( infoText.infosSorted)

	for infosName in pairs( infoText.texts) do

		if not infoText.infos then break end

		local infosObj  = infoText.infos[infosName]
		if infosObj and infosObj.Disable then
			infosObj.Disable( infosObj)
		end
		table.insert( infoText.infosSorted, infosName)
	end

	table.sort( infoText.infosSorted)

	for i = 1, yo.InfoTexts.countLeft do
		local infosName = yo.InfoTexts["left" .. i]

		if not infoText.infos then break end

		local infosObj  = infoText.infos[infosName]
		if infosObj and infosObj.Enable and yo.InfoTexts.enable then
			infosObj.parent 		= LeftInfoPanel
			infosObj.parentCount	= yo.InfoTexts.countLeft
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
			infosObj.parent 		= RightInfoPanel
			infosObj.parentCount	= yo.InfoTexts.countRight
			infosObj.shift 			= infoText.shift
			infosObj.index 			= i
			infosObj.Enable( infosObj)
		end
	end
end

infoText:infoLauncher()