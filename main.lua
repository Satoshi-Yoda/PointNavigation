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
	ui = {},
	mode = "none",
	leftMouse = false
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
	global.mode = "none"
end

function createCirclePoints()
	global.simulation:createCirclePoints()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
	global.mode = "none"
end

function createDiskPoints()
	global.simulation:createDiskPoints()
	global.navigation = CircleNavigation.create(global.simulation.points)
	global.errorMapper = ErrorMapper.create()
	global.mode = "none"
end

function createManualPoints()
	global.errorMapper = ErrorMapper.create()
	global.mode = "add"
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
	
	local cameraRadio = RadioContainer.create(12, 12, 95, 95, "Camera")
	table.insert(global.ui, cameraRadio)
	cameraRadio:addButton(RadioButton.create(20, 24, "320px", make320camera))
	cameraRadio:addButton(RadioButton.create(20, 49, "640px", make640camera, true))
	cameraRadio:addButton(RadioButton.create(20, 74, "1920px", make1920camera))

	local pointsRadio = RadioContainer.create(120, 12, 170, 120, "Points")
	table.insert(global.ui, pointsRadio)
	pointsRadio:addButton(RadioButton.create(20, 24, "Random", createRandomPoints))
	pointsRadio:addButton(RadioButton.create(20, 49, "Circle", createCirclePoints, true))
	pointsRadio:addButton(RadioButton.create(20, 74, "Disk", createDiskPoints))
	pointsRadio:addButton(RadioButton.create(20, 99, "Manual (left mouse)", createManualPoints))

	table.insert(global.ui, Button.create(305, 12, 120, 23, "Error map", calcErrorMap))
end

function love.update(dt)
	if global.errorMapper.works then
		global.errorMapper:update(dt)
	end

	local buttonWorks = false
	for key,button in pairs(global.ui) do
		buttonWorks = buttonWorks or button:update(dt)
	end

	if buttonWorks == false then
		if love.mouse.isDown("l") then
			local a, b = love.mouse.getPosition()
			if global.leftMouse == false and global.mode == "add" then
				global.simulation:addPoint(a, b)
				global.errorMapper = ErrorMapper.create()
			end
			global.leftMouse = true
			global.simulation.robot.x, global.simulation.robot.y = a, b
			local angles = global.simulation:gatherAngles(global.simulation.robot)
			global.navigation:calcPosition(angles)
		else
			global.leftMouse = false
		end
	end
end

function love.draw()
	global.errorMapper:draw()
	global.simulation:drawBase()
	global.navigation:drawLast()

	for key,button in pairs(global.ui) do
		button:draw()
	end
end
