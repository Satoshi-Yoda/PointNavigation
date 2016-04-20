Robot = {}
Robot.__index = Robot

Robot.IMAGE_RED = love.graphics.newImage("_pic/red-point.png")
Robot.IMAGE_BLUE = love.graphics.newImage("_pic/blue-point.png")

function Robot.create(x, y, type)
	local new = {}
	setmetatable(new, Robot)

	new.x = x
	new.y = y
	new.type = type

	return new
end

function Robot:update(dt)
	
end

function Robot:draw(camera)
	love.graphics.setColor(255, 255, 255)
	if self.type == "real" then
		love.graphics.draw(Robot.IMAGE_RED, self.x, self.y, 0, 1, 1, Robot.IMAGE_RED:getWidth()/2, Robot.IMAGE_RED:getHeight()/2)
	elseif self.type == "supposed" then
		love.graphics.draw(Robot.IMAGE_BLUE, self.x, self.y, 0, 1, 1, Robot.IMAGE_BLUE:getWidth()/2, Robot.IMAGE_BLUE:getHeight()/2)
	end
end
