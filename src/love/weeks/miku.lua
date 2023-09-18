--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local stageBack, stageFront, curtains

-- Loid, Endurance, Voca

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		stages["expo"]:enter()

		song = songNum
		difficulty = songAppend
		curWeek = 1

		enemyIcon:animate("miku", false)
		boyfriendIcon:animate("boyfriend", false)

		drawEnemyNotes = true

		self:load()
	end,

	load = function(self)
		weeks:load()
		stages["expo"]:load()
		camera.ezoom = 1

		if song == 4 then
			inst = love.audio.newSource("songs/endless/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/endless/Voices.ogg", "stream")

			enemy = nil
			boyfriend = love.filesystem.load("sprites/characters/miku.lua")()
			girlfriend = love.filesystem.load("sprites/characters/carol_speaker.lua")()
			boyfriend.flipX = true
			boyfriend.x, boyfriend.y = 345, -20
			drawEnemyNotes = false

			enemyIcon:animate("carol", false)
			boyfriendIcon:animate("miku", false)
		elseif song == 3 then
			inst = love.audio.newSource("songs/voca/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/voca/Voices.ogg", "stream")
			stages["expo"]:leave()
			stages["vocaexpo"]:enter()
			stages["vocaexpo"]:load()

			if storyMode and not died then
				video = cutscene.video("videos/vocacutscene.ogv")
				video:play()
			end
		elseif song == 2 then
			inst = love.audio.newSource("songs/endurance/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/endurance/Voices.ogg", "stream")

			if storyMode and not died then
				video = cutscene.video("videos/endurancecutscene.ogv")
				video:play()
			end
		else
			inst = love.audio.newSource("songs/loid/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/loid/Voices.ogg", "stream")

			if storyMode and not died then
				video = cutscene.video("videos/loidcutscene.ogv")
				video:play()
			end
		end

		self:initUI()

		if not inCutscene then 
			weeks:setupCountdown()
		end
	end,

	initUI = function(self)
		weeks:initUI()

		if song == 4 then
			weeks:generateNotes("data/endless/endless" .. difficulty .. ".json")
			stageImages.fiestaSalsa2.visible = false
		elseif song == 3 then
			weeks:generateNotes("data/voca/voca" .. difficulty .. ".json")
		elseif song == 2 then
			weeks:generateNotes("data/endurance/endurance" .. difficulty .. ".json")
		else
			weeks:generateNotes("data/loid/loid" .. difficulty .. ".json")
		end
	end,

	update = function(self, dt)
		perfect:update(dt)
		weeks:update(dt)
		if song ~= 3 then
			stages["expo"]:update(dt)
		else
			stages["vocaexpo"]:update(dt)
		end

		if inCutscene then
			if not video:isPlaying() then 
				inCutscene = false
				video:destroy()
				weeks:setupCountdown()
			end
		end

		weeks:checkSongOver()

		weeks:updateUI(dt)

		if beatHandler.onBeat() then
            local curBeat = beatHandler.curBeat
            if song == 1 and curBeat == 566 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 2 and curBeat == 269 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 3 and curBeat == 324 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 4 and curBeat == 245 then
				perfect:animate("anim")
                perfect.visible = true
            end
			
			if misses == 0 and song == 4 and curBeat == 361 then
				stageImages.endless.visible = true
				stageImages.endless:animate("anim", true)
			end
        end
	end,

	draw = function(self)
		if inCutscene then 
            video:draw(true)
            return
        end
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)
			love.graphics.scale(camera.ezoom, camera.ezoom)

			if song ~= 3 then
				stages["expo"]:draw()
			else
				stages["vocaexpo"]:draw()
			end
		love.graphics.pop()

		love.graphics.push()
			love.graphics.translate(graphics.getWidth()/2, graphics.getHeight()/2)
			perfect:draw()
		love.graphics.pop()

		weeks:drawUI()
	end,

	keypressed = function(self, key)
		if key == "]" then
			-- skip song
			-- this is a debug feature, so it's not in the keybinds
			if inst then inst:stop() end
			if voices then voices:stop() end
			if storyMode and song < #weekMetaFAKE[weekNum][2] then
				weeks:saveData()
				song = song + 1

				curWeekData:load()
			else
				weeks:saveData()

				status.setLoading(true)

				graphics:fadeOutWipe(
					0.7,
					function()
						Gamestate.switch(menu)

						status.setLoading(false)
					end
				)
			end
		end
	end,

	leave = function(self)
		stages["expo"]:leave()

		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
		drawEnemyNotes = true
	end
}
