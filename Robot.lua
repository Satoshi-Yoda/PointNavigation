Robot = {}
Robot.__index = Robot

Robot.IMAGE = love.graphics.newImage("_pic/red-point.png")

function Robot.create(x, y)
	local new = {}
	setmetatable(new, Robot)

	new.x = x
	new.y = y

	return new
end

function Robot:update(dt)
	
end

function Robot:draw(camera)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(Robot.IMAGE, self.x, self.y, 0, 1, 1, Robot.IMAGE:getWidth()/2, Robot.IMAGE:getHeight()/2)
end
