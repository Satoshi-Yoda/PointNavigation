Button = {}
Button.__index = Button

function Button.create(x, y, w, h, caption, action)
	local new = {}
	setmetatable(new, Button)

	new.x = x
	new.y = y
	new.w = w
	new.h = h
	new.caption = caption
	new.action = action
	new.pressed = false

	return new
end

function Button:update(dt)
	local x, y = love.mouse.getPosition()
	if math.abs(x - self.x - self.w/2) <= self.w/2 and math.abs(y - self.y - self.h/2) <= self.h/2 then
		if love.mouse.isDown(1) then
			self.pressed = true
		else
			if self.pressed == true then
				self.action()
			end
			self.pressed = false
		end
		return true
	else
		self.pressed = false
		return false
	end
end

function Button:draw()
	love.graphics.setColor(128, 128, 128, 255)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	if self.pressed then
		love.graphics.setColor(128, 128, 128, 255)
	else
		love.graphics.setColor(192, 192, 192, 255)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(32, 32, 32, 255)
	love.graphics.printf(self.caption, self.x, self.y + 5, self.w, "center")
end
