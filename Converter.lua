Converter = {}
Converter.__index = Converter

Converter.BASE_X = 100
Converter.BASE_Y = 300
Converter.BASE_ANGLE = 0 -- должен быть 0, xD
Converter.MAX_ANGLE = 5 * math.pi / 9
Converter.MIN_ANGLE = 0.05
Converter.MAX_ANGLE_0 = math.pi / 3
Converter.MIN_ANGLE_0 = -math.pi / 4

Converter.ELEMENT_0_LENGTH = 128
Converter.ELEMENT_1_LENGTH = 226 --218
Converter.ELEMENT_2_LENGTH = 215 --223
Converter.ELEMENT_3_LENGTH = 342 --340

function Converter.create()
	local new = {}
	setmetatable(new, Converter)

	new.a = {}

	return new
end

function Converter:convertAbsolute1(x_in, y_in)
	a = x_in - Converter.BASE_X - Converter.ELEMENT_0_LENGTH * math.sin(Converter.BASE_ANGLE)
	b = y_in - Converter.BASE_Y - Converter.ELEMENT_0_LENGTH * math.cos(Converter.BASE_ANGLE)

	local l = Converter.ELEMENT_1_LENGTH
	local k = Converter.ELEMENT_2_LENGTH + Converter.ELEMENT_3_LENGTH

	x=-math.acos(((b*k*k*l*l)/(2*(a*a*k*k+b*b*k*k))-(a*a*b*k*k)/(2*(a*a*k*k+b*b*k*k))-(b*k*k*k*k)/(2*(a*a*k*k+b*b*k*k))-(b*b*b*k*k)/(2*(a*a*k*k+b*b*k*k))-(k*math.sqrt(a*a*a*a*a*a*(-k*k)-2*a*a*a*a*b*b*k*k+2*a*a*a*a*k*k*k*k+2*a*a*a*a*k*k*l*l-a*a*b*b*b*b*k*k+2*a*a*b*b*k*k*k*k+2*a*a*b*b*k*k*l*l-a*a*k*k*k*k*k*k+2*a*a*k*k*k*k*l*l-a*a*k*k*l*l*l*l))/(2*(a*a*k*k+b*b*k*k))+b)/l)
	y=-math.acos((a*a*b*k+math.sqrt(a*a*a*a*a*a*(-k*k)-2*a*a*a*a*b*b*k*k+2*a*a*a*a*k*k*k*k+2*a*a*a*a*k*k*l*l-a*a*b*b*b*b*k*k+2*a*a*b*b*k*k*k*k+2*a*a*b*b*k*k*l*l-a*a*k*k*k*k*k*k+2*a*a*k*k*k*k*l*l-a*a*k*k*l*l*l*l)+b*b*b*k+b*k*k*k-b*k*l*l)/(2*(a*a*k*k+b*b*k*k)))

	local angle0 = Converter.BASE_ANGLE
	local angle1 = -x
	local angle2 = x - y
	local angle3 = 0
	
	return angle0, angle1, angle2, angle3
end

function Converter:convertAbsolute2(x_in, y_in)
	a = x_in - Converter.BASE_X - Converter.ELEMENT_0_LENGTH * math.sin(Converter.BASE_ANGLE)
	b = y_in - Converter.BASE_Y - Converter.ELEMENT_0_LENGTH * math.cos(Converter.BASE_ANGLE)

	local l = Converter.ELEMENT_1_LENGTH + Converter.ELEMENT_2_LENGTH
	local k = Converter.ELEMENT_3_LENGTH

	x=-math.acos(((b*k*k*l*l)/(2*(a*a*k*k+b*b*k*k))-(a*a*b*k*k)/(2*(a*a*k*k+b*b*k*k))-(b*k*k*k*k)/(2*(a*a*k*k+b*b*k*k))-(b*b*b*k*k)/(2*(a*a*k*k+b*b*k*k))-(k*math.sqrt(a*a*a*a*a*a*(-k*k)-2*a*a*a*a*b*b*k*k+2*a*a*a*a*k*k*k*k+2*a*a*a*a*k*k*l*l-a*a*b*b*b*b*k*k+2*a*a*b*b*k*k*k*k+2*a*a*b*b*k*k*l*l-a*a*k*k*k*k*k*k+2*a*a*k*k*k*k*l*l-a*a*k*k*l*l*l*l))/(2*(a*a*k*k+b*b*k*k))+b)/l)
	y=-math.acos((a*a*b*k+math.sqrt(a*a*a*a*a*a*(-k*k)-2*a*a*a*a*b*b*k*k+2*a*a*a*a*k*k*k*k+2*a*a*a*a*k*k*l*l-a*a*b*b*b*b*k*k+2*a*a*b*b*k*k*k*k+2*a*a*b*b*k*k*l*l-a*a*k*k*k*k*k*k+2*a*a*k*k*k*k*l*l-a*a*k*k*l*l*l*l)+b*b*b*k+b*k*k*k-b*k*l*l)/(2*(a*a*k*k+b*b*k*k)))

	local angle0 = Converter.BASE_ANGLE
	local angle1 = -x
	local angle2 = 0
	local angle3 = x - y
	
	return angle0, angle1, angle2, angle3
