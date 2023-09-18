--[[
	File created for Vanilla Engine
]]

local upFunc, downFunc, confirmFunc, drawFunc, musicStop

local menuState

local menuNum = 1

local songNum, songAppend
local songDifficulty = 2

local transparency, isMatpat

return {
	enter = function(self, previous)
		beatHandler.setBPM(102)
		if not music:isPlaying() then
			music:play()
		end

		transparency = {0}
		Timer.tween(
			1,
			transparency,
			{[1] = 1},
			"out-quad"
		)
		confirmTitle = love.audio.newSource("sounds/menu/startscreenEnter.ogg", "static")
		titleBG = graphics.newImage(graphics.imagePath("mikuMenu/transparency"))
		titleBG.sizeX, titleBG.sizeY = 1.4, 1.4
		changingMenu = false
		isMatpat = love.math.random(0, 200) == 0
		if isMatpat then
			logo = love.filesystem.load("sprites/menu/matpat.lua")()
		else
			logo = love.filesystem.load("sprites/mikuMenu/logo.lua")()
		end
		logo.y = -50
		logo.sizeX, logo.sizeY = 1.15, 1.15
		
		function AnimateLogo()
			if isMatpat then
				logo:animate("anim", false, function()
					Timer.after(0.25, AnimateLogo)
				end)
			end
		end
		AnimateLogo()

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

		songNum = 0

		if firstStartup then
			graphics.setFade(0) 
			graphics.fadeIn(0.5) 
		else graphics:fadeInWipe(0.6) end

		firstStartup = false
	end,

	update = function(self, dt)
		logo:update(dt)
		for i = 0, 9 do
			mikuBG.lines[i]:update(dt)
		end
		mikuBG.triangles:update(dt)

		beatHandler.update(dt)

		if not graphics.isFading() then
			if input:pressed("confirm") then
				if not changingMenu then
					audio.playSound(confirmTitle)
					changingMenu = true
					graphics:mikuTransitionOut(function()
						Gamestate.switch(menuSelect)
						status.setLoading(false)							
					end)
				end
			elseif input:pressed("back") then
				audio.playSound(selectSound)
				love.event.quit()
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
				love.graphics.push()
					-- draw all mikuBG stuff
					mikuBG.bg:draw()
					mikuBG.bg2:draw()
					mikuBG.bgx:draw()
					mikuBG.circles:draw()
					for i = 0, 9 do
						mikuBG.lines[i]:draw()
					end
					mikuBG.triangles:draw()
					
					titleBG:draw()
				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)
					logo:draw()
				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)
				love.graphics.pop()
			love.graphics.pop()

		love.graphics.pop()
	end,

	leave = function(self)
		logo = nil
		confirmTitle = nil
		titleBG = nil

		Timer.clear()
	end
}
