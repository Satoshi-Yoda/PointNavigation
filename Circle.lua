Circle = {}
Circle.__index = Circle

function Circle.create(c, r)
	local new = {}
	setmetatable(new, Circle)

	new.c = c
	new.r = r

	return new
end

function Circle:draw()
	love.graphics.setColor(0, 0, 255, 16)
	love.graphics.circle("line", self.c.x, self.c.y, self.r, 144)
end
