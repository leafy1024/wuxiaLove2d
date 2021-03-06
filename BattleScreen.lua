---
--- Created by ttwings.
--- DateTime: 2018/2/1 0:36
--- 战斗，单独切换出来，方便设计，同理一些小游戏，具体感觉类似 武林群侠传
local Screen = require( "lib/Screen" )
local actorData = require("assets.data.actorData")
local sti = require "sti"
local GameScreen = {}
local battleMap = map
local world
local tx, ty
local canvas = love.graphics.newCanvas()
local tx
local ty
---@language C
local code =[[
vec4 effect(vec4 color,Image texture,vec2 tc,vec2 sc){
	return Texel(texture,vec2((tc.x-0.5)/(tc.y + 1.5)+0.5,tc.y));
}
]]

local shader = love.graphics.newShader(code)
-- npc table
local function canvasLoad()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    battleMap:draw(-tx,-ty)
    battleMap:box2d_draw(-tx,-ty)
    love.graphics.setCanvas()
end
region = {}
local function loadData(  )
    -- actor class
    ---@param actor actorData
    actor=Actor:new(actorData["虚竹"])

    local font = love.graphics.newFont("assets/font/myfont.ttf", 20)
    love.graphics.setFont(font)
    battleMap = sti("assets/tileMaps/wuguan.lua",{"box2d"})
    -- Prepare translations
    tx, ty = 0, 0
    -- Prepare physics world
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 0)
    battleMap:box2d_init(world)
    -- Create a Custom Layer
    battleMap:addCustomLayer("Sprite Layer", 5)
    -- Add data to Custom Layer
    local spriteLayer = battleMap.layers["Sprite Layer"]

    spriteLayer.sprites = {
        player = {}

    }
    -- Update callback for Custom Layer
    region.objs =  battleMap.layers["objs"].objects
    region.actors = battleMap.layers["sprites"].objects
    npcs:load()
    function spriteLayer:update(dt)
        for _, sprite in pairs(self.sprites) do

        end
    end
    --
    function spriteLayer:draw()
        for _, sprite in pairs(self.sprites) do
            actor:drawAnim()
            actor:draw()
            npcs:drawAnim()
            animations.draw()

        end
    end
    canvasLoad()
end
GameScreen.cam = {}
function GameScreen.new(  )
    local self=Screen.new()
    GameScreen.cam = Camera.new(0,0,1280,800)

    loadData()

    function self:draw()
        --love.graphics.setShader(shader)

        GameScreen.cam:draw(function()
            love.graphics.draw(canvas)
        end)
        --love.graphics.setShader()
        -- GUI
        guiDraw()
        love.graphics.print("FPS:" .. love.timer.getFPS(),1220,0)
        date.draw()
    end

    function self:update( dt )
        world:update(dt)
        battleMap:update(dt)
        actor:update(dt)
        npcs:update(dt)
        -- 地图的位移
        tx = math.floor((actor.x - 1280/2))
        ty = math.floor((actor.y - 800/2))
        -- 画布
        canvasLoad()
        guiUpdata(actor,dt)
        animations.update(dt)
        date.update()
        --		GameScreen.cam:shakeUpdate()
    end
    function self:keypressed(key)
        actor:keypressed(key)
    end
    return self
end

return GameScreen