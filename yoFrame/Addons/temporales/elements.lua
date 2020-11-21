local frame_metatable = {
	__index = CreateFrame('Button')
}
Private.frame_metatable = frame_metatable

for k, v in next, {
	--[[ frame:EnableElement(name, unit)
	Used to activate an element for the given unit frame.

	* self - unit frame for which the element should be enabled
	* name - name of the element to be enabled (string)
	* unit - unit to be passed to the element's Enable function. Defaults to the frame's unit (string?)
	--]]
	EnableElement = function(self, name, unit)
		argcheck(name, 2, 'string')
		argcheck(unit, 3, 'string', 'nil')

		local element = elements[name]
		if(not element or self:IsElementEnabled(name)) then return end

		if(element.enable(self, unit or self.unit)) then
			activeElements[self][name] = true

			if(element.update) then
				table.insert(self.__elements, element.update)
			end
		end
	end,

	--[[ frame:DisableElement(name)
	Used to deactivate an element for the given unit frame.

	* self - unit frame for which the element should be disabled
	* name - name of the element to be disabled (string)
	--]]
	DisableElement = function(self, name)
		argcheck(name, 2, 'string')

		local enabled = self:IsElementEnabled(name)
		if(not enabled) then return end

		local update = elements[name].update
		for k, func in next, self.__elements do
			if(func == update) then
				table.remove(self.__elements, k)
				break
			end
		end

		activeElements[self][name] = nil

		return elements[name].disable(self)
	end,

	--[[ frame:IsElementEnabled(name)
	Used to check if an element is enabled on the given frame.

	* self - unit frame
	* name - name of the element (string)
	--]]
	IsElementEnabled = function(self, name)
		argcheck(name, 2, 'string')

		local element = elements[name]
		if(not element) then return end

		local active = activeElements[self]
		return active and active[name]
	end,

	--[[ frame:Enable(asState)
	Used to toggle the visibility of a unit frame based on the existence of its unit. This is a reference to
	`RegisterUnitWatch`.

	* self    - unit frame
	* asState - if true, the frame's "state-unitexists" attribute will be set to a boolean value denoting whether the
	            unit exists; if false, the frame will be shown if its unit exists, and hidden if it does not (boolean)
	--]]
	Enable = RegisterUnitWatch,
	--[[ frame:Disable()
	Used to UnregisterUnitWatch for the given frame and hide it.

	* self - unit frame
	--]]
	Disable = function(self)
		UnregisterUnitWatch(self)
		self:Hide()
	end,
	--[[ frame:IsEnabled()
	Used to check if a unit frame is registered with the unit existence monitor. This is a reference to
	`UnitWatchRegistered`.

	* self - unit frame
	--]]
	IsEnabled = UnitWatchRegistered,
	--[[ frame:UpdateAllElements(event)
	Used to update all enabled elements on the given frame.

	* self  - unit frame
	* event - event name to pass to the elements' update functions (string)
	--]]
	UpdateAllElements = function(self, event)
		local unit = self.unit
		if(not unitExists(unit)) then return end

		assert(type(event) == 'string', "Invalid argument 'event' in UpdateAllElements.")

		if(self.PreUpdate) then
			--[[ Callback: frame:PreUpdate(event)
			Fired before the frame is updated.

			* self  - the unit frame
			* event - the event triggering the update (string)
			--]]
			self:PreUpdate(event)
		end

		for _, func in next, self.__elements do
			func(self, event, unit)
		end

		if(self.PostUpdate) then
			--[[ Callback: frame:PostUpdate(event)
			Fired after the frame is updated.

			* self  - the unit frame
			* event - the event triggering the update (string)
			--]]
			self:PostUpdate(event)
		end
	end,
} do
	frame_metatable.__index[k] = v
end