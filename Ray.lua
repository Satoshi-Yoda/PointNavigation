require "utils"

Ray = {}
Ray.__index = Ray

Ray.IMAGE = love.graphics.newImage("_pic/black-point.png")

function Ray.create(from, to)
	local new = {}
	setmetatable(new, Ray)

	new.from = from
	new.to = to
	new.x = to.x - from.x
	new.y = to.y - from.y
	new.mode = "target"

	return new
end

function Ray.createWithDirection(from, direction)
	local new = {}
	setmetatable(new, Ray)

	new.from = from
	local to = {}
	to.x = from.x + direction.x * 1200
	to.y = from.y + direction.y * 1200
	new.to = to
	new.x = direction.x
	new.y = direction.y
	new.mode = "direction"

	return new
end

function Ray:update(dt)
	
end

function Ray:draw(camera)
	if self.mode == "target" then
		love.graphics.setColor(255, 0, 0, 64)
		utils.lineStipple(self.from.x, self.from.y, self.to.x, self.to.y)
	elseif self.mode == "direction" then
		love.graphics.setColor(0, 0, 255, 32)
		love.graphics.line(self.from.x, self.from.y, self.to.x, self.to.y)
	end
end
