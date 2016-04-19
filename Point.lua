Point = {}
Point.__index = Point

Point.IMAGE = love.graphics.newImage("_pic/black-point.png")

function Point.create(x, y, index)
	local new = {}
	setmetatable(new, Point)

	new.x = x
	new.y = y
	new.index = index

	return new
end

function Point:update(dt)
	
end

function Point:draw(camera)
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(Point.IMAGE, self.x, self.y, 0, 1, 1, Point.IMAGE:getWidth()/2, Point.IMAGE:getHeight()/2)
	love.graphics.print(self.index, self.x + 3, self.y - 14)
end
