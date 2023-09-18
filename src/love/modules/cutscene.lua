local cutscene = {}

function cutscene.video(path)
    local video = {
        video = love.graphics.newVideo(path),
        finished = false,
        x = 0,
        y = 0,
        orientation = 0,
        scale = 1,
        offsetX = 0,
        offsetY = 0,
        shearX = 0,
        shearY = 0,

        play = function(self)
            self.video:play()
            self.finished = false
            inCutscene = true
        end,

        pause = function(self)
            self.video:pause()
        end,

        resume = function(self)
            self.video:resume()
        end,

        stopped = function(self, func)
            if not self.finished then
                if func then func() end
            end
        end,

        isPlaying = function(self, func)
            return self.video:isPlaying()
        end,

        draw = function(self, toWindowScale)
            -- toWindowScale will always be 1280x720, so resize it to that
            local sx, sy = self.scale, self.scale
            if toWindowScale then
                local videoWidth, videoHeight = self.video:getDimensions()

                -- towindowscale is a bool
                sx = 1280 / videoWidth
                sy = 720 / videoHeight
            end
            love.graphics.draw(
                self.video,
                self.x,
                self.y,
                self.orientation,
                sx,
                sy,
                self.offsetX,
                self.offsetY,
                self.shearX,
                self.shearY
            )
        end,

        destroy = function(self)
            self.video:release()
            collectgarbage()
        end
    }

    return video
end

return cutscene