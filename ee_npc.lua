local ee_npc = {}

local pnpc = API.load("pnpc")
local rng = API.load("rng")
local cam = Camera.get()[1]

--Everything to do with physics and movement
function ee_npc.onTick()
	--Steel Koopa, Steel Shell
	for _,v in ipairs(NPC.get({174,175},player.section)) do
		local npc = pnpc.wrap(v)
		if npc.speedY > 0 then
			npc.speedY = 12
		else
			npc.speedY = 0
		end
	end
	for _,p in ipairs(Player.get()) do
		if p.holdingNPC and p.TanookiStatueActive == 0 and p.ForcedAnimationState == 0 then
			if p.holdingNPC.id == 174 or p.holdingNPC.id == 175 then
				p.UpwardJumpingForce = math.min(p.UpwardJumpingForce,5)
				p.speedX = math.min(p.speedX,3)
				p.speedX = math.max(p.speedX,-3)
				p.upKeyPressing = false
			end
		end
	end
	
	--Tanooki Koopa
	for _,v in ipairs(NPC.get(173,player.section)) do
		local npc = pnpc.wrap(v)
		npc.data.jump = npc.data.jump or false
		npc.data.cd = npc.data.cd or 0
		if npc.data.jump and npc:mem(0x0A,FIELD_WORD) == 2 then
			npc.data.jump = false
			npc.data.cd = 30
		end
		if npc.data.cd > 0 then
			npc.data.cd = npc.data.cd - 1
		end
		if npc.x > player.x+player.width then
			if npc.direction == -1 then
				if npc.x-(player.x+player.width) < 160 and npc:mem(0x0A,FIELD_WORD) == 2 and npc.data.cd == 0 then
					npc.speedY = -8
					npc.data.jump = true
				end
			elseif npc.data.jump then
				npc.direction = -1
				npc:mem(0x0C,FIELD_WORD,0)
			end
		elseif npc.x+npc.width < player.x then
			if npc.direction == 1 then
				if player.x-(npc.x-npc.width) < 160 and npc:mem(0x0A,FIELD_WORD) == 2 and npc.data.cd == 0 then
					npc.speedY = -8
					npc.data.jump = true
				end
			elseif npc.data.jump then
				npc.direction = 1
				npc:mem(0x10,FIELD_WORD,0)
			end
		end
		npc.speedY = math.min(npc.speedY,1.5)
	end
	
	--Boo Swarm (WIP)
	for _,v in ipairs(NPC.get(211,player.section)) do
		v.x = rng.random(cam.x,cam.x+768)
		v.y = rng.random(cam.y,cam.y+96)
	end
	for _,v in ipairs(NPC.get(210,player.section)) do
		local npc = pnpc.wrap(v)
		if npc.speedY ~= 0 and not npc.data.foo then
			npc.data.foo = true
			npc.speedY = 2 * v.speedY
		end
		if npc.data.foo then
			npc.speedY = npc.speedY - 0.04
		end
	end
end

--Everything to do with graphics
function ee_npc.onTickEnd()
	--Boo alternating graphics
	for _,v in ipairs(NPC.get(38,player.section)) do
		local npc = pnpc.wrap(v)
		npc.data.age = npc.data.age or rng.randomInt(30)
		if npc.data.age % 30 < 15 then
			npc:mem(0xE4,FIELD_WORD,1+npc.direction)
		else
			npc:mem(0xE4,FIELD_WORD,2+npc.direction)
		end
		npc.data.age = npc.data.age + 1
	end
end

function ee_npc.onInitAPI()
	registerEvent(ee_npc,"onTick")
	registerEvent(ee_npc,"onTickEnd")
end

return ee_npc