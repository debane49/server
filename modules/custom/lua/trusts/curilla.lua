-----------------------------------
-- Trust: Curilla
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
-----------------------------------
local m = Module:new('curilla')

local trustToReplaceName = 'curilla'


m:addOverride(string.format('xi.actions.spells.trust.%s.onMobSpawn', trustToReplaceName), function(mob)
    --[[
        Summon: With your courage and valor, Altana's children will live to see a brighter day.
        Summon (Formerly): Let the Royal Family’s blade be seared forever into their memories!
    ]]
    xi.trust.message(mob, xi.trust.messageOffset.SPAWN)



    local defBonus = mob:getMainLvl() * 1.1
    mob:addStatusEffect(xi.effect.MAX_MP_BOOST, 30, 0, 0)
    mob:setMP(mob:getMaxMP())
    mob:addMod(xi.mod.CURE_POTENCY, 50)
	mob:addMod(xi.mod.SPELLINTERRUPT, 35)
	mob:addMod(xi.mod.REFRESH, 2)
	mob:addMod(xi.mod.ENMITY, 50)
    mob:addMod(xi.mod.CURE2MP_PERCENT, 3)
    mob:addMod(xi.mod.ABSORB_PHYSDMG_TO_MP, 3)
    mob:addMod(xi.mod.REPRISAL_SPIKES_BONUS, 400)
	mob:addMod(xi.mod.DEF, defBonus)
    mob:setMobMod(xi.mobMod.CAN_SHIELD_BLOCK, 1)
    mob:setMod(xi.mod.SHIELDBLOCKRATE, 50)

    -- Special counters
    mob:addSimpleGambit(ai.t.TARGET, ai.c.STATUS, xi.effect.CHAINSPELL, ai.r.JA, ai.s.SPECIFIC, xi.ja.RAMPART)
    mob:addSimpleGambit(ai.t.TARGET, ai.c.STATUS, xi.effect.MANAFONT, ai.r.JA, ai.s.SPECIFIC, xi.ja.RAMPART)
    mob:addSimpleGambit(ai.t.TARGET, ai.c.STATUS, xi.effect.ASTRAL_FLOW, ai.r.JA, ai.s.SPECIFIC, xi.ja.RAMPART)
    mob:addSimpleGambit(ai.t.TARGET, ai.c.IS_ECOSYSTEM, xi.ecosystem.UNDEAD, ai.r.JA, ai.s.SPECIFIC, xi.ja.HOLY_CIRCLE)
    mob:addSimpleGambit(ai.t.TARGET, ai.c.IS_ECOSYSTEM, xi.ecosystem.UNDEAD, ai.r.JA, ai.s.SPECIFIC, xi.ja.SEPULCHER)
    mob:addSimpleGambit(ai.t.SELF, ai.c.HPP_LT, 10, ai.r.JA, ai.s.SPECIFIC, xi.ja.INVINCIBLE)

    -- Enmity control
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_HAS_TOP_ENMITY, 0, ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE)
    mob:addSimpleGambit(ai.t.TARGET, ai.c.NOT_STATUS, xi.effect.FLASH, ai.r.JA, ai.s.SPECIFIC, xi.ja.DIVINE_EMBLEM)      -- uses DE specifically with flash for enmity boost.
    mob:addSimpleGambit(ai.t.TARGET, ai.c.ALWAYS, 0, ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH)
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_STATUS, xi.effect.MAJESTY, ai.r.JA, ai.s.SPECIFIC, xi.ja.MAJESTY)
    mob:addSimpleGambit(ai.t.PARTY, ai.c.HPP_LT, 50, ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE)

    -- Self Buffs
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_STATUS, xi.effect.SENTINEL, ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL)          -- Uses SENTINEL first
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_STATUS, xi.effect.SENTINEL, ai.r.JA, ai.s.SPECIFIC, xi.ja.DEFENDER)          -- Uses Defender when SENTINEL wears
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_STATUS, xi.effect.REPRISAL, ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.REPRISAL) -- Uses REPRISAL first
    mob:addSimpleGambit(ai.t.SELF, ai.c.NOT_STATUS, xi.effect.REPRISAL, ai.r.JA, ai.s.SPECIFIC, xi.ja.PALISADE)          -- Uses Palisade when REPRISAL wears

    -- Sleep counter
    mob:addSimpleGambit(ai.t.PARTY, ai.c.STATUS, xi.effect.SLEEP_I, ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE)         -- wakes up sleepers
    mob:addSimpleGambit(ai.t.PARTY, ai.c.STATUS, xi.effect.SLEEP_II, ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE)        -- wakes up sleepers

    -- MP recovery
    mob:addSimpleGambit(ai.t.SELF, ai.c.MPP_LT, 50, ai.r.JA, ai.s.SPECIFIC, xi.ja.CHIVALRY)

    mob:setTrustTPSkillSettings(ai.tp.ASAP, ai.s.HIGHEST)

end)

return m
