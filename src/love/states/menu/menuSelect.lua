--[[
	File created for Vanilla Engine
]]

local leftFunc, rightFunc, confirmFunc, backFunc, drawFunc

local menuState

local menuButton

local optionslist = {"storymode", "freeplay", "options", "credits"}

local function changeSelect()
    if menuButton == 1 then
        storymode:animate("storymode select", true)
        freeplay:animate("freeplay", true)
        options:animate("options", true)
        credits:animate("credits", true)
    elseif menuButton == 2 then
        storymode:animate("storymode", true)
        freeplay:animate("freeplay select", true)
        options:animate("options", true)
        credits:animate("credits", true)
    elseif menuButton == 3 then
        storymode:animate("storymode", true)
        freeplay:animate("freeplay", true)
        options:animate("options select", true)
        credits:animate("credits", true)
    elseif menuButton == 4 then
        storymode:animate("storymode", true)
        freeplay:animate("freeplay", true)
        options:animate("options", true)
        credits:animate("credits select", true)
    end
    tweenCharacter()
end

local function confirmFunc()
	graphics:mikuTransitionOut(
		function()
			if menuButton == 1 then
				Gamestate.switch(menuStory)
			elseif menuButton == 2 then
				Gamestate.switch(menuFreeplay)
			elseif menuButton == 3 then
				Gamestate.switch(menuSettings)
			elseif menuButton == 4 then
				Gamestate.switch(creditsFAKE)
			end
		end
	)
end

function tweenCharacter()
    Timer.tween(0.2, characters, {x= 500, alpha = 0.2}, "in-cubic", function()
        characters:animate(optionslist[menuButton])
        Timer.tween(0.2, characters, {x= 100, alpha = 1}, "out-cubic")
    end)
end

return {
	enter = function(self, previous)
        
		menuButton = 1
		songNum = 0
        
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

        bars = graphics.newImage(graphics.imagePath("mikuMenu/mainmenubars"))

        -- menu buttons
        menu_shit_img = love.graphics.newImage(graphics.imagePath("mikuMenu/menu_shit"))
        menu_shit_spr = love.filesystem.load("sprites/mikuMenu/menu_shit.lua")
        storymode = menu_shit_spr()
        freeplay = menu_shit_spr()
        options = menu_shit_spr()
        credits = menu_shit_spr()
        
        storymode.sizeX, storymode.sizeY = 0.6, 0.6
        freeplay.sizeX, freeplay.sizeY = 0.6, 0.6
        options.sizeX, options.sizeY = 0.6, 0.6
        credits.sizeX, credits.sizeY = 0.6, 0.6

        storymode:animate("storymode select", true)
        freeplay:animate("freeplay", true)
        options:animate("options", true)
        credits:animate("credits", true)

        storymode.x, storymode.y = -350, -215
        freeplay.x, freeplay.y = -300, -60
        options.x, options.y = -250, 95
        credits.x, credits.y = -200, 250

        characters = love.filesystem.load("sprites/mikuMenu/mainmenuCharacters.lua")()
        characters.x = 100

		graphics:mikuTransitionIn()
	end,

	update = function(self, dt)
		for i = 0, 9 do
			mikuBG.lines[i]:update(dt)
		end
		mikuBG.triangles:update(dt)
        
        storymode:update(dt)
        freeplay:update(dt)
        options:update(dt)
        credits:update(dt)

		if not graphics.isFading() then
			if input:pressed("up") then
				audio.playSound(selectSound)

                menuButton = menuButton ~= 1 and menuButton - 1 or 4

                changeSelect()

			elseif input:pressed("down") then
				audio.playSound(selectSound)

                menuButton = menuButton ~= 4 and menuButton + 1 or 1

                changeSelect()

			elseif input:pressed("confirm") then
				audio.playSound(confirmSound)

				confirmFunc()
			elseif input:pressed("back") then
				audio.playSound(selectSound)

				Gamestate.switch(menu)
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
            love.graphics.setFont(uiFont)
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
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
                graphics.setColor(1,1,1,characters.alpha)
                characters:draw()
                graphics.setColor(1,1,1)
                storymode:draw()
                freeplay:draw()
                options:draw()
                credits:draw()
            love.graphics.pop()
            bars:draw()
            love.graphics.push()
                graphics.setColor(0,0,0)
                love.graphics.print("Vanilla Engine " .. (__VERSION__ or "???") .. "\nBuilt on: Funkin Rewritten v1.1.0 Beta 2", -635, -330)
                graphics.setColor(1,1,1)
                
            love.graphics.pop()
            love.graphics.setFont(font)
		love.graphics.pop()
        
	end,

	leave = function(self)
        
		Timer.clear()
	end
}