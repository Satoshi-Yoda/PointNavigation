ErrorMapper = {}
ErrorMapper.__index = ErrorMapper

function ErrorMapper.create()
	local new = {}
	setmetatable(new, ErrorMapper)

	new.samples = {}

	return new
end

function ErrorMapper:draw()
	love.graphics.setColor(0, 0, 0, 32)
	for key,value in pairs(self.samples) do
		love.graphics.rectangle("fill", value.x - value.s/2, value.y - value.s/2, value.s, value.s)
	end
end
