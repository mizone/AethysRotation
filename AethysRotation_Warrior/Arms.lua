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
  Spell.Warrior.Arms = {
    -- Racials
    ArcaneTorrent                 = Spell(69179),
    Berserking                    = Spell(26297),
    BloodFury                     = Spell(20572),
    Shadowmeld                    = Spell(58984),
    -- Abilities
    BattleCry                     = Spell(1719),
    Bladestorm               = Spell(227847),
    Cleave                   = Spell(845),
    ColossusSmash            = Spell(167105),
    Execute                  = Spell(163201),
    MortalStrike             = Spell(12294),
    Whirlwind                = Spell(1680),
	Slam                     = Spell(1464),
    -- Talents
    Avatar                   = Spell(107574),
	FocusedRage              = Spell(207982),
    Overpower                = Spell(7384),
    Ravager                  = Spell(152277),
    Rend                     = Spell(772),
	Shockwave                = Spell(46968),
    StormBolt                = Spell(107570),
	Fervorofbattle           = Spell(202316),
	Sweepingstrikes          = Spell(202161),
	Inthekill                = Spell(215550),
    -- Artifact
    Warbreaker               = Spell(209577),
    -- Defensive
	VictoryRush              = Spell(34428),
    -- Utility
	Pummel                        = Spell(6552),
	Charge                        = Spell(100),
    -- Legendaries
 
    StoneHeart                    = Spell(225947),
    -- Misc
	-- Buff and Debuff
	ColossusSmashDebuff      = Spell(208086),
	Victorious               = Spell(32216),
	Shattereddefenses        = Spell(209706),
	Overpowers               = Spell(60503),
	Cleaves                  = Spell(188923)
  };
  local S = Spell.Warrior.Arms;
-- Items
  if not Item.Warrior then Item.Warrior = {}; end
  Item.Warrior.Arms = {
    DraughtofSouls                = Item(140808),
    ConvergenceofFates            = Item(140806)
    -- Legendaries
  };
  local I = Item.Warrior.Arms;
-- Rotation Var
  local ShouldReturn; -- Used to get the return string
-- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Commons = AR.GUISettings.APL.Warrior.Commons,
    Arms    = AR.GUISettings.APL.Warrior.Arms
  };


--- APL Action Lists (and Variables)
---- # cleaves
  local function Cleaves()
--    actions.cleave=mortal_strike
      if S.MortalStrike:IsCastable()  then
         if AR.Cast(S.MortalStrike) then return "Cast"; end
	  end 
--actions.cleave+=/execute,if=buff.stone_heart.react
      if S.Execute:IsCastable() and Player:Buff(S.StoneHeart) then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 

--actions.cleave+=/colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
      if S.ColossusSmash:IsCastable() and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.ColossusSmash) then return "Cast"; end
	  end 

--actions.cleave+=/warbreaker,if=buff.shattered_defenses.down
      if S.Warbreaker:IsCastable() and Target:IsInRange(5) and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.Warbreaker) then return "Cast"; end
	  end 

--actions.cleave+=/focused_rage,if=rage>100|buff.battle_cry_deadly_calm.up
 if S.FocusedRage:IsAvailable() and S.FocusedRage:IsCastable() and ( Player:Rage() > 100 or Player:Buff(S.BattleCry) ) then
	     if AR.Cast(S.FocusedRage) then return "Cast"; end
		 end
--actions.cleave+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
      if S.Whirlwind:IsCastable() and S.Fervorofbattle:IsAvailable() and  (Target:Debuff(S.ColossusSmashDebuff) or Player:PowerDeficit() <50)  and ( not S.FocusedRage:IsAvailable() or  Player:Buff(S.BattleCry) or Player:Buff(S.Cleave)  )  then
         if AR.Cast(S.Whirlwind) then return "Cast"; end
	  end 
--actions.cleave+=/rend,if=remains<=duration*0.3
      if S.Rend:IsAvailable() and S.Rend:IsCastable() and ( Target:DebuffRemains(S.Rend) < Target:DebuffDuration(S.Rend)*0.3 ) then
         if AR.Cast(S.Rend) then return "Cast"; end
	  end
--actions.cleave+=/bladestorm
      if S.Bladestorm:IsAvailable() and S.Bladestorm:IsCastable()  then
         if AR.Cast(S.Bladestorm) then return "Cast"; end
	  end
--actions.cleave+=/cleave
      if S.Cleave:IsCastable()  then
         if AR.Cast(S.Cleave) then return "Cast"; end
	  end
--actions.cleave+=/whirlwind,if=rage>40|buff.cleave.up
      if S.Whirlwind:IsCastable() and ( Player:Rage() > 40 or Player:Buff(S.Cleave)  )  then
         if AR.Cast(S.Whirlwind) then return "Cast"; end
	  end 
