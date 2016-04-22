require "Robot"

RayNavigation = {}
RayNavigation.__index = RayNavigation

function RayNavigation.create(points)
	local new = {}
	setmetatable(new, RayNavigation)

	new.points = points
	new.angles = {}
	new.supposedRays = {}
	new.crossPoints = {}
	new.supposedPosition = Robot.create(480, 480, "supposed")

	return new
end

function RayNavigation:calcPosition(angles)
	self.angles = angles
	self:calcSupposedRays()
	self:calcCrossPoints()
	self:calcSupposedPosition()
	return self.supposedPosition
end

function RayNavigation:drawLast()
	for key,value in pairs(self.supposedRays) do
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

function RayNavigation:calcSupposedRays()
	self.supposedRays = {}
	for key,value in pairs(self.angles) do -- TODO move acros all angles, not across points!
		value = value + math.random() * ANGLE_ERROR * 2 - ANGLE_ERROR
		local newSupposedDirection = {}
		newSupposedDirection.x = math.cos(value)
		newSupposedDirection.y = math.sin(value)
		local newSupposedRay = Ray.createWithDirection(self.points[key], newSupposedDirection) -- TODO key is the index of point, not angle!
    	table.insert(self.supposedRays, newSupposedRay)
	end
end

function RayNavigation:calcCrossPoints()
	self.crossPoints = {}
	for key1,r1 in pairs(self.supposedRays) do
	for key2,r2 in pairs(self.supposedRays) do
	if key1 > key2 then
		local p1 = self.points[key1] -- TODO key is the index of point, not supposedRay!
		local p2 = self.points[key2] -- TODO key is the index of point, not supposedRay!
		local div = (r2.x*r1.y - r1.x*r2.y)
		if math.abs(div) > 0.1 then
			local betta = (r1.x*(p2.y-p1.y)-r1.y*(p2.x-p1.x))/div
			local x = p2.x+r2.x*betta
			local y = p2.y+r2.y*betta
			local newCrossPoint = CrossPoint.create(x, y)
			table.insert(self.crossPoints, newCrossPoint)
		end
	end
	end
	end
end

function RayNavigation:calcSupposedPosition()
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
