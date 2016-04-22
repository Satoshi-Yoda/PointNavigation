require "RayNavigation"
require "CircleNavigation"
require "Simulation"
require "ErrorMapper"

global = {
	simulation = {},
	navigation = {},
	errorMapper = {}
}

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.simulation = Simulation.create()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
end

function love.update(dt)
	if love.mouse.isDown("l") then
		local a, b = love.mouse.getPosition()
		global.simulation.robot.x, global.simulation.robot.y = a, b
		local angles = global.simulation:gatherAngles(global.simulation.robot)
		global.navigation:calcPosition(angles)
	elseif love.mouse.isDown("r") then
		global.errorMapper:update(dt)
	else
		global.errorMapper:update(dt)
	end
end

function love.draw()
	global.errorMapper:draw()
	global.simulation:drawBase()
	global.navigation:drawLast()
end
