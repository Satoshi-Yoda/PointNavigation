require "Robot"

CircleNavigation = {}
CircleNavigation.__index = CircleNavigation

function CircleNavigation.create(points)
	local new = {}
	setmetatable(new, CircleNavigation)

	new.points = points
	new.angles = {}
	new.crossPoints = {}
	new.crossCircles = {}
	new.supposedPosition = Robot.create(480, 480, "supposed")

	return new
end

function CircleNavigation:calcPosition(angles)
	self.angles = angles
	self:calcCircledCrossPoints()
	self:calcSupposedPosition()
	return self.supposedPosition
end

function CircleNavigation:drawLast()
	for key,value in pairs(self.crossCircles) do
    	value:draw()
	end

	for key,value in pairs(self.crossPoints) do
    	value:draw()
	end

	for key,value in pairs(self.points) do
    	value:draw()
	end

	self.supposedPosition:draw()
end

function CircleNavigation:calcCircledCrossPoints()
	self.crossCircles = {}
	self.crossPoints = {}
	local count = 0
	for key1,p1 in pairs(self.points) do
	for key2,p2 in pairs(self.points) do
	for key3,p3 in pairs(self.points) do
	if key1 > key2 and key2 > key3 then
		local alpha1 = self.angles[key2] - self.angles[key1]
		local alpha2 = self.angles[key3] - self.angles[key2]
		local v = self:calcCircledPosition(p1, p2, p3, alpha1, alpha2)
		local newCrossPoint = CrossPoint.create(v.x, v.y)
		table.insert(self.crossPoints, newCrossPoint)
		count = count + 1
	end
	end
	end
	end
	print(count)
end

function CircleNavigation:calcSupposedPosition()
	local crossX = {}
	local crossY = {}
	local count = 1
	for key,value in pairs(self.crossPoints) do
		table.insert(crossX, value.x)
		table.insert(crossY, value.y)
		count = count + 1
	end

	table.sort(crossX)
	table.sort(crossY)
	self.supposedPosition.x = crossX[math.floor(count / 2)]
	self.supposedPosition.y = crossY[math.floor(count / 2)]
end

function CircleNavigation:calcCircledPosition(p1, p2, p3, alpha1, alpha2)
	local o12 = {}
	o12.x = ((p1.x+p2.x) + (p1.y-p2.y)/math.tan(alpha1)) / 2
	o12.y = ((p1.y+p2.y) + (p2.x-p1.x)/math.tan(alpha1)) / 2

	local o23 = {}
	o23.x = ((p2.x+p3.x) + (p2.y-p3.y)/math.tan(alpha2)) / 2
	o23.y = ((p2.y+p3.y) + (p3.x-p2.x)/math.tan(alpha2)) / 2

	local a = ((o12.x-p2.x)*(o23.y-o12.y)+(p2.y-o12.y)*(o23.x-o12.x)) / ((o12.y-o23.y)*(o23.y-o12.y)+(o23.x-o12.x)*(o12.x-o23.x))

	local v = {}
	v.x = p2.x + 2*a*(o12.y-o23.y)
	v.y = p2.y + 2*a*(o23.x-o12.x)

	local d12 = utils.math.distance(p1.x, p1.y, p2.x, p2.y)
	local newCrossCircle1 = Circle.create(o12, d12/(2*math.sin(alpha1)))
	table.insert(self.crossCircles, newCrossCircle1)

	local d23 = utils.math.distance(p2.x, p2.y, p3.x, p3.y)
	local newCrossCircle2 = Circle.create(o23, d23/(2*math.sin(alpha2)))
	table.insert(self.crossCircles, newCrossCircle2)

	return v
end
