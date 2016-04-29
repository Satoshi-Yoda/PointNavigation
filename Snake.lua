require "utils"

Snake = {}
Snake.__index = Snake

SNAKE_PER_TICK = 3
SNAKE_R = 320
CM_PER_PX = 7.8125
SNAKE_SCALE = 4
DIAMETER_CM = 22

function Snake.create()
	local new = {}
	setmetatable(new, Snake)

	new.points = {}
	new.x = 480
	new.y = 480 - SNAKE_R
	new.direction = 1
	new.hStep = SNAKE_SCALE * DIAMETER_CM / CM_PER_PX
	new.vStep = SNAKE_SCALE * DIAMETER_CM / CM_PER_PX
	new.done = false
	new.works = false
	new.wasHor = false

	return new
end

function Snake:update(dt)
	if self.done then
		return
	end

	for i = 1, SNAKE_PER_TICK do
		self:tick()
	end
end

function Snake:tick()
	local newPoint = {}
	local ideal = {}
	ideal.x = self.x
	ideal.y = self.y

	local angles = global.simulation:gatherAngles(ideal)
	local supposed = global.navigation:calcPosition(angles)
	
	local diff = {}
	diff.x = supposed.x - ideal.x
	diff.y = supposed.y - ideal.y
	if utils.math.length(diff.x, diff.y) > self.vStep / 3 then
		diff.x, diff.y = utils.math.normalize(diff.x, diff.y, self.vStep / 3)
	end
	newPoint.x = SNAKE_SCALE * diff.x + ideal.x
	newPoint.y = SNAKE_SCALE * diff.y + ideal.y

	-- print("x = " .. newPoint.x .. " y = " .. newPoint.y)

	local oldDistance = utils.math.distance(self.x, self.y, 480, 480)
	if oldDistance > SNAKE_R and self.wasHor == true then
		self.y = self.y + self.vStep
		self.direction = -self.direction
		self.wasHor = false
	else 
		self.x = self.x + self.direction * self.hStep
		local newDistance = utils.math.distance(self.x, self.y, 480, 480)
		if oldDistance < newDistance then
			self.wasHor = true
		end
	end

	if self.y >= 480 + SNAKE_R then
		self.done = true
		return
	end
	table.insert(self.points, newPoint)
end

function Snake:draw()
	local first = true
	for key,point in pairs(self.points) do
		if first == false then
			local prevPoint = self.points[key-1]
			love.graphics.setColor(64, 64, 64, 255)
			love.graphics.line(point.x, point.y, prevPoint.x, prevPoint.y)
		end
		first = false
	end
end
