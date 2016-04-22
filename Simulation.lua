require "Robot"
require "Ray"

Simulation = {}
Simulation.__index = Simulation

ANGLE_ERROR = 1 * math.pi / 180 -- radians

function Simulation.create()
	local new = {}
	setmetatable(new, Simulation)

	new.points = {}
	new.rays = {}

	new.robot = Robot.create(480, 480, "real")

	for i = 1, 5 do
		local newPoint = Point.create(160 + math.random(960 - 320), 160 + math.random(960 - 320), i)
		table.insert(new.points, newPoint)

		local newRay = Ray.create(new.robot, newPoint)
		table.insert(new.rays, newRay)
	end

	return new
end

function Simulation:gatherAngles()
	local angles = {}
	for key,value in pairs(self.points) do
		local newAngle = math.atan2(self.robot.y - value.y, self.robot.x - value.x)
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
