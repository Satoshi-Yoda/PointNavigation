require "Point"

global = {
	points = {}
}

function love.load()
	love.window.setMode(960, 960, {resizable=false, vsync=true})
	love.graphics.setLineWidth(1)
	love.graphics.setBackgroundColor(150, 170, 170)
	math.randomseed(os.time())

	for i = 1, 10 do
		local newPoint = Point.create(160 + math.random(960 - 320), 160 + math.random(960 - 320), i)
		table.insert(global.points, newPoint)
	end
end

function love.update(dt)

end

function love.draw()
	for key,value in pairs(global.points) do
    	value:draw()
	end
end
