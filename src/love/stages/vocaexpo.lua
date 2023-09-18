return {
    enter = function()
        crowdSound = love.audio.newSource("sounds/Crowd.ogg", "stream")
        camera.defaultZoom = 0.8
        camera.zoom = 0.8
        stageImages = {
            bg2 = graphics.newImage(graphics.imagePath("vocaexpo/nightsky")),
            bg1 = graphics.newImage(graphics.imagePath("vocaexpo/backlight")),
            bg4 = graphics.newImage(graphics.imagePath("vocaexpo/concerttop")),
            bg3 = graphics.newImage(graphics.imagePath("vocaexpo/stadiumback")),
            bg5 = graphics.newImage(graphics.imagePath("vocaexpo/speakers")),
            bg = graphics.newImage(graphics.imagePath("vocaexpo/mainstage")),

            fiestaSalsa2 = love.filesystem.load("sprites/expo/crowdbump.lua")(),
            fiestaSalsa = love.filesystem.load("sprites/expo/spotlightdance.lua")(),
            bgblack = graphics.newImage(graphics.imagePath("blacksocool")),
        }

        stageImages.bgblack.alpha = 0
        stageImages.bg2.sizeX, stageImages.bg2.sizeY = 1.1, 1.1
        stageImages.bg1.sizeX, stageImages.bg1.sizeY = 1.1, 1.1
        stageImages.bg4.sizeX, stageImages.bg4.sizeY = 1.1, 1.1
        stageImages.bg3.sizeX, stageImages.bg3.sizeY = 1.1, 1.1
        stageImages.bg5.sizeX, stageImages.bg5.sizeY = 1.1, 1.1
        stageImages.bg.sizeX, stageImages.bg.sizeY = 1.1, 1.1
        stageImages.fiestaSalsa2.sizeX, stageImages.fiestaSalsa2.sizeY = 1.5, 1.5
        stageImages.fiestaSalsa.sizeX, stageImages.fiestaSalsa.sizeY = 1.3, 1.3
        stageImages.bgblack.sizeX, stageImages.bgblack.sizeY = 1.6, 1.6

        enemy = love.filesystem.load("sprites/characters/voca_miku.lua")()
        boyfriend = love.filesystem.load("sprites/characters/voca_bf.lua")()
        girlfriend = love.filesystem.load("sprites/characters/voca_gf.lua")()

        girlfriend.x, girlfriend.y = 30, -10
        enemy.x, enemy.y = -325, 10
        boyfriend.x, boyfriend.y = 345, 135

        stageImages.fiestaSalsa.visible = false
        stageImages.fiestaSalsa2.visible = true
        stageImages.fiestaSalsa2.y = 512

        stageImages.bgblack.visible = false
    end,

    load = function()

    end,

    update = function(self, dt)
        if beatHandler.onBeat() then
            local curBeat = beatHandler.curBeat

            if (song == 1 and combo > 50 and curBeat > 566) or (song == 2 and combo > 50 and curBeat > 269) then
                stageImages.fiestaSalsa2:animate("cheer", false)
            else
                stageImages.fiestaSalsa2:animate("dance", false)
            end

            if curBeat % 2 == 0 then
                stageImages.fiestaSalsa:animate("light1", false)
            elseif curBeat % 2 == 1 then
                stageImages.fiestaSalsa:animate("light2", false)
            end

            -- envents 
            if song == 3 then
                if curBeat == 320 then
                    stageImages.bgblack.alpha = 0
                    stageImages.bgblack.visible = true
                    -- in out quart
                    Timer.tween(2.5, stageImages.bgblack, {alpha=1}, "in-out-quart")
                end
            end

            -- combo sounds
            if song == 1 and (combo > 50 and curBeat == 312) then
                audio.playSound(crowdSound)
            end

            -- perfect popups
        end
    end,

    draw = function()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.6, camera.y * 0.6)
            love.graphics.translate(camera.ex * 0.6, camera.ey * 0.6)
            stageImages.bg2:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.7, camera.y * 0.7)
            love.graphics.translate(camera.ex * 0.7, camera.ey * 0.7)
            stageImages.bg1:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.75, camera.y * 0.75)
            love.graphics.translate(camera.ex * 0.75, camera.ey * 0.75)
            stageImages.bg4:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.8, camera.y * 0.8)
            love.graphics.translate(camera.ex * 0.8, camera.ey * 0.8)
            stageImages.bg3:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.translate(camera.ex * 0.9, camera.ey * 0.9)
            stageImages.bg5:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.translate(camera.ex, camera.ey)
            stageImages.bg:draw()
            girlfriend:draw()
            enemy:draw()
            boyfriend:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.translate(camera.ex * 0.9, camera.ey * 0.9)
            stageImages.fiestaSalsa2:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.8, camera.y * 0.8)
            love.graphics.translate(camera.ex * 0.8, camera.ey * 0.8)
            graphics.setColor(1,1,1,0.75)
            stageImages.fiestaSalsa:draw()
            graphics.setColor(1,1,1,1)
        love.graphics.pop()
        graphics.setColor(1,1,1,stageImages.bgblack.alpha)
        stageImages.bgblack:draw()
        graphics.setColor(1,1,1,1)
    end,

    leave = function()
        for i, v in pairs(stageImages) do
            v = nil
		end

        graphics.clearCache()
    end
}