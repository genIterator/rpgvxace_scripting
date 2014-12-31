#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  # Shop Screen
  ShopBuy         = "Kaufen"
  ShopSell        = "Verkaufen"
  ShopCancel      = "Abbrechen"
  Possession      = "in Besitz"

  # Status Screen
  ExpTotal        = "Erfahrung"
  ExpNext         = "bis LVL Up %s"

  # Save/Load Screen
  SaveMessage     = "Speichern unter?"
  LoadMessage     = "Welchen Spielstand laden?"
  File            = "Datei"

  # Display when there are multiple members
  PartyName       = "%s's Gruppe"

  # Basic Battle Messages
  Emerge          = "%s erscheinen!"
  Preemptive      = "%s ist im Vorteil!"
  Surprise        = "%s wurde überrascht!"
  EscapeStart     = "%s versucht zu fliehen!"
  EscapeFailure   = "Flucht fehlgeschlagen!"

  # Battle Ending Messages
  Victory         = "%s war siegreich!"
  Defeat          = "%s wurde besiegt."
  ObtainExp       = "%s EXP erhalten!"
  ObtainGold      = "%s\\G gefunden!"
  ObtainItem      = "%s gefunden!"
  LevelUp         = "%s erreicht %s %s!"
  ObtainSkill     = "%s erlernt!"

  # Use Item
  UseItem         = "%s benutzt %s!"

  # Critical Hit
  CriticalToEnemy = "Ein kritischer Treffer!!"
  CriticalToActor = "Ein schmerzhafter Treffer!!"

  # Results for Actions on Actors
  ActorDamage     = "%s erhält %s Schaden!"
  ActorRecovery   = "%s regeneriert %s %s!"
  ActorGain       = "%s erhält %s %s!"
  ActorLoss       = "%s verliert %s %s!"
  ActorDrain      = "%s wurden %s %s entzogen!"
  ActorNoDamage   = "%s nimmt keinen Schaden!"
  ActorNoHit      = "Daneben! %s nimmt keinen Schaden!"

  # Results for Actions on Enemies
  EnemyDamage     = "%s erhält %s Schaden!"
  EnemyRecovery   = "%s regeneriert %s %s!"
  EnemyGain       = "%s erhält %s %s!"
  EnemyLoss       = "%s verliert %s %s!"
  EnemyDrain      = "Entzieht %s %s von %s!"
  EnemyNoDamage   = "%s nimmt keinen Schaden!"
  EnemyNoHit      = "Daneben! %s nimmt keinen Schaden!"

  # Evasion/Reflection
  Evasion         = "%s weicht dem Angriff aus!"
  MagicEvasion    = "%s weicht dem Zauber aus!"
  MagicReflection = "%s reflektiert den Zauber!"
  CounterAttack   = "%s kontert!"
  Substitute      = "%s schützt %s!"

  # Buff/Debuff
  BuffAdd         = "%ss %s steigt!"
  DebuffAdd       = "%ss %s sinkt!"
  BuffRemove      = "%ss %s ist wieder normal."

  # Skill or Item Had No Effect
  ActionFailure   = "Hat keine Wirkung auf %s!"

  # Error Message
  PlayerPosError  = "Player's starting position is not set."
  EventOverflow   = "Common event calls exceeded the limit."

  # Basic Status
  def self.basic(basic_id)
    $data_system.terms.basic[basic_id]
  end

  # Parameters
  def self.param(param_id)
    $data_system.terms.params[param_id]
  end

  # Equip Type
  def self.etype(etype_id)
    $data_system.terms.etypes[etype_id]
  end

  # Commands
  def self.command(command_id)
    $data_system.terms.commands[command_id]
  end

  # Currency Unit
  def self.currency_unit
    $data_system.currency_unit
  end

  #--------------------------------------------------------------------------
  def self.level;       basic(0);     end   # Level
  def self.level_a;     basic(1);     end   # Level (short)
  def self.hp;          basic(2);     end   # HP
  def self.hp_a;        basic(3);     end   # HP (short)
  def self.mp;          basic(4);     end   # MP
  def self.mp_a;        basic(5);     end   # MP (short)
  def self.tp;          basic(6);     end   # TP
  def self.tp_a;        basic(7);     end   # TP (short)
  def self.fight;       command(0);   end   # Fight
  def self.escape;      command(1);   end   # Escape
  def self.attack;      command(2);   end   # Attack
  def self.guard;       command(3);   end   # Guard
  def self.item;        command(4);   end   # Items
  def self.skill;       command(5);   end   # Skills
  def self.equip;       command(6);   end   # Equip
  def self.status;      command(7);   end   # Status
  def self.formation;   command(8);   end   # Change Formation
  def self.save;        command(9);   end   # Save
  def self.game_end;    command(10);  end   # Exit Game
  def self.weapon;      command(12);  end   # Weapons
  def self.armor;       command(13);  end   # Armor
  def self.key_item;    command(14);  end   # Key Items
  def self.equip2;      command(15);  end   # Change Equipment
  def self.optimize;    command(16);  end   # Ultimate Equipment
  def self.clear;       command(17);  end   # Remove All
  def self.new_game;    command(18);  end   # New Game
  def self.continue;    command(19);  end   # Continue
  def self.shutdown;    command(20);  end   # Shut Down
  def self.to_title;    command(21);  end   # Go to Title
  def self.cancel;      command(22);  end   # Cancel
  #--------------------------------------------------------------------------
end
