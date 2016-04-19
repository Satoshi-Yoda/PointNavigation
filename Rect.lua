Rect = {}
Rect.__index = Rect

function Rect.create(x, y, w, h)
	local new = {}
	setmetatable(new, Rect)

	new.x = x
	new.y = y
	new.w = w
	new.h = h

	return new
end

function Rect:update(dt)
	
end

function Rect:draw(camera)
	love.graphics.setColor(140, 160, 160, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255, 255)
end
