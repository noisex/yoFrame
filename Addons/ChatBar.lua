local L, yo = unpack( select( 2, ...))

local height = 13

local function BEnter(self)
	--local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
	self:SetBackdropBorderColor(myColor.r, myColor.g, myColor.b)
	self:GetParent():SetAlpha(1)
end
 
local function BLeave(self)
	self:SetBackdropBorderColor(.15,.15,.15, .9)
	self:GetParent():SetAlpha(.05)
end

local function framechat(f)
	local mult = 1

	f:SetWidth(height)
	f:SetHeight(height)

	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = mult, right = mult, top = mult, bottom = mult} 
	})
	f:RegisterForClicks('AnyUp')
	f:SetBackdropBorderColor(.15,.15,.15, .9)	
	f:SetScript("OnEnter", BEnter)
	f:SetScript("OnLeave", BLeave)
end

local text

local function S(button)
	text = ChatFrame1EditBox:GetText()
--	print( text)
	ChatFrame_OpenChat("/s ".. text, SELECTED_DOCK_FRAME);	
end
local function W(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/w ".. text, SELECTED_DOCK_FRAME);		
end
local function G(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/g ".. text, SELECTED_DOCK_FRAME);	
end
local function O(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/rw ".. text, SELECTED_DOCK_FRAME);		
end
local function P(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/p ".. text, SELECTED_DOCK_FRAME);	
end
local function R(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/raid ".. text, SELECTED_DOCK_FRAME);
end
local function GE(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/1 ".. text, SELECTED_DOCK_FRAME);		
end
local function T(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/2 ".. text, SELECTED_DOCK_FRAME);		
end
local function D(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/3 ".. text, SELECTED_DOCK_FRAME);	
end
local function Y(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/y ".. text, SELECTED_DOCK_FRAME);		
end
local function M(button)
	text = ChatFrame1EditBox:GetText()
	ChatFrame_OpenChat("/me ".. text, SELECTED_DOCK_FRAME);		
end

local function CBStyle( self)
	
	local chatbar = CreateFrame('Frame', 'yo_ChatBarFrame', UIParent)
	chatbar:SetPoint('RIGHT', LeftDataPanel, 'RIGHT', -5, -5)
	chatbar:SetSize( height, height * 11)
	chatbar:SetAlpha(0.05)

	chatbar.s = CreateFrame('Button', nil, chatbar)
	chatbar.s:SetPoint("TOPLEFT", chatbar, "TOPLEFT", 0, 0)
	framechat(chatbar.s)
	chatbar.s:SetBackdropColor(1,1,1,1)
	chatbar.s:SetScript('OnClick', S)		
	
	chatbar.w = CreateFrame('Button', nil, chatbar)
	chatbar.w:SetPoint("TOP", chatbar.s, "BOTTOM", 0, 0)
	framechat(chatbar.w)
	chatbar.w:SetBackdropColor(.7,.33,.82, 1) 
	chatbar.w:SetScript('OnClick', W)
	
    chatbar.g = CreateFrame('Button', nil, chatbar)
	chatbar.g:SetPoint("TOP", chatbar.w, "BOTTOM", 0, 0)
	framechat(chatbar.g)
	chatbar.g:SetBackdropColor(0,.8,0,1) 
	chatbar.g:SetScript('OnClick', G)	
		
    chatbar.o = CreateFrame('Button', nil, chatbar)
	chatbar.o:SetPoint("TOP", chatbar.g, "BOTTOM", 0, 0)
	framechat(chatbar.o)
	chatbar.o:SetBackdropColor( 0.6, 0.1, 0, 1) 
	chatbar.o:SetScript('OnClick', O)	
		
    chatbar.r = CreateFrame('Button', nil, chatbar)
	chatbar.r:SetPoint("TOP", chatbar.o, "BOTTOM", 0, 0)
	framechat(chatbar.r)
	chatbar.r:SetBackdropColor( 1, .4,.1, 1)
    chatbar.r:SetScript('OnClick', R)	
    	
	chatbar.p = CreateFrame('Button', nil, chatbar)
	chatbar.p:SetPoint("TOP", chatbar.r, "BOTTOM", 0, 0)
	framechat(chatbar.p)
	chatbar.p:SetBackdropColor(.11,.5,.7, 1)
    chatbar.p:SetScript('OnClick', P)	
	
	chatbar.ge = CreateFrame('Button', nil, chatbar)
	chatbar.ge:SetPoint("TOP", chatbar.p, "BOTTOM", 0, 0)
	framechat(chatbar.ge)
	chatbar.ge:SetBackdropColor(.7,.7,0, 1)
    chatbar.ge:SetScript('OnClick', GE)
	
    chatbar.t = CreateFrame('Button', nil, chatbar)
	chatbar.t:SetPoint("TOP", chatbar.ge, "BOTTOM", 0, 0)
	framechat(chatbar.t)
	chatbar.t:SetBackdropColor(.7,.7,0, 1)
   	chatbar.t:SetScript('OnClick', T)
	
    chatbar.d = CreateFrame('Button', nil, chatbar)
	chatbar.d:SetPoint("TOP", chatbar.t, "BOTTOM", 0, 0)
	framechat(chatbar.d)
	chatbar.d:SetBackdropColor(.7,.7,0, 1)
    chatbar.d:SetScript('OnClick', D)
	
	chatbar.y = CreateFrame('Button', nil, chatbar)
	chatbar.y:SetPoint("TOP", chatbar.d, "BOTTOM", 0, 0)
	framechat(chatbar.y)
	chatbar.y:SetBackdropColor(1,0,0, 1)
    chatbar.y:SetScript('OnClick', Y)	
   
   	chatbar.m = CreateFrame('Button', nil, chatbar)
	chatbar.m:SetPoint("TOP", chatbar.y, "BOTTOM", 0, 0)
	framechat(chatbar.m)
	chatbar.m:SetBackdropColor( 1,0.5, 0.1, 1)
    chatbar.m:SetScript('OnClick', M)
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Chat.BarChat then return end
	
	CBStyle( self)
end)
