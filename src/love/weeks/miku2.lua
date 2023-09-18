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
        girlfriend = nil
		stages["concert"]:enter()

		song = songNum
		difficulty = songAppend
        curWeek = 2

		enemyIcon:animate("miku", false)
		boyfriendIcon:animate("boyfriend", false)

		drawEnemyNotes = true

		self:load()
	end,

	load = function(self)
		weeks:load()
		stages["concert"]:load()
        if song == 4 then
            inst = love.audio.newSource("songs/disappearance/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/disappearance/Voices.ogg", "stream")
        elseif song == 3 then
			inst = love.audio.newSource("songs/siu/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/siu/Voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("songs/aishite/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/aishite/Voices.ogg", "stream")
		else
			inst = love.audio.newSource("songs/popipo/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/popipo/Voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

        if song == 4 then
            weeks:generateNotes("data/disappearance/disappearance" .. difficulty .. ".json")
        elseif song == 3 then
			weeks:generateNotes("data/siu/siu" .. difficulty .. ".json")
		elseif song == 2 then
			weeks:generateNotes("data/aishite/aishite" .. difficulty .. ".json")
		else
			weeks:generateNotes("data/popipo/popipo" .. difficulty .. ".json")
		end
	end,

	update = function(self, dt)
		perfect:update(dt)
		weeks:update(dt)
		stages["concert"]:update(dt)

		weeks:checkSongOver()

		weeks:updateUI(dt)

		if beatHandler.onBeat() then
            local curBeat = beatHandler.curBeat
            if song == 1 and curBeat == 245 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 2 and curBeat == 135 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 3 and curBeat == 263 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
			elseif song == 4 and curBeat == 389 and misses == 0 then
                perfect:animate("anim")
                perfect.visible = true
            end 
        end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)
            love.graphics.scale(camera.ezoom, camera.ezoom)

			stages["concert"]:draw()
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
		stages["concert"]:leave()

		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
	end
}
