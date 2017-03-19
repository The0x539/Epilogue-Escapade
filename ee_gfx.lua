local ee_gfx = {}

API.load("npcparse")
local pnpc = API.load("pnpc")

function ee_gfx.onDraw()
	for _,v in ipairs(NPC.get(-1,player.section)) do
		local npc = pnpc.wrap(v)
		if npc.data.id then
			npc.id,npc.data.id = npc.data.id,npc.id
		end
	end
end

function ee_gfx.onInitAPI()
	registerEvent(ee_gfx,"onDraw")
	registerEvent(ee_gfx,"onDrawEnd","onDraw")
end

return ee_gfx