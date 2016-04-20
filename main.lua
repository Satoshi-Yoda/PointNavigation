require "Point"
require "Robot"
require "Ray"
require "CrossPoint"

global = {
	points = {},
	rays = {},
	angles = {},
	supposedRays = {},
	crossPoints = {},
	supposedPosition = {},
	robot = {}
}

ANGLE_ERROR = 4 * 3.14159 / 180 -- radians

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.robot = Robot.create(480, 480, "real")
	global.supposedPosition = Robot.create(480, 480, "supposed")

	for i = 1, 2 do
		local newPoint = Point.create(160 + math.random(960 - 320), 160 + math.random(960 - 320), i)
		table.insert(global.points, newPoint)

		local newRay = Ray.create(global.robot, newPoint)
		table.insert(global.rays, newRay)
	end
end

function love.update(dt)
	if love.mouse.isDown("l") then
		local a, b = love.mouse.getPosition()
		global.robot.x, global.robot.y = a, b
		gatherAngles()
		calcSupposedRays()
		calcCrossPoints()
		calcSupposedPosition()
	end
end

function love.draw()
	for key,value in pairs(global.rays) do
    	value:draw()
	end

	for key,value in pairs(global.supposedRays) do
    	value:draw()
	end

	for key,value in pairs(global.points) do
    	value:draw()
	end

	for key,value in pairs(global.crossPoints) do
    	value:draw()
	end

	global.robot:draw()
	global.supposedPosition:draw()
end

function gatherAngles()
	global.angles = {}
	for key,value in pairs(global.points) do
		local newAngle = math.atan2(global.robot.y - value.y, global.robot.x - value.x)
    	table.insert(global.angles, newAngle)
	end
end

function calcSupposedRays()
	global.supposedRays = {}
	for key,value in pairs(global.angles) do -- TODO move acros all angles, not across points!
		value = value + math.random() * ANGLE_ERROR * 2 - ANGLE_ERROR
		local newSupposedDirection = {}
		newSupposedDirection.x = math.cos(value)
		newSupposedDirection.y = math.sin(value)
		local newSupposedRay = Ray.createWithDirection(global.points[key], newSupposedDirection) -- TODO key is the index of point, not angle!
    	table.insert(global.supposedRays, newSupposedRay)
	end
end

function calcCrossPoints()
	global.crossPoints = {}
	for key1,r1 in pairs(global.supposedRays) do
	for key2,r2 in pairs(global.supposedRays) do
	if key1 > key2 then
		local p1 = global.points[key1] -- TODO key is the index of point, not supposedRay!
		local p2 = global.points[key2] -- TODO key is the index of point, not supposedRay!
		local div = (r2.x*r1.y - r1.x*r2.y)
		if math.abs(div) > 0.1 then
			local betta = (r1.x*(p2.y-p1.y)-r1.y*(p2.x-p1.x))/div
			local x = p2.x+r2.x*betta
			local y = p2.y+r2.y*betta
			local newCrossPoint = CrossPoint.create(x, y)
			table.insert(global.crossPoints, newCrossPoint)
		end
	end
	end
	end
end

function calcSupposedPosition()
	local crossX = {}
	local crossY = {}
	local count = 1
	for key,value in pairs(global.crossPoints) do
		table.insert(crossX, value.x)
		table.insert(crossY, value.y)
		count = count + 1
	end

	table.sort(crossX)
	table.sort(crossY)
	global.supposedPosition.x =	crossX[math.floor(count / 2)]
	global.supposedPosition.y =	crossY[math.floor(count / 2)]
end
