require "Point"
require "Robot"
require "Ray"

global = {
	points = {},
	rays = {},
	robot = {}
}

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.robot = Robot.create(480, 480)

	for i = 1, 8 do
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
	end
end

function love.draw()
	global.robot:draw()

	for key,value in pairs(global.points) do
    	value:draw()
	end

	for key,value in pairs(global.rays) do
    	value:draw()
	end
end
