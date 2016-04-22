require "Robot"
require "Ray"
require "Point"

Simulation = {}
Simulation.__index = Simulation

ANGLE_ERROR = 0.3 * math.pi / 180 -- radians

function Simulation.create()
	local new = {}
	setmetatable(new, Simulation)

	new.points = {}
	new.rays = {}

	new.robot = Robot.create(480, 480, "real")

	for i = 1, 8 do
		local newPoint = Point.create(160 + math.random(960 - 320), 160 + math.random(960 - 320), i)
		table.insert(new.points, newPoint)

		local newRay = Ray.create(new.robot, newPoint)
		table.insert(new.rays, newRay)
	end

	return new
end

function Simulation:gatherAngles(position)
	local angles = {}
	for key,value in pairs(self.points) do
		local newAngle = math.atan2(position.y - value.y, position.x - value.x)
    	newAngle = newAngle + math.random() * ANGLE_ERROR * 2 - ANGLE_ERROR
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
