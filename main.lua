require "RayNavigation"
require "CircleNavigation"
require "Simulation"
require "ErrorMapper"
require "Button"
require "RadioButton"
require "RadioContainer"

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

function createRandomPoints()
	global.simulation:createRandomPoints()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
end

function createCirclePoints()
	global.simulation:createCirclePoints()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
end

function createDiskPoints()
	global.simulation:createDiskPoints()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
end

function make320camera()
	global.simulation:setAngleErrorFromCamera(320, 90)
	global.errorMapper = ErrorMapper.create()
end

function make640camera()
	global.simulation:setAngleErrorFromCamera(640, 64)
	global.errorMapper = ErrorMapper.create()
end

function make1920camera()
	global.simulation:setAngleErrorFromCamera(1920, 64)
	global.errorMapper = ErrorMapper.create()
end

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.simulation = Simulation.create()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
	
	local cameraRadio = RadioContainer.create(10, 10, 95, 95, "Camera")
	table.insert(global.buttons, cameraRadio)
	cameraRadio:addButton(RadioButton.create(20, 24, "320px", make320camera))
	cameraRadio:addButton(RadioButton.create(20, 49, "640px", make640camera, true))
	cameraRadio:addButton(RadioButton.create(20, 74, "1920px", make1920camera))

	table.insert(global.buttons, Button.create(140, 10, 120, 23, "Random points", createRandomPoints))
	table.insert(global.buttons, Button.create(140, 40, 120, 23, "Circle points", createCirclePoints))
	table.insert(global.buttons, Button.create(140, 70, 120, 23, "Disk points", createDiskPoints))

	table.insert(global.buttons, Button.create(270, 10, 120, 23, "Error map", calcErrorMap))
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
