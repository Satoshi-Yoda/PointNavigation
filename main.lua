require "RayNavigation"
require "CircleNavigation"
require "Simulation"
require "ErrorMapper"
require "Button"

global = {
	simulation = {},
	navigation = {},
	errorMapper = {},
	buttons = {}
}

function calcErrorMap()
	global.errorMapper.samples = {}
	global.errorMapper.done = false
	global.errorMapper.works = true
end

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.simulation = Simulation.create()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()

	local button = Button.create(200, 100, 120, 28, "Error map", calcErrorMap)
	table.insert(global.buttons, button)
end

function love.update(dt)
	if global.errorMapper.works then
		global.errorMapper:update(dt)
	end

	local buttonWorks = false
	for key,button in pairs(global.buttons) do
		buttonWorks = buttonWorks or button:update(dt)
	end

	if buttonWorks == false then
		if love.mouse.isDown("l") then
			local a, b = love.mouse.getPosition()
			global.simulation.robot.x, global.simulation.robot.y = a, b
			local angles = global.simulation:gatherAngles(global.simulation.robot)
			global.navigation:calcPosition(angles)
		end
	end
end

function love.draw()
	global.errorMapper:draw()
	global.simulation:drawBase()
	global.navigation:drawLast()

	for key,button in pairs(global.buttons) do
		button:draw()
	end
end
