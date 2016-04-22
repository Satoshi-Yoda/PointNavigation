require "Point"
require "Robot"
require "Ray"
require "CrossPoint"
require "Circle"
require "RayNavigation"
require "CircleNavigation"
require "Simulation"

global = {
	simulation = {},
	navigation = {}
}

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.simulation = Simulation.create()
	global.navigation = CircleNavigation.create(global.simulation.points)
end

function love.update(dt)
	if love.mouse.isDown("l") then
		local a, b = love.mouse.getPosition()
		global.simulation.robot.x, global.simulation.robot.y = a, b
		local angles = global.simulation:gatherAngles()
		global.navigation:calcPosition(angles)
	end
end

function love.draw()
	global.simulation:drawBase()
	global.navigation:drawLast()
end
