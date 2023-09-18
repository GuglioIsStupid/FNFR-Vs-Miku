return {
    enter = function()
        crowdSound = love.audio.newSource("sounds/Crowd.ogg", "stream")
        camera.defaultZoom = 0.8
        camera.zoom = 0.8
        stageImages = {
            bg2 = graphics.newImage(graphics.imagePath("expo/nightsky")),
            bg1 = graphics.newImage(graphics.imagePath("expo/backlight")),
            bg4 = graphics.newImage(graphics.imagePath("expo/concerttop")),
            bg3 = graphics.newImage(graphics.imagePath("expo/stadiumback")),
            bg5 = graphics.newImage(graphics.imagePath("expo/speakers")),
            bg = graphics.newImage(graphics.imagePath("expo/mainstage")),

            fiestaSalsa2 = love.filesystem.load("sprites/expo/crowdbump.lua")(),
            light1 = graphics.newImage(graphics.imagePath("expo/focus_light")),
            fiestaSalsa = love.filesystem.load("sprites/expo/spotlightdance.lua")(),
            bgblack = graphics.newImage(graphics.imagePath("blacksocool")),

            endless = love.filesystem.load("sprites/endless.lua")(),
        }

        stageImages.light1.alpha = 1
        stageImages.bg2.sizeX, stageImages.bg2.sizeY = 1.1, 1.1
        stageImages.bg1.sizeX, stageImages.bg1.sizeY = 1.1, 1.1
        stageImages.bg4.sizeX, stageImages.bg4.sizeY = 1.1, 1.1
        stageImages.bg3.sizeX, stageImages.bg3.sizeY = 1.1, 1.1
        stageImages.bg5.sizeX, stageImages.bg5.sizeY = 1.1, 1.1
        stageImages.bg.sizeX, stageImages.bg.sizeY = 1.1, 1.1
        stageImages.fiestaSalsa2.sizeX, stageImages.fiestaSalsa2.sizeY = 1.5, 1.5
        stageImages.light1.sizeX, stageImages.light1.sizeY = 1.6, 1.6
        stageImages.fiestaSalsa.sizeX, stageImages.fiestaSalsa.sizeY = 1.3, 1.3
        stageImages.bgblack.sizeX, stageImages.bgblack.sizeY = 1.6, 1.6

        stageImages.endless.visible = false

        enemy = love.filesystem.load("sprites/characters/miku.lua")()

        girlfriend.x, girlfriend.y = 30, -10
        if enemy then enemy.x, enemy.y = -325, 10 end
        boyfriend.x, boyfriend.y = 345, 185

        stageImages.fiestaSalsa.visible = false
        stageImages.fiestaSalsa2.visible = true
        stageImages.fiestaSalsa2.y = 512

        stageImages.bgblack.visible = false
    end,

    load = function()
        stageImages.fiestaSalsa2:animate("dance")
    end,

    update = function(self, dt)
        stageImages.fiestaSalsa2:update(dt)
        stageImages.fiestaSalsa:update(dt)

        if (combo or 0) < 50 then
            stageImages.fiestaSalsa.visible = false
        else
            stageImages.fiestaSalsa.visible = true
        end

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

            if song == 1 then
                if curBeat == 494 then
                    enemy:animate("hey")
                end

                if curBeat > 493 and curBeat < 495 then
                    Timer.tween(0.2, camera, {ezoom=1.3}, "in-out-quad")
                end
            elseif song == 2 then
                if curBeat == 198 then
                    stageImages.bgblack.alpha = 0
                    stageImages.bgblack.visible = true
                    -- in out quart
                    Timer.tween(0.3, stageImages.bgblack, {alpha=1}, "in-out-quart")
                end

                if curBeat == 200 then
                    stageImages.light1.visible = true
                    Timer.tween(7.5, stageImages.bgblack, {alpha=0}, "in-out-quart")
                    Timer.tween(0.2, camera, {ezoom=1.3}, "in-out-quad")
                end

                if curBeat == 230 then
                    Timer.tween(5.9, camera, {ezoom=1}, "in-out-quad")
                end

                if curBeat == 264 then
                    stageImages.bgblack.visible = false
                    Timer.tween(0.4, stageImages.light1, {alpha=0}, "in-out-quart")
                end

                if curBeat == 266 then
                    stageImages.light1.visible = false
                end
            elseif song == 3 then
                if curBeat == 312 then
                    stageImages.bgblack.visible.alpha = 0
                    stageImages.bgblack.visible = true
                    -- in out quart
                    Timer.tween(2.5, stageImages.bgblack, {alpha=1}, "in-out-quart")
                end
            end

            -- combo sounds
            if song == 1 and (combo > 50 and curBeat == 566) then
                audio.playSound(crowdSound)
            elseif song == 2 and (combo > 50 and curBeat == 269) then
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
            love.graphics.translate(camera.x * 0.95, camera.y * 0.95)
            love.graphics.translate(camera.ex * 0.95, camera.ey * 0.95)
            stageImages.light1:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.translate(camera.ex, camera.ey)
            stageImages.bg:draw()
            girlfriend:draw()
            if enemy then enemy:draw() end
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

        love.graphics.push()
            love.graphics.translate(camera.x * 0.8, camera.y * 0.8)
            love.graphics.translate(camera.ex * 0.8, camera.ey * 0.8)
            graphics.setColor(1,1,1,0.75)
            stageImages.endless:draw()
            graphics.setColor(1,1,1,1)
        love.graphics.pop()

        graphics.setColor(1,1,1,stageImages.bgblack.alpha)
        stageImages.bgblack:draw()
        graphics.setColor(1,1,1)
    end,

    leave = function()
        for i, v in pairs(stageImages) do
            v = nil
		end

        graphics.clearCache()
    end
}