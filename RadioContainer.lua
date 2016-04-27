RadioContainer = {}
RadioContainer.__index = RadioContainer

function RadioContainer.create(x, y, w, h, caption)
	local new = {}
	setmetatable(new, RadioContainer)

	new.x = x
	new.y = y
	new.w = w
	new.h = h
	new.caption = caption
	new.buttons = {}

	return new
end

function RadioContainer:addButton(button)
	table.insert(self.buttons, button)
	button.container = self
end

function RadioContainer:update(dt)
	for key,button in pairs(self.buttons) do
		button:update(dt)
	end

	local x, y = love.mouse.getPosition()
	if math.abs(x - self.x - self.w/2) <= self.w/2 and math.abs(y - self.y - self.h/2) <= self.h/2 then
		return true
	else
		return false
	end
end

function RadioContainer:draw()
	love.graphics.setLineWidth(1)
	love.graphics.setColor(200, 200, 200, 255)
	love.graphics.rectangle("line", self.x + 1, self.y + 1, self.w, self.h)
	love.graphics.setColor(128, 128, 128, 255)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	for i=-4,5 do
		love.graphics.setColor(150, 170, 170, 255)
		love.graphics.print(self.caption, self.x + 8 + i, self.y - 6)
	end
	love.graphics.setColor(32, 32, 32, 255)
	love.graphics.print(self.caption, self.x + 8, self.y - 6)

	for key,button in pairs(self.buttons) do
		button:draw(self.x, self.y)
	end
end
