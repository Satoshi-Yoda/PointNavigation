ErrorMapper = {}
ErrorMapper.__index = ErrorMapper

SAMPLE_SIZE = 24
SAMPLE_COUNT = 150
SAMPLE_PER_TICK = 2
ERROR_THRESHOLD = 0.4

function ErrorMapper.create()
	local new = {}
	setmetatable(new, ErrorMapper)

	new.samples = {}
	new.i = 0
	new.j = 0
	new.done = false
	new.works = false
	new.direction = true

	return new
end

function ErrorMapper:getErrorForPoint(v)
	local s = SAMPLE_SIZE
	local j = math.floor((v.y + s/2) / s)
	local i
	local w = math.floor(960 / s) + 1
	if j % 2 == 0 then
		i = math.floor((v.x + s/2) / s) + 1
	else
		i = w - math.floor((v.x + s/2) / s)
	end
	
	local sample = self.samples[i+j*w]
	if sample ~= nil then
		-- love.graphics.setColor(0, 0, 255, 255)
		-- love.graphics.rectangle("fill", sample.x - s/2, sample.y - s/2, s, s)
		if sample ~= nil and math.abs(sample.x - v.x) <= s/2 and math.abs(sample.y - v.y) <= s/2 then
			return sample.error
		else
			return -1
		end
	else
		return -1
	end
end

function ErrorMapper:update(dt)
	if self.done then
		return
	end

	for i = 1, SAMPLE_PER_TICK do
		self:tick()
	end
end

function ErrorMapper:tick()
	if self.done then
		return
	end

	local v = {}
	v.x = self.i * SAMPLE_SIZE
	v.y = self.j * SAMPLE_SIZE

	local errors = {}
	for i = 1, SAMPLE_COUNT do
		local angles = global.simulation:gatherAngles(v)
		local position = global.navigation:calcPosition(angles)
		local dx = math.abs(position.x - v.x)
		local dy = math.abs(position.y - v.y)
		local dv = utils.math.length(dx, dy)
		table.insert(errors, 100 * dv / 480)
	end

	local newSample = {}
	newSample.x = v.x
	newSample.y = v.y
	newSample.error = utils.avg(errors)
	table.insert(self.samples, newSample)

	if self.direction == true then
		self.i = self.i + 1
	else
		self.i = self.i - 1
	end

	if self.i > math.floor(960 / SAMPLE_SIZE) or self.i < 0 then
		if self.direction == true then
			self.i = math.floor(960 / SAMPLE_SIZE)
			self.direction = false
		else
			self.i = 0
			self.direction = true
		end

		self.j = self.j + 1
		if self.j > math.floor(960 / SAMPLE_SIZE) then
			self.j = 0
			self.done = true
		end
	end
end

function ErrorMapper:draw()
	local s = SAMPLE_SIZE
	for key,sample in pairs(self.samples) do
		-- if sample.error > 4 then love.graphics.setColor(255, 0, 0, 64)
		-- elseif sample.error > 1 then love.graphics.setColor(180, 255-180, 0, 64)
		-- elseif sample.error > 0.25 then love.graphics.setColor(128, 128, 0, 64)
		-- elseif sample.error > 0.0625 then love.graphics.setColor(0, 255, 0, 64)
		-- end

		-- r = log fit {4,255},{1,180},{0.25,128},{0.0625,0}
		-- g = log fit {4,0},{1,75},{0.25,128},{0.0625,255}

		local r = utils.math.clamp(0, 58.9341 * math.log(21.7891 * sample.error), 255)
		local g = utils.math.clamp(0, -59.0062 * math.log(0.287272 * sample.error), 255)
		if sample.error <= ERROR_THRESHOLD then
			-- g = utils.math.clamp(0, g + 64, 255)
		else
			love.graphics.setColor(255, 0, 0, 64)
			love.graphics.line(sample.x - s/2, sample.y - s/2, sample.x, sample.y + s/2)
			love.graphics.line(sample.x, sample.y - s/2, sample.x + s/2, sample.y + s/2)
		end
		love.graphics.setColor(r, g, 0, 128)
		love.graphics.rectangle("fill", sample.x - s/2, sample.y - s/2, s, s)
	end

	local currentPos = {}
	currentPos.x, currentPos.y = love.mouse.getPosition()
	local error = self:getErrorForPoint(currentPos)
	local errorString = "error = " .. math.floor(error / 100 * 5000) .. "sm"
	if error >= 0 then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(errorString, currentPos.x + 12, currentPos.y - 6)
	end
end
