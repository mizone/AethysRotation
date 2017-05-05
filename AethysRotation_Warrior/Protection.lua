--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- AethysCore
local AC = AethysCore;
local Cache = AethysCache;
local Unit = AC.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = AC.Spell;
local Item = AC.Item;
-- AethysRotation
local AR = AethysRotation;
-- Lua


--- APL Local Vars
-- Commons
  local Everyone = AR.Commons.Everyone;
-- Spells
  if not Spell.Warrior then Spell.Warrior = {}; end
  Spell.Warrior.Protection = {
    -- Racials
    ArcaneTorrent                 = Spell(69179),
    Berserking                    = Spell(26297),
    BloodFury                     = Spell(20572),
    Shadowmeld                    = Spell(58984),
    -- Abilities
    Devastate                     = Spell(20243),
    Berserkerrage                 = Spell(18499),
    Heroicthrow                   = Spell(57755),
    Intercept                     = Spell(198304),
    Revenge                       = Spell(6572),
    Shieldslam                    = Spell(23922),
    Spellreflection               = Spell(23920),
    Taunt                         = Spell(355),
    BattleCry                     = Spell(1719),
    BerserkerRage                 = Spell(18499),
    Demoralizingshout             = Spell(1160),
    -- Talents
    Avatar                        = Spell(107574),
	Shockwave                     = Spell(46968),
    Stormsolt                     = Spell(107570),
	Impendingvictory              = Spell(202168),
	Devastator                    = Spell(236279),
	Boomingvoice                  = Spell(202743),
	Vengeance                     = Spell(202572),
	Ravager                       = Spell(228920),
    -- Artifact
    Neltharionsfury               = Spell(203524),
    -- Defensive
	VictoryRush                   = Spell(34428),
	Ignorepain                    = Spell(190456),
    Laststand                     = Spell(12975),
	Shieldblock                   = Spell(2565),
	Shieldwall                    = Spell(871),
	
    -- Utility
	Pummel                        = Spell(6552),
	Thunderclap                   = Spell(6343),
    -- Legendaries
    StoneHeart                    = Spell(225947),
    -- Misc
	Victorious                    = Spell(32216),
	Vengeancerevenge              = Spell(202573),
	Heavyrepercussions            = Spell(203177),
    Vengeanceignorepain           = Spell(202574),
    Shieldblocks                  = Spell(132404),
	Revenges                      = Spell(5302)
  };
  local S = Spell.Warrior.Protection;
-- Items
  if not Item.Warrior then Item.Warrior = {}; end
  Item.Warrior.Protection = {
    DraughtofSouls                = Item(140808),
    ConvergenceofFates            = Item(140806),
    -- Legendaries
  };
  local I = Item.Warrior.Protection;
-- Rotation Var
  local ShouldReturn; -- Used to get the return string
-- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Commons = AR.GUISettings.APL.Warrior.Commons,
    Protection = AR.GUISettings.APL.Warrior.Protection
  };
 

--- APL Action Lists (and Variables)