--actions.cleave+=/shockwave
      if S.Shockwave:IsAvailable() and S.Shockwave:IsCastable() then
         if AR.Cast(S.Shockwave) then return "Cast"; end
	  end
--actions.cleave+=/storm_bolt
      if S.StormBolt:IsAvailable() and S.StormBolt:IsCastable() then
         if AR.Cast(S.StormBolt) then return "Cast"; end
	  end
    return false;
  end

  --# AoE
  local function AoE ()
--    actions.aoe=mortal_strike,if=cooldown_react
      if S.MortalStrike:IsCastable()  then
         if AR.Cast(S.MortalStrike) then return "Cast"; end
	  end 
--actions.aoe+=/execute,if=buff.stone_heart.react
      if S.Execute:IsCastable() and Player:Buff(S.StoneHeart) then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.aoe+=/colossus_smash,if=cooldown_react&buff.shattered_defenses.down&buff.precise_strikes.down
      if S.ColossusSmash:IsCastable() and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.ColossusSmash) then return "Cast"; end
	  end 
--actions.aoe+=/warbreaker,if=buff.shattered_defenses.down
      if S.Warbreaker:IsCastable() and Target:IsInRange(5) and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.Warbreaker) then return "Cast"; end
	  end 
--actions.aoe+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
      if S.Whirlwind:IsCastable() and S.Fervorofbattle:IsAvailable() and  ( Target:Debuff(S.ColossusSmashDebuff) or Player:PowerDeficit() <50)  and ( not S.FocusedRage:IsAvailable() or  Player:Buff(S.BattleCry) or Player:Buff(S.Cleave)  )  then
         if AR.Cast(S.Whirlwind) then return "Cast"; end
	  end 
--actions.aoe+=/rend,if=remains<=duration*0.3
      if S.Rend:IsAvailable() and S.Rend:IsCastable() and ( Target:DebuffRemains(S.Rend) < Target:DebuffDuration(S.Rend)*0.3 ) then
         if AR.Cast(S.Rend) then return "Cast"; end
	  end
--actions.aoe+=/bladestorm
      if S.Bladestorm:IsAvailable() and S.Bladestorm:IsCastable()  then
         if AR.Cast(S.Bladestorm) then return "Cast"; end
	  end
--actions.aoe+=/cleave
      if S.Cleave:IsCastable()  then
         if AR.Cast(S.Cleave) then return "Cast"; end
	  end
--actions.aoe+=/execute,if=rage>90
      if S.Execute:IsCastable() and Player:Rage() > 90 and  Target:HealthPercentage() < 20 then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.aoe+=/whirlwind,if=rage>=40
      if S.Whirlwind:IsCastable() and  Player:Rage() > 40  then
         if AR.Cast(S.Whirlwind) then return "Cast"; end
	  end 
--actions.aoe+=/shockwave
      if S.Shockwave:IsAvailable() and S.Shockwave:IsCastable() then
         if AR.Cast(S.Shockwave) then return "Cast"; end
	  end
--actions.aoe+=/storm_bolt
      if S.StormBolt:IsAvailable() and S.StormBolt:IsCastable() then
         if AR.Cast(S.StormBolt) then return "Cast"; end
	  end
    return false;
  end 

  -- # execute
  local function execute ()
--actions.execute=mortal_strike,if=cooldown_react&buff.battle_cry.up&buff.focused_rage.stack=3
      if S.MortalStrike:IsCastable() and Player:Buff(S.BattleCry) and Player:BuffStack(S.FocusedRage) == 3 then
         if AR.Cast(S.MortalStrike) then return "Cast"; end
	  end 
--# actions.execute+=/heroic_charge,if=rage.deficit>=40&(!cooldown.heroic_leap.remains|swing.mh.remains>1.2)
--#Remove the # above to run out of melee and charge back in for rage.
--actions.execute+=/execute,if=buff.battle_cry_deadly_calm.up
      if S.Execute:IsCastable() and Player:Buff(S.BattleCry) then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.execute+=/colossus_smash,if=cooldown_react&buff.shattered_defenses.down
      if S.ColossusSmash:IsCastable() and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.ColossusSmash) then return "Cast"; end
	  end 
--actions.execute+=/execute,if=buff.shattered_defenses.up&(rage>=17.6|buff.stone_heart.react)
      if S.Execute:IsCastable() and Player:Buff(S.Shattereddefenses) and ( Player:Rage() >= 17.6 or  Player:Buff(S.StoneHeart)   )   then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.execute+=/mortal_strike,if=cooldown_react&equipped.archavons_heavy_hand&rage<60|talent.in_for_the_kill.enabled&buff.shattered_defenses.down
      if S.MortalStrike:IsCastable() and S.Inthekill:IsAvailable() and not Player:Buff(S.Shattereddefenses) then
         if AR.Cast(S.MortalStrike) then return "Cast"; end
	  end 
