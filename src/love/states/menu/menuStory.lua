local diffs = {"easy", "normal", "hard"}
local diffAppend = {"-easy", "", "-hard"}
local curDiff = 2

return {
    enter = function(self)
        graphics:mikuTransitionIn()

        -- Miku BG stuff
		mikuBG = {}
		mikuBG.bg = graphics.newImage(graphics.imagePath("mikuMenu/back"))
		mikuBG.bg.sizeX, mikuBG.bg.sizeY = 1.4, 1.4
		
		mikuBG.bg2 = graphics.newImage(graphics.imagePath("mikuMenu/back2"))
		mikuBG.bg2.sizeX, mikuBG.bg2.sizeY = 1.4, 1.4

		mikuBG.bgx = graphics.newImage(graphics.imagePath("mikuMenu/backx"))
		mikuBG.bgx.sizeX, mikuBG.bgx.sizeY = 1.4, 1.4

		function tweenBGx()
			Timer.tween(6, mikuBG.bgx, {x = mikuBG.bgx.x + 70}, "out-cubic", function()
				Timer.tween(6, mikuBG.bgx, {x = mikuBG.bgx.x - 70}, "out-cubic", function()
					tweenBGx()
				end)
			end)
		end
		tweenBGx()

		mikuBG.circles = graphics.newImage(graphics.imagePath("mikuMenu/circles"))
		mikuBG.circles.sizeX, mikuBG.circles.sizeY = 1.3, 1.3
		mikuBG.circles.y = 225
		mikuBG.circles.x = 275
		function tweenCirc()
			Timer.tween(20, mikuBG.circles, {orientation = math.rad(360)}, "linear", function()
				mikuBG.circles.orientation = 0
				tweenCirc()
			end)
		end
		tweenCirc()

		mikuBG.lines = {}

		local velocityArray = {45,60,30,80,25,100,160,120,140,170,200}

		for i = 0, 9 do
			--mikuBG.lines[i] = graphics.newImage(graphics.imagePath("mikuMenu/line" .. i))
			mikuBG.lines[i] = {
				img = graphics.newImage(graphics.imagePath("mikuMenu/line" .. i)),
				vx = velocityArray[i + 1],
				vy = 0,
				x = 0,
				y = 0,
				
				update = function(self, dt)
					self.x = self.x + self.vx * dt
					self.y = self.y + self.vy * dt
					-- at a certain point, reset the position
					if self.x < -self.img:getWidth() then
						self.x = 0
					end
					if self.y < -self.img:getHeight() then
						self.y = 0
					end
				end,

				draw = function(self)
					graphics.setColor(1, 1, 1, self.alpha)
					for x = -5, 20 do
						for y = -5, 20 do
							self.img.x = self.x + (self.img:getWidth() * (x - 1))
							self.img.y = self.y + (self.img:getHeight() * (y - 1))
							self.img:draw()
						end
					end
				end
			}
		end

		--mikuBG.triangles = graphics.newImage(graphics.imagePath("mikuMenu/triangles"))
		mikuBG.triangles = {
			img = graphics.newImage(graphics.imagePath("mikuMenu/triangles")),
			vx = 200,
			vy = 0,
			x = 0,
			y = 0,
			update = function(self, dt)
				self.x = self.x + self.vx * dt
				self.y = self.y + self.vy * dt
				-- at a certain point, reset the position
				if self.x < -self.img:getWidth() then
					self.x = 0
				end
				if self.y < -self.img:getHeight() then
					self.y = 0
				end
			end,

			draw = function(self)
				graphics.setColor(1, 1, 1, self.alpha)
				for x = -5, 20 do
					for y = -5, 20 do
						self.img.x = self.x + (self.img:getWidth() * (x - 1))
						self.img.y = self.y + (self.img:getHeight() * (y - 1))
						self.img:draw()
					end
				end
			end
		}

        bars = graphics.newImage(graphics.imagePath("mikuMenu/storymodebars"))

		record = graphics.newImage(graphics.imagePath("mikuMenu/record"))
		record.sizeX, record.sizeY = 1.25, 1.25
		record.x = -700
		function tweenRecord()
			Timer.tween(20, record, {orientation = math.rad(360)}, "linear", function()
				record.orientation = 0
				tweenRecord()
			end)
		end
		tweenRecord()

		difficultyBar = love.filesystem.load("sprites/mikuMenu/difficultyBar.lua")()
		difficultyBar.sizeX, difficultyBar.sizeY = 1.4, 1.4
		startbutton = love.filesystem.load("sprites/mikuMenu/startbutton.lua")()
		startbutton.sizeX, startbutton.sizeY = 0.65, 0.65

		startbutton.x, startbutton.y = 300, 80
		difficultyBar.x, difficultyBar.y = 275, -125
    end,

    update = function(self, dt)
		for i = 0, 9 do
			mikuBG.lines[i]:update(dt)
		end
		mikuBG.triangles:update(dt)

		startbutton:update(dt)
		difficultyBar:update(dt)

		if input:pressed("left") then
			audio.playSound(selectSound)
			curDiff = curDiff - 1
			if curDiff < 1 then
				curDiff = 3
			end
		elseif input:pressed("right") then
			audio.playSound(selectSound)
			curDiff = curDiff + 1
			if curDiff > 3 then
				curDiff = 1
			end
		elseif input:pressed("confirm") then
			audio.playSound(confirmSound)
			graphics:mikuTransitionOut(function()
				storyMode = true
				music:stop()
				Gamestate.switch(weekData[1], 1, diffAppend[curDiff], 1)
				status.setLoading(false)							
			end)
		end

		if input:pressed("back") then
			audio.playSound(backSound)
			graphics:mikuTransitionOut(function()
				Gamestate.switch(menuSelect)
				status.setLoading(false)
			end)
		end

		difficultyBar:animate(diffs[curDiff])
    end,

    draw = function(self)
        love.graphics.push()
            love.graphics.translate(graphics.getWidth()/2, graphics.getHeight()/2)
            love.graphics.push()
                mikuBG.bg:draw()
                mikuBG.bg2:draw()
                mikuBG.bgx:draw()
                mikuBG.circles:draw()
                for i = 0, 9 do
                    mikuBG.lines[i]:draw()
                end
                mikuBG.triangles:draw()
            love.graphics.pop()

			love.graphics.push()
				record:draw()
				bars:draw()

				startbutton:draw()
				difficultyBar:draw()
			love.graphics.pop()
        love.graphics.pop()
    end
}