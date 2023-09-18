local diffs = {"easy", "normal", "hard"}
local diffAppend = {"-easy", "", "-hard"}
local curDiff = 2
local curSong = 1

local songs = {}
local songArray = {}

local camFollow = {x=0, y=0}

local function getInstPath(songName)
    -- lowercase
    local songName = songName:gsub("^%l", string.upper)
    return "songs/" .. songName .. "/Inst.ogg"
end

local instMusic = nil
local goingBACK

return {
    group = Group(),
    addWeek = function(self, songs, weekNum, songCharacters)
        if songCharacters == nil then
            songCharacters = {"boyfriend"}
        end

        local num = 1
        for i = 1, #songs do            
            self:addSong(songs[i], weekNum, i, songCharacters[i])

            if #songCharacters ~= 1 then
                num = num + 1
            end
        end
    end,

    addSong = function(self, songName, weekNum, songNum, songCharacter)
        table.insert(songs, {
            name = songName,
            week = weekNum,
            songNum = songNum,
            char = songCharacter
        })
    end,

    enter = function(self)
        camera.x, camera.y = 0, 0
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

		record = graphics.newImage(graphics.imagePath("mikuMenu/recordsmall"))

		difficultyBar = love.filesystem.load("sprites/mikuMenu/difficultyBar.lua")()

		difficultyBar.x, difficultyBar.y = 375, -250

        self:addWeek({"Tutorial"}, 0, {"miku"})
        self:addWeek({"Loid", "Endurance", "Voca", "Endless"}, 1, {"miku"})
        self:addWeek({"PoPiPo", "Aishite", "SIU", "Disappearance"}, 2, {"miku", "miku", "miku", "miku-mad"})

        for i = 1, #songs do
            local songMenu = freeplayObj:new(50 + ((i-1) * 25), 215 + ((i-1) * 65), songs[i].name)
            songMenu.ID = i
            self.group:add(songMenu)
            table.insert(songArray, songMenu)
        end

        thumbnail = love.filesystem.load("sprites/mikuMenu/thumbnails.lua")()
        thumbnail.sizeX, thumbnail.sizeY = 0.9, 0.9
        thumbnail.x = 135
        thumbnail:animate("random")

        record.sizeX, record.sizeY = 0.85, 0.85
        record.x = 425
        record.y = -10

        self:changeSelection()
        goingBACK = false
    end,

    tweenThumbnail = function(self)
        if smallRecTwen then
            Timer.cancel(smallRecTwen)
        end
        if thumbnailTween then
            Timer.cancel(thumbnailTween)
        end
        if instMusic then instMusic:stop() end
        record.alpha = 0
        record.x = 300

        thumbnailTween = Timer.tween(0.2, thumbnail, {x=400, alpha = 0}, "in-cubic", function()
            if thumbnail:isAnimName(songs[curSong].name) then
                thumbnail:animate(songs[curSong].name, false)
            else
                thumbnail:animate("Random", false)
            end
            record.x = 375
            smallRecTwen = Timer.tween(0.2, thumbnail, {x=135, alpha = 1}, "out-cubic", function()
                smallRecTwen = Timer.after(0.5, 
                    function() 
                        smallRecTwen = Timer.tween(0.2, record, {x=325, alpha = 1}, "in-cubic") 

                        instMusic = love.audio.newSource(getInstPath(songs[curSong].name), "stream")
                        instMusic:setLooping(true)
                        instMusic:play()
                    end
                )
            end)
        end)
    end,

    update = function(self, dt)
        record.orientation = math.rad(math.deg(record.orientation) + 150 * dt)
        for i = 1, #songArray do
            songArray[i]:update(dt)
        end
		for i = 0, 9 do
			mikuBG.lines[i]:update(dt)
		end
		mikuBG.triangles:update(dt)

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
				music:stop()
				--Gamestate.switch(weekData[1], 1, diffAppend[curDiff], 1)
                local _curSong = songs[curSong]
                Gamestate.switch(
                    weekData[_curSong.week],
                    _curSong.songNum,
                    diffAppend[curDiff],
                    _curSong.week
                )
				status.setLoading(false)							
			end)
		end

        if input:pressed("down") then
            self:changeSelection(1)
        elseif input:pressed("up") then
            self:changeSelection(-1)
        end

        if input:pressed("back") then
            goingBACK = true
            audio.playSound(backSound)

            graphics:mikuTransitionOut(function()
                Gamestate.switch(menuSelect)
                status.setLoading(false)
            end)
        end

		difficultyBar:animate(diffs[curDiff])

        camera.x, camera.y = util.coolLerp(camera.x, camFollow.x, 0.1), util.coolLerp(camera.y, camFollow.y, 0.1)

        music:stop()
    end,

    changeSelection = function(self, change)
        audio.playSound(selectSound)
        local change = change or 0

        curSong = curSong + change

        if curSong < 1 then
            curSong = #songs
        end

        if curSong > #songs then
            curSong = 1
        end

        -- set x and y based of curSong * a num
        camFollow.x = -curSong * 50
        camFollow.y = -curSong * 130

        -- set animation
        for i = 1, #songArray do
            songArray[i].isSelected = false
            songArray[i]:play("idle", true)
            if i == curSong then
                songArray[i].isSelected = true
                songArray[i]:play("selected", true)
            end
        end

        self:tweenThumbnail()
    end,

    draw = function(self)
        --love.graphics.scale(0.5, 0.5)
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
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)

            self.group:draw()
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(graphics.getWidth()/2, graphics.getHeight()/2)
            
            love.graphics.push()
				bars:draw()

				difficultyBar:draw()

                graphics.setColor(1,1,1,record.alpha)
                record:draw()
                graphics.setColor(1,1,1,thumbnail.alpha)
                thumbnail:draw()
                graphics.setColor(1,1,1)
			love.graphics.pop()
        love.graphics.pop()
    end,

    leave = function()
        if goingBACK then
            music:play()
        end

        if instMusic then
            instMusic:stop()
        end

        -- clear songs table
        songs = {}
        songArray = {}
    end
}