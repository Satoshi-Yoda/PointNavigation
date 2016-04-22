CrossPoint = {}
CrossPoint.__index = CrossPoint

CrossPoint.IMAGE = love.graphics.newImage("_pic/black-point.png")

function CrossPoint.create(x, y)
	local new = {}
	setmetatable(new, CrossPoint)

	new.x = x
	new.y = y

	return new
end

function CrossPoint:update(dt)
	
end

function CrossPoint:draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.draw(CrossPoint.IMAGE, self.x, self.y, 0, 1, 1, CrossPoint.IMAGE:getWidth()/2, CrossPoint.IMAGE:getHeight()/2)
end