--actions.execute+=/execute,if=buff.shattered_defenses.down
      if S.Execute:IsCastable() and not Player:Buff(S.Shattereddefenses)  then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.execute+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets

    return false;
  end
  -- # single_target
  local function single_target ()
--actions.single=colossus_smash,if=cooldown_react&buff.shattered_defenses.down&(buff.battle_cry.down|buff.battle_cry.up&buff.battle_cry.remains>=gcd|buff.corrupted_blood_of_zakajz.remains>=gcd)
      if S.ColossusSmash:IsCastable() and ( not Player:Buff(S.Shattereddefenses) and ( not Player:Buff(S.BattleCry) or Player:Buff(S.BattleCry) and S.BattleCry:BuffRemains(S.BattleCry ) >= Player:GCD()  ) ) then
         if AR.Cast(S.ColossusSmash) then return "Cast"; end
	  end 
--# actions.single+=/heroic_charge,if=rage.deficit>=40&(!cooldown.heroic_leap.remains|swing.mh.remains>1.2)&buff.battle_cry.down
--#Remove the # above to run out of melee and charge back in for rage.
--actions.single+=/focused_rage,if=!buff.battle_cry_deadly_calm.up&buff.focused_rage.stack<3&!cooldown.colossus_smash.up&(rage>=50|debuff.colossus_smash.down|cooldown.battle_cry.remains<=8)|cooldown.battle_cry.remains<=8&cooldown.battle_cry.remains>0&rage>100
      if S.FocusedRage:IsAvailable() and S.FocusedRage:IsCastable() and ( not Player:Buff(S.BattleCry) and Player:BuffStack(S.FocusedRage) < 3  and not S.ColossusSmash:CooldownUp()  and ( Player:Rage() >= 50 or not Target:Debuff(S.ColossusSmashDebuff) or S.BattleCry:CooldownRemains() <= 8 ) or ( S.BattleCry:CooldownRemains() <= 8 and S.BattleCry:CooldownRemains() > 0 and   Player:Rage() > 100 ) ) then
	     if AR.Cast(S.FocusedRage) then return "Cast"; end
		 end
--actions.single+=/mortal_strike,if=cooldown.battle_cry.remains>8|!buff.battle_cry.up&buff.focused_rage.stack<3|buff.battle_cry.remains<=gcd
      if S.MortalStrike:IsCastable() and ( S.BattleCry:CooldownRemains() > 8 or  ( not Player:Buff(S.BattleCry)  and  Player:BuffStack(S.FocusedRage) < 3 ) or Player:BuffRemains(S.BattleCry) < Player:GCD() ) then
         if AR.Cast(S.MortalStrike) then return "Cast"; end
	  end 
--actions.single+=/execute,if=buff.stone_heart.react
      if S.Execute:IsCastable() and Player:Buff(S.StoneHeart) then
         if AR.Cast(S.Execute) then return "Cast"; end
	  end 
--actions.single+=/whirlwind,if=spell_targets.whirlwind>1|talent.fervor_of_battle.enabled
      if S.Whirlwind:IsCastable() and S.Fervorofbattle:IsAvailable() and Cache.EnemiesCount[8] > 1 then
         if AR.Cast(S.Whirlwind) then return "Cast"; end
	  end 
--actions.single+=/slam,if=spell_targets.whirlwind=1&!talent.fervor_of_battle.enabled
      if S.Slam:IsCastable() and not S.Fervorofbattle:IsAvailable() then
         if AR.Cast(S.Slam) then return "Cast"; end
	  end 
--actions.single+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets

    return false;
  end  

-- APL Main
local function APL ()
    -- Unit Update
      AC.GetEnemies(8);
      AC.GetEnemies(14);
      Everyone.AoEToggleEnemiesUpdate();
	  if not Target:IsInRange(8) and Target:IsInRange(25) and S.Charge:IsCastable() then
          if AR.Cast(S.Charge) then return ""; end
        end
 --- Out of Combat
   -- if not Player:AffectingCombat() then
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ DBM Count

      -- Opener

   -- end
  --- In Combat
  if Everyone.TargetIsValid() then
     if Settings.General.InterruptEnabled and Target:IsInRange(5) and S.Pummel:IsCastable() and Target:IsInterruptible() then
         if AR.Cast(S.Pummel, Settings.Commons.OffGCDasOffGCD.Pummel) then return "Cast Kick"; end
	 end 
	 if S.VictoryRush:IsCastable() and Player:Buff(S.Victorious) and Player:HealthPercentage() <= 85 then
           if AR.Cast(S.VictoryRush, Settings.Commons.OffGCDasOffGCD.VictoryRush) then return "Cast"; end
		end
