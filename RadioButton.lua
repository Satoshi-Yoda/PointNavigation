RadioButton = {}
RadioButton.__index = RadioButton

function RadioButton.create(x, y, caption, action, pressed)
	local new = {}
	setmetatable(new, RadioButton)

	new.x = x
	new.y = y
	new.s = 24
	new.caption = caption
	new.action = action
	new.pressed = pressed
	new.container = {}

	return new
end

function RadioButton:update(dt)
	local x, y = love.mouse.getPosition()
	if math.abs(x - self.container.x - self.x) <= self.s/2 and math.abs(y - self.container.y - self.y) <= self.s/2 then
		if love.mouse.isDown("l") then
			for key,button in pairs(self.container.buttons) do
				button.pressed = false
			end
			self.pressed = true
			self.action()
		end
		return true
	else
		return false
	end
end

function RadioButton:draw()
	love.graphics.setColor(200, 200, 200, 255)
	love.graphics.circle("fill", self.container.x + self.x, self.container.y + self.y, self.s/3, 24)
	love.graphics.setColor(128, 128, 128, 255)
	love.graphics.circle("line", self.container.x + self.x, self.container.y + self.y, self.s/3, 24)
	if self.pressed then
		love.graphics.setColor(96, 96, 96, 255)
		love.graphics.circle("fill", self.container.x + self.x, self.container.y + self.y, self.s/6, 24)
		love.graphics.circle("line", self.container.x + self.x, self.container.y + self.y, self.s/6, 24)
	end
	love.graphics.setColor(32, 32, 32, 255)
	love.graphics.print(self.caption, self.container.x + self.x + 12, self.container.y + self.y - 7)
end
