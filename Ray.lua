Ray = {}
Ray.__index = Ray

Ray.IMAGE = love.graphics.newImage("_pic/black-point.png")

function Ray.create(from, to)
	local new = {}
	setmetatable(new, Ray)

	new.from = from
	new.to = to

	return new
end

function Ray:update(dt)
	
end

function Ray:draw(camera)
	love.graphics.setColor(255, 0, 0, 64)
	love.graphics.line(self.from.x, self.from.y, self.to.x, self.to.y)
end