-- APL Main
local function APL ()
    -- Unit Update
      AC.GetEnemies(8);
      AC.GetEnemies(14);
      Everyone.AoEToggleEnemiesUpdate();
  --- Out of Combat
  if not Target:IsInRange(8) and Target:IsInRange(25) and S.Intercept:IsCastable() then
          if AR.Cast(S.Intercept, Settings.Commons.OffGCDasOffGCD.Intercept) then return ""; end
        end
    --if not Player:AffectingCombat() then
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ DBM Count
      -- Opener
     -- return;
    --end
  --- In Combat
   if Everyone.TargetIsValid()  and Target:IsInRange(5) then
       
	    if S.VictoryRush:IsCastable() and Player:Buff(S.Victorious) and Player:HealthPercentage() <= 85 then
           if AR.Cast(S.VictoryRush, Settings.Commons.OffGCDasOffGCD.VictoryRush) then return "Cast"; end
		end
       if Settings.General.InterruptEnabled and S.Pummel:IsCastable() and Target:IsInterruptible() then
         if AR.Cast(S.Pummel, Settings.Commons.OffGCDasOffGCD.Pummel) then return "Cast Kick"; end
	   end 
	--actions.prot=spell_reflection,if=incoming_damage_2500ms>health.max*0.20
    --actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20&!talent.booming_voice.enabled
    --actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.40
    --actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.40&!cooldown.last_stand.remains=0
    --actions.prot+=/potion,name=unbending_potion,if=(incoming_damage_2500ms>health.max*0.15&!buff.potion.up)|target.time_to_die<=25
    --actions.prot+=/battle_cry,if=cooldown.shield_slam.remains=0
	if S.BattleCry:IsCastable() and S.Shieldslam:Cooldown() == 0 then
      if AR.Cast(S.BattleCry) then return ""; end
    end
    --actions.prot+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
	if S.Demoralizingshout:IsCastable() and S.Boomingvoice:IsAvailable() and  Player:Buff(S.BattleCry) then
      if AR.Cast(S.Demoralizingshout) then return ""; end
    end
    --actions.prot+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
	if S.Ravager:IsCastable() and S.Ravager:IsAvailable() and  Player:Buff(S.BattleCry) then
      if AR.Cast(S.Ravager) then return ""; end
	  end
    --actions.prot+=/neltharions_fury,if=!buff.shield_block.up&cooldown.shield_block.remains>3&((cooldown.shield_slam.remains>3&talent.heavy_repercussions.enabled)|(!talent.heavy_repercussions.enabled))
	if S.Neltharionsfury:IsCastable() and not Player:Buff(S.Shieldblocks) and S.Shieldblock:Cooldown() > 3 and ( ( S.Shieldslam:Cooldown() > 3 and S.Heavyrepercussions:IsAvailable() ) or not S.Heavyrepercussions:IsAvailable() ) then
      if AR.Cast(S.Neltharionsfury) then return ""; end
    end
    --actions.prot+=/shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remains=0&talent.heavy_repercussions.enabled)|action.shield_block.charges=2|!talent.heavy_repercussions.enabled)
    if S.Shieldblock:IsCastable() and Player:Rage() >= 15 and not Player:Buff(S.Neltharionsfury) and ( ( S.Shieldslam:Cooldown() == 0 and  S.Heavyrepercussions:IsAvailable() ) or not S.Heavyrepercussions:IsAvailable() or S.Shieldblock:ChargesFractional() == 2 ) then
      if AR.Cast(S.Shieldblock, Settings.Protection.OffGCDasOffGCD.Shieldblock) then return ""; end
	  end
	--actions.prot+=/ignore_pain,if=(rage>=60&!talent.vengeance.enabled)|(buff.vengeance_ignore_pain.up&rage>=39)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage<30&!buff.revenge.react)
	if S.Ignorepain:IsCastable() and Player:Rage() >= 20 and ( ( Player:Rage() >= 60 and not S.Vengeance:IsAvailable() ) or (  Player:Buff(S.Vengeanceignorepain) and  Player:Rage() >= 39 ) or (  S.Vengeance:IsAvailable() and not Player:Buff(S.Vengeanceignorepain) and not Player:Buff(S.Vengeancerevenge) and Player:Rage() < 30 and Player:Buff(S.Revenges)  )   ) then
      if AR.Cast(S.Ignorepain) then return ""; end
    end
    --actions.prot+=/shield_slam,if=(!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up)&talent.heavy_repercussions.enabled)|!talent.heavy_repercussions.enabled
	if S.Shieldslam:IsCastable() and ( (  not ( S.Shieldblock:Cooldown() <= Player:GCD()*2 and not Player:Buff(S.Shieldblocks) ) and  S.Heavyrepercussions:IsAvailable()  ) or  not S.Heavyrepercussions:IsAvailable() ) then
      if AR.Cast(S.Shieldslam) then return ""; end
    end
    --actions.prot+=/thunder_clap
	if S.Thunderclap:IsCastable() then
      if AR.Cast(S.Thunderclap) then return ""; end
    end
    --actions.prot+=/revenge,if=(talent.vengeance.enabled&buff.revenge.react&!buff.vengeance_ignore_pain.up)|(buff.vengeance_revenge.up&rage>=59)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage>=69)|(!talent.vengeance.enabled&buff.revenge.react)
    if S.Revenge:IsCastable() and ( ( S.Vengeance:IsAvailable() and Player:Buff(S.Revenges) and not Player:Buff(S.Vengeanceignorepain) ) or ( Player:Buff(S.Vengeancerevenge) and  Player:Rage() >= 59 )      or  ( S.Vengeance:IsAvailable() and not Player:Buff(S.Vengeanceignorepain) and not Player:Buff(S.Vengeancerevenge) and Player:Rage() >= 69 ) or  ( not S.Vengeance:IsAvailable() and Player:Buff(S.Revenges) ) ) then
      if AR.Cast(S.Revenge) then return ""; end
    end
	--actions.prot+=/devastate
	if S.Devastate:IsCastable() and not S.Devastator:IsAvailable() then
      if AR.Cast(S.Devastate) then return ""; end
    end
    return;
	end
end       
AR.SetAPL(73, APL);

--talents=1222312
