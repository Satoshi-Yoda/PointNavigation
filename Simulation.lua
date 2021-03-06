require "Robot"
require "Ray"
require "Point"

Simulation = {}
Simulation.__index = Simulation

POINTS_COUNT = 7

function Simulation.create()
	local new = {}
	setmetatable(new, Simulation)

	new.robot = Robot.create(480, 480, "real")
	new:setAngleErrorFromCamera(1920, 64)
	new:createRectPoints()

	return new
end

function Simulation:setAngleErrorFromCamera(pixels, angle)
	self.angleError = 3 * (angle / pixels) * math.pi / 180
end

function Simulation:createRandomPoints()
	self.points = {}
	self.rays = {}

	for i = 0, POINTS_COUNT - 1 do
		local newPoint = Point.create(160 + math.random(960 - 320), 160 + math.random(960 - 320), i)
		table.insert(self.points, newPoint)

		local newRay = Ray.create(self.robot, newPoint)
		table.insert(self.rays, newRay)
	end
end

function Simulation:createCirclePoints()
	self.points = {}
	self.rays = {}

	for i = 0, POINTS_COUNT - 1 do
		local newPoint = Point.create(0, 0, i)
		newPoint.x = 480 + math.cos(i * 2 * math.pi / POINTS_COUNT) * 320
		newPoint.y = 480 + math.sin(i * 2 * math.pi / POINTS_COUNT) * 320
		table.insert(self.points, newPoint)

		local newRay = Ray.create(self.robot, newPoint)
		table.insert(self.rays, newRay)
	end
end

function Simulation:createRectPoints()
	self.points = {}
	self.rays = {}

	local count = 8

	for i = 0, count - 1 do
		local newPoint = Point.create(0, 0, i)
		local x = math.cos(i * 2 * math.pi / count)
		local y = math.sin(i * 2 * math.pi / count)
		if math.abs(x) > math.abs(y) then
			y = y / math.abs(x)
			x = x / math.abs(x)
		else
			x = x / math.abs(y)
			y = y / math.abs(y)
		end
		newPoint.x = 480 + x * 320
		newPoint.y = 480 + y * 320
		table.insert(self.points, newPoint)

		local newRay = Ray.create(self.robot, newPoint)
		table.insert(self.rays, newRay)
	end
end

function Simulation:createDiskPoints()
	self.points = {}
	self.rays = {}

	local newPoint = Point.create(480, 480, 0)
	table.insert(self.points, newPoint)
	local newRay = Ray.create(self.robot, newPoint)
	table.insert(self.rays, newRay)

	for i = 1, POINTS_COUNT - 1 do
		local newPoint = Point.create(0, 0, i)
		local r
		if i % 2 == 0 then
			r = 240
		else
			r = 320
		end
		newPoint.x = 480 + math.cos(i * 2 * math.pi / (POINTS_COUNT - 1)) * r
		newPoint.y = 480 + math.sin(i * 2 * math.pi / (POINTS_COUNT - 1)) * r
		table.insert(self.points, newPoint)

		local newRay = Ray.create(self.robot, newPoint)
		table.insert(self.rays, newRay)
	end
end

function Simulation:addPoint(x, y)
	local newPoint = Point.create(x, y, 0)
	table.insert(self.points, newPoint)
	local newRay = Ray.create(self.robot, newPoint)
	table.insert(self.rays, newRay)

	for key,point in pairs(self.points) do
		point.index = key
	end
end

function Simulation:gatherAngles(position)
	local angles = {}
	for key,value in pairs(self.points) do
		local newAngle = math.atan2(position.y - value.y, position.x - value.x)
    	newAngle = newAngle + math.random() * self.angleError * 2 - self.angleError
    	table.insert(angles, newAngle)
	end
	return angles
end

function Simulation:drawBase()
	for key,value in pairs(self.rays) do
    	value:draw()
	end

	self.robot:draw()
end
