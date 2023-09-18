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

		stages["concert"]:enter()

		song = songNum
		difficulty = songAppend
		curWeek = 1

		enemyIcon:animate("tricky", false)
		boyfriendIcon:animate("miku", false)

		girlfriend = nil
		boyfriend = love.filesystem.load("sprites/characters/miku.lua")()
		boyfriend.flipX = true
		enemy = love.filesystem.load("sprites/characters/tricky.lua")()

        enemy.x, enemy.y = -325, 10
        boyfriend.x, boyfriend.y = 345, -20

        drawEnemyNotes = true

		self:load()
	end,

	load = function(self)
		weeks:load()
		stages["concert"]:load()

		inst = love.audio.newSource("songs/tutorial/Inst.ogg", "stream")
		voices = love.audio.newSource("songs/tutorial/Voices.ogg", "stream")

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		weeks:generateNotes("data/tutorial/tutorial" .. difficulty .. ".json")
	end,

	update = function(self, dt)
        perfect:update(dt)
		weeks:update(dt)
		stages["concert"]:update(dt)

		weeks:checkSongOver()

		weeks:updateUI(dt)

        if beatHandler.onBeat() then
            local curBeat = beatHandler.curBeat
            if song == 1 and curBeat == 113 and misses == 0 then
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