--actions+=/battle_cry,if=gcd.remains<0.25&cooldown.avatar.remains>=10&(buff.shattered_defenses.up|cooldown.warbreaker.remains>7&cooldown.colossus_smash.remains>7|cooldown.colossus_smash.remains&debuff.colossus_smash.remains>gcd)|target.time_to_die<=7
     if S.BattleCry:IsCastable() and Target:IsInRange(5) and ( Player:GCDRemains() < 0.25 and S.Avatar:CooldownRemains() >= 10 and ( Player:Buff(S.Shattereddefenses) or  S.Warbreaker:CooldownRemains() > 7 and S.ColossusSmash:CooldownRemains() > 7 or S.ColossusSmash:CooldownUp() and Target:DebuffRemains(S.ColossusSmashDebuff) > Player:GCD() ) or  Target:TimeToDie() <= 7 )  then
	 if AR.Cast(S.BattleCry) then return "Cast"; end
	 end
--actions+=/avatar,if=gcd.remains<0.25&(buff.battle_cry.up|cooldown.battle_cry.remains<15)|target.time_to_die<=20
      if S.Avatar:IsAvailable() and S.Avatar:IsCastable() and Player:GCDRemains() < 0.25 and  ( Player:Buff(S.BattleCry) or  S.BattleCry:CooldownRemains() < 15 or Target:TimeToDie() <= 20 )  then
         if AR.Cast(S.Avatar) then return "Cast"; end
	  end
--actions+=/heroic_leap,if=(debuff.colossus_smash.down|debuff.colossus_smash.remains<2)&cooldown.colossus_smash.remains&equipped.weight_of_the_earth|!equipped.weight_of_the_earth&debuff.colossus_smash.up

--actions+=/rend,if=remains<gcd
      if S.Rend:IsAvailable() and S.Rend:IsCastable() and ( Target:DebuffRemains(S.Rend) < Player:GCD() or not Target:Debuff(S.Rend) ) then
         if AR.Cast(S.Rend) then return "Cast"; end
	  end
--actions+=/focused_rage,if=buff.battle_cry_deadly_calm.remains>cooldown.focused_rage.remains&(buff.focused_rage.stack<3|cooldown.mortal_strike.remains)
      if S.FocusedRage:IsAvailable() and S.FocusedRage:IsCastable() and ( Player:BuffRemains(S.BattleCry) > S.FocusedRage:CooldownRemains() and ( Player:BuffStack(S.FocusedRage) < 3 or S.MortalStrike:CooldownRemains() > 0 ) ) then
	     if AR.Cast(S.FocusedRage) then return "Cast"; end
		 end
		 --, Settings.Arms.OffGCDasOffGCD.FocusedRage
--actions+=/colossus_smash,if=cooldown_react&debuff.colossus_smash.remains<gcd
--      if S.ColossusSmash:IsCastable() and Target:DebuffRemains(S.ColossusSmashDebuff) < Player:GCD() then
 --        if AR.Cast(S.ColossusSmash) then return "Cast"; end
--		 end
--actions+=/warbreaker,if=debuff.colossus_smash.remains<gcd
      if S.Warbreaker:IsCastable() and Target:IsInRange(5) and Target:DebuffRemains(S.ColossusSmashDebuff) < Player:GCD() then
         if AR.Cast(S.Warbreaker) then return "Cast"; end
	  end 
--actions+=/ravager
      if S.Ravager:IsCastable() and S.Ravager:IsAvailable() then
         if AR.Cast(S.Ravager) then return "Cast"; end
	  end 
--actions+=/overpower,if=buff.overpower.react
      if S.Overpower:IsAvailable() and S.Overpower:IsCastable() and Player:Buff(S.Overpowers) then
         if AR.Cast(S.Overpower) then return "Cast"; end
	  end 
--actions+=/run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
      if Cache.EnemiesCount[8] >= 2  and S.Sweepingstrikes:IsAvailable() then
        ShouldReturn = Cleaves();
        if ShouldReturn then return ShouldReturn; end
      end
--actions+=/run_action_list,name=aoe,if=spell_targets.whirlwind>=5&!talent.sweeping_strikes.enabled
      if Cache.EnemiesCount[8] >= 5 and not S.Sweepingstrikes:IsAvailable() then
        ShouldReturn = AoE();
        if ShouldReturn then return ShouldReturn; end
      end
--actions+=/run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
      if Target:HealthPercentage() < 20 and Cache.EnemiesCount[8] < 5 then
        ShouldReturn = execute();
        if ShouldReturn then return ShouldReturn; end
      end
-- actions+=/call_action_list,name=single_target,if=target.health.pct>20
     if Target:HealthPercentage() > 20 then
       ShouldReturn = single_target();
        if ShouldReturn then return ShouldReturn; end
      end
      return;
    end
end       
AR.SetAPL(71, APL);

