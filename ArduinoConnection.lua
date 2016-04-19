require "utils"

ArduinoConnection = {}
ArduinoConnection.__index = ArduinoConnection

function ArduinoConnection.create()
	local new = {}
	setmetatable(new, ArduinoConnection)

	new.port = nil
	new.pen = false
	new.accuracyMultipler = 10

	return new
end

function ArduinoConnection:init()
	self:divide(7, 0, 0, 15, 72, 75)
end

function ArduinoConnection:divide(x0, x1, y0, y1, z0, z1)
	local w0
	local w1

	local delta_x
	local delta_y
	local delta_z
	local delta_w

	local sign_x
	local sign_y
	local sign_z
	local sign_w

	if x1 > x0 then
		delta_x = x1 - x0
		sign_x = 1
	else
		delta_x = x0 - x1
		sign_x = -1
	end

	if y1 > y0 then
		delta_y = y1 - y0
		sign_y = 1
	else
		delta_y = y0 - y1
		sign_y = -1
	end

	if z1 > z0 then
		delta_z = z1 - z0
		sign_z = 1
	else
		delta_z = z0 - z1
		sign_z = -1
	end

	if delta_x >= delta_y and delta_x > delta_z then
		delta_w = delta_x
		w0 = x0
		w1 = x1
		sign_w = sign_x

	elseif delta_y >= delta_x and delta_y > delta_z then
		delta_w = delta_y
		w0 = y0
		w1 = y1
		sign_w = sign_y

	else
		delta_w = delta_z
		w0 = z0
		w1 = z1
		sign_w = sign_z
	end

	local err_x = 0
	local err_y = 0
	local err_z = 0

	local delta_err_x = delta_x
	local delta_err_y = delta_y
	local delta_err_z = delta_z

	local x = x0
	local y = y0
	local z = z0

	for w = w0, w1, sign_w do
		print(x, y, z)

		err_x = err_x + delta_err_x
		err_y = err_y + delta_err_y
		err_z = err_z + delta_err_z

		if err_x + err_x >= delta_w then
			x = x + sign_x
			err_x = err_x - delta_w
		end

		if err_y + err_y >= delta_w then
			y = y + sign_y
			err_y = err_y - delta_w
		end

		if err_z + err_z >= delta_w then
			z = z + sign_z
			err_z = err_z - delta_w
		end
	end
end

function ArduinoConnection:powerOn()

end

function ArduinoConnection:powerOff()

end

function ArduinoConnection:getAnglesString()
	local a = {}
	a[0] = global.zero.a
	a[1] = global.first.a
	a[2] = global.second.a
	a[3] = global.third.a

	for i=1,3 do
		a[i] = math.floor(self.accuracyMultipler * a[i] * 180 / math.pi)
		--a[i] = math.floor(a[i] * 180 / math.pi)
	end

	self:normalizeAngles(a)

	for i=1,3 do
		if a[i] < 0 then a[i] = 0 end
		if a[i] > self.accuracyMultipler * 180 then a[i] = self.accuracyMultipler * 180 end
		--if a[i] > 180 then a[i] = 180 end
	end

	if self.pen then
		return "A" .. a[1] .. " B" .. a[2] .. " C" .. a[3] .. " Z90"
	else
		return "A" .. a[1] .. " B" .. a[2] .. " C" .. a[3] .. " Z110"
	end
end

function ArduinoConnection:normalizeAngles(a)
	local a_zero = 93
    local b_zero = 27
    local c_zero = 154

    a[1] = self.accuracyMultipler * a_zero - a[1]
    a[2] = self.accuracyMultipler * b_zero + a[2]
    a[3] = self.accuracyMultipler * c_zero - a[3]
end

function ArduinoConnection:setAngles()
	self.port = assert(io.open("out.txt", "w"))
	self.port:write(self:getAnglesString())
	self.port:flush()
	self.port:close()
end
