require "Segment"
require "Marker"
require "Converter"
require "Point"
require "Rect"
require "ArduinoConnection"

global = {
	zero = {},
	first = {},
	second = {},
	third = {},
	marker = {},
	converter = {},
	area = {},
	rect = {},
	arduinoConnection = {}
}

function love.load()
	love.window.setMode(1024, 1024, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	global.zero   = Segment.create(0)
	global.first  = Segment.create(1, global.zero)
	global.second = Segment.create(2, global.first)
	global.third  = Segment.create(3, global.second)
	global.marker = Marker.create()
	global.converter = Converter.create()

	-- 566 на 800 это A4
	global.rect = Rect.create(Converter.BASE_X + 220, Converter.BASE_Y - 70, 566*0.77, 800*0.77)

	global.arduinoConnection = ArduinoConnection.create()
	global.arduinoConnection:init()
end

function love.update(dt)
	global.zero:update(dt)
	global.first:update(dt)
	global.second:update(dt)
	global.third:update(dt)
	global.marker:update(dt)

	local a, b = love.mouse.getPosition()
	global.zero.a, global.first.a, global.second.a, global.third.a = global.converter:convertRelative(a, b)

	love.window.setTitle(global.arduinoConnection:getAnglesString())
	global.arduinoConnection:setAngles()

	if love.mouse.isDown("l") then
		local point = Point.create(global.marker.x, global.marker.y)
		table.insert(global.area, point)

		global.arduinoConnection.pen = true
	else
		global.arduinoConnection.pen = false
	end
end

function love.draw()
	global.rect:draw()

	for key,value in pairs(global.area) do
    	value:draw()
	end
	
	global.zero:draw()
	global.second:draw()
	global.first:draw()
	global.third:draw()
	global.marker:draw()
end
