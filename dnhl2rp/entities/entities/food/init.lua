AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	phys:Wake()

	self.damage = 10
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end

function ENT:Use(activator,caller)
	caller:SetSelfDarkRPVar("Energy", math.Clamp((caller:getDarkRPVar("Energy") or 0) + 100, 0, 100))
	isDrink = false
	if self:GetModel()=="models/props_junk/PopCan01a.mdl" then isDrink = true end
	umsg.Start("AteFoodIcon", caller)
		umsg.Bool(isDrink);
	umsg.End()

	self:Remove()
end

function ENT:OnRemove()
	local ply = self:Getowning_ent()
	ply.maxFoods = ply.maxFoods and ply.maxFoods - 1 or 0
end