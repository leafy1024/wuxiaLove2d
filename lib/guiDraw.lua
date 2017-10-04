local lg=love.graphics
local lp=love.graphics.print
local lf=love.graphics.printf
local guiData = require "lib/guiData"
-- color
local colorT={
	["RED"]={255,0,0,255},
	["GREEN"]={0,255,0,255},
	["MAROON"]={0xb0,0x30,0x60,0xff},
	["VIOLET"]={0xee,0x82,0xee,0xff},
	["PURPLE"]={0xA0,0x20,0xf0,0xff},
	["BLUE"]={0xA0,0x20,0xf0,0xff},
}
local font = love.graphics.newFont("assets/font/msyh.ttf", 18)
local text = love.graphics.newText(font,"")
function guiDraw()
	local color={}
	for i, v in pairs( guiData ) do
		if v.visible and v.type=="txt"then
			-- text:setf({{255,255,0,255},v["contant"]})
			local color=colorT[v.color] or {255,255,255,255}
			text:set({color,v.contant})
			love.graphics.draw(text,v.x,v.y)
		elseif v.visible and v.type=="image" then
			local dir="assets/graphics/Faces/"
			local image = love.graphics.newImage(dir .. v.image)
			love.graphics.draw(image,v.x,v.y)
		elseif v.visible and v.type=="bar" then
			local maxHP=tonumber(v["contant"])
			-- lg.print(v["contant"])
			local color=colorT[v.color] or {255,255,255,255}
			text:set({color,v.title ..":"})
			love.graphics.draw(text,v.x,v.y)
			bar(maxHP,maxHP,v.x+50,v.y+26)
			-- bar(100,100,v.x+50,v.y+26)
		elseif v.visible and v.type=="long" then
			local alpha = v.alpha or 128
			local color = v.color or {255,255,255,255}
		    love.graphics.setColor(0, 0, 0, alpha)
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
			love.graphics.setColor(255, 255, 255, 255)
			text:setf({color,v.contant},v.width,"left")
			love.graphics.draw(text,v.x,v.y)
		elseif v.visible and v.type=="dialog" then
			local dir="assets/graphics/Faces/"
			local image = love.graphics.newImage(dir .. v.image)
			love.graphics.draw(image,v.x-image:getWidth(),v.y)
			local alpha = v.alpha or 128
			local color = v.color or {255,255,255,255}
		    love.graphics.setColor(0, 0, 0, alpha)
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
			love.graphics.setColor(255, 255, 255, 255)
			text:setf({color,v.contant},v.width,"left")
			love.graphics.draw(text,v.x,v.y)
		elseif v.visible and v.type=="map" then
			local alpha = v.alpha or 128
			local color = v.color or {255,255,255,255}
			love.graphics.print(v.title or "地图", v.x, v.y)
		    love.graphics.setColor(0, 0, 0, alpha)
			love.graphics.rectangle("fill", v.x, v.y+20, v.width, v.height)
			love.graphics.setColor(255, 255, 255, 255)
		elseif v.visible and v.type=="skill" then
			local alpha = v.alpha or 128
			local color = v.color or {255,255,255,255}
		    love.graphics.setColor(0, 0, 0, alpha)
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
			love.graphics.setColor(255, 255, 255, 255)
			text:setf({color,v.contant},v.width,v.align)
			love.graphics.draw(text,v.x,v.y+4)
		end
	end
end
--  table data
function guiUpdata(actor)
	guiData["头像"].image=actor["头像"]
	-- guiData["姓名"].contant=actor["姓名"]
	key2data("名称",actor)
	key2data("称号",actor)
	key2data("头衔",actor)
	-- gui["身份"].contant=actor["身份"]
	guiData["气血"].contant=actor["气血"]
	guiData["真气"].contant=actor["真气"]
	guiData["区域"].contant=actor["区域"]
	guiData["地图"].title=actor["区域"]
	guiData["房间"].contant=actor["房间"]
	guiData["描述"].contant=rooms[1]["long"]
	guiData["对话"].image=actor["头像"]
	-- gui["精力"].contant=actor["精力"]
	-- gui["食物"].contant=actor["食物"]
	-- gui["饮水"].contant=actor["饮水"]
	key2data("技能1",actor)
	key2data("技能2",actor)
	key2data("技能3",actor)
	key2data("技能4",actor)
end
-- table col
function key2data(key,actor)
	guiData[key].contant=key..":"..actor[key]
end
-- rec eg.hp,mp
function bar(nowHP,maxHP,x,y)
	love.graphics.rectangle("line",x,y-16,100,8)
	local nowHP = math.max(0,nowHP)
	local color = {r=255-nowHP*255/maxHP,g=nowHP*255/maxHP,b=0,a=255}
	love.graphics.setColor(color.r,color.g,color.b,color.a)
	love.graphics.rectangle("fill",x,y-16,nowHP*100/maxHP,8)
	love.graphics.setColor(255,255,255,255)
end
-- tonumber