end

function Converter:getPositionForAngles(a0, a1, a2, a3, count)
	local x, y
	x = Converter.BASE_X
	y = Converter.BASE_Y
	if count == nil or count >=1 then
		x = x + Converter.ELEMENT_0_LENGTH * math.sin(a0)
		y = y + Converter.ELEMENT_0_LENGTH * math.cos(a0)
		if count == nil or count >= 2 then
			x = x + Converter.ELEMENT_1_LENGTH * math.sin(a0 + a1)
			y = y + Converter.ELEMENT_1_LENGTH * math.cos(a0 + a1)
			if count == nil or count >= 3 then
				x = x + Converter.ELEMENT_2_LENGTH * math.sin(a0 + a1 + a2)
				y = y + Converter.ELEMENT_2_LENGTH * math.cos(a0 + a1 + a2)
				if count == nil or count >= 4 then
					x = x + Converter.ELEMENT_3_LENGTH * math.sin(a0 + a1 + a2 + a3)
					y = y + Converter.ELEMENT_3_LENGTH * math.cos(a0 + a1 + a2 + a3)
				end
			end
		end
	end
	return x, y
end

function Converter:convertRelative(x_in, y_in)
	self.a[0] = global.zero.a
	self.a[1] = global.first.a
	self.a[2] = global.second.a
	self.a[3] = global.third.a

	for i = 1, 100 do
		self:turn(x_in, y_in, 3)
		self:turn(x_in, y_in, 2)
		self:turn(x_in, y_in, 1)

		-- это может и не нужно при минимальном угле в 0 градусов
		if self.a[3]*self.a[2] < 0 then
			self.a[2] = - self.a[2]
		end
	end

	return self.a[0], self.a[1], self.a[2], self.a[3]
end

function Converter:turn(x_in, y_in, index)
	local x_old, y_old = self:getPositionForAngles(self.a[0], self.a[1], self.a[2], self.a[3])
	local x_base, y_base = self:getPositionForAngles(self.a[0], self.a[1], self.a[2], self.a[3], index)

	local ox = x_old - x_base
	local oy = y_old - y_base
	local nx = x_in - x_base
	local ny = y_in - y_base

	local cos_angle = (ox * nx + oy * ny)/(math.sqrt((ox*ox+oy*oy)*(nx*nx+ny*ny)))
	if cos_angle > 1 then
		cos_angle = 1
	end
	if cos_angle < -1 then
		cos_angle = -1
	end
	local angle = math.acos(cos_angle)
	local sign = ox*ny - oy*nx
	if sign > 0 then
		angle = -math.abs(angle)
	else 
		angle =  math.abs(angle)
	end

	self.a[index] = self.a[index] + angle

	if index == 1 then
		if self.a[index] > Converter.MAX_ANGLE_0 then
			self.a[index] = Converter.MAX_ANGLE_0
		elseif self.a[index] < Converter.MIN_ANGLE_0 then
			self.a[index] = Converter.MIN_ANGLE_0
		end
	else
		if self.a[index] > Converter.MAX_ANGLE then
			self.a[index] = Converter.MAX_ANGLE
		elseif self.a[index] < Converter.MIN_ANGLE then
			self.a[index] = Converter.MIN_ANGLE
		end
	end
end
