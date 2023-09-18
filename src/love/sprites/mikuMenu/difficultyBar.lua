return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("mikuMenu/difficultyBar")),
	-- Automatically generated from difficultyBar.xml
	{
		{x = 0, y = 0, width = 576, height = 116, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 1: difficulty slider easy0000
		{x = 0, y = 116, width = 576, height = 116, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 2: difficulty slider hard0000
		{x = 0, y = 232, width = 576, height = 116, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 3: difficulty slider normal0000
	},
	{
		["easy"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
        ["normal"] = {start = 3, stop = 3, speed = 24, offsetX = 0, offsetY = 0},
        ["hard"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"normal",
	true
)
