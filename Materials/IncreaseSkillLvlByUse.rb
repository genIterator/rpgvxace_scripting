=begin
IncreaseSkillLvlByUse, inspired by Learn Skills by Element use from Fomar0153
by spam
Version 0.1
----------------------
Notes
----------------------
No requirements
Allows you to learn new skills by using skills of the same element.
----------------------
Instructions
----------------------
You will need to edit module Fomar, further instructions
are located there.
----------------------
Change Log
----------------------
ver0.1 - Release
----------------------
Bugs
----------------------
None
=end
$imported = {} if $imported.nil?
$imported["IncreaseSkillLvlByUse"] = true

#==============================================================================
# ** Various tables and variables for the skillpoint system
# MONSTER_SK_MAX: Array[MonsterID] containing the max level until which the monster will give skillpoints
# MONSTER_SK_SCALE_FACTOR: Array[MonsterID] containing the scale factor for skillpoints the character gets
# SKILL_CLASS_MEMBERS: Array[[classIDs], ] contains which skill belongs to which class
# SKILL_TARGET_FRIENDLY: If a skill is intended for the Actors or for an enemy
# SKILL_CLASSES: Array containing every Skill Type in the game and its id in the skilldatabase
# SK_LEVEL: XP needed for 1 lvl Up
# SK_MAXLEVEL: Maximum level a skill can reach
# SK_XPPOINTS: XP gained for using a skill once
#==============================================================================
module SKILLINFO

  # Skilltypes. ID = Array ID for every Skilltype = ID  which skill belongs to which type = ID position for character skill array
  AXT = 0
  SCHWERT = 1
  STAB = 2
  ZWEIHAENDER = 3
  BOGEN = 4
  SPEER = 5
  DOLCH = 6
  HAMMER = 7
  KLAUE = 8
  SCHUSSWAFFE = 9
  ARMBRUST = 10
  PEITSCHE = 11
  FEUER = 12
  EIS = 13
  BLITZ = 14
  WASSER = 15
  ERDE = 16
  WIND = 17
  LICHT = 18
  SCHATTEN = 19
  CHAOS = 20

  # maximum level for Skillpoint XP
  MONSTER_SK_MAX = [99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99];

  # Skillpoint scaling factor for every monster
  MONSTER_SK_SCALE_FACTOR = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

  #Which Skill belongs to which class?
  SKILL_CLASS_MEMBERS = [[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[LICHT],[-1],[-1],[AXT],[AXT],[AXT],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[SCHWERT],[SCHWERT],[SCHWERT],[SCHWERT],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[STAB],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [ZWEIHAENDER],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[BOGEN],[BOGEN,SCHATTEN],[BOGEN],[BOGEN],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[SPEER],[SPEER],[-1],[SPEER,SCHATTEN],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[DOLCH],[DOLCH,FEUER],[DOLCH,EIS],[DOLCH,BLITZ],[DOLCH,WIND],
    [DOLCH,WASSER],[DOLCH,ERDE],[DOLCH,LICHT],[DOLCH,SCHATTEN],[DOLCH,SCHATTEN],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[HAMMER],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [KLAUE],[KLAUE,FEUER],[KLAUE,EIS],[KLAUE,BLITZ],[KLAUE,WASSER],[KLAUE,ERDE],[KLAUE,WIND],[KLAUE,LICHT],[KLAUE,SCHATTEN],[KLAUE,SCHATTEN],[KLAUE,SCHATTEN],[KLAUE,BLITZ],[KLAUE,BLITZ],[KLAUE,BLITZ],[KLAUE],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[SCHUSSWAFFE],[SCHUSSWAFFE],[SCHUSSWAFFE],[SCHUSSWAFFE,FEUER],[SCHUSSWAFFE,EIS],[SCHUSSWAFFE,BLITZ],[SCHUSSWAFFE,WASSER],[SCHUSSWAFFE,ERDE],[SCHUSSWAFFE,WIND],[SCHUSSWAFFE,LICHT],
    [SCHUSSWAFFE,SCHATTEN],[SCHUSSWAFFE,SCHATTEN],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[ARMBRUST],[ARMBRUST],[ARMBRUST,SCHATTEN],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[PEITSCHE],[PEITSCHE],[PEITSCHE],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],
    [FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER,ERDE],[FEUER,WIND],[FEUER,ERDE],[FEUER,ERDE],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[FEUER],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[WIND,SCHATTEN],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],[WIND],
    [WIND],[WIND],[WIND],[WIND],[WIND],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],
    [-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1],[-1]];

  #is the skill intended for enemies or actors
  SKILL_TARGET_FRIENDLY = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];

  #Array containing all Skill Classes and their location in the skill-database
  SKILL_CLASSES = [];
  SKILL_CLASSES[AXT] = [AXT, 129];
  SKILL_CLASSES[SCHWERT] = [SCHWERT, 169];
  SKILL_CLASSES[STAB] = [STAB, 209];
  SKILL_CLASSES[ZWEIHAENDER] = [ZWEIHAENDER, 249];
  SKILL_CLASSES[BOGEN] = [BOGEN, 289];
  SKILL_CLASSES[SPEER] = [SPEER, 329];
  SKILL_CLASSES[DOLCH] = [DOLCH, 369];
  SKILL_CLASSES[HAMMER] = [HAMMER, 409];
  SKILL_CLASSES[KLAUE] = [KLAUE, 449];
  SKILL_CLASSES[SCHUSSWAFFE] = [SCHUSSWAFFE, 489];
  SKILL_CLASSES[ARMBRUST] = [ARMBRUST, 529];
  SKILL_CLASSES[PEITSCHE] = [PEITSCHE, 569];
  SKILL_CLASSES[FEUER] = [FEUER, 609];
  SKILL_CLASSES[EIS] = [EIS, 649];
  SKILL_CLASSES[BLITZ] = [BLITZ, 689];
  SKILL_CLASSES[WASSER] = [WASSER, 729];
  SKILL_CLASSES[ERDE] = [ERDE, 769];
  SKILL_CLASSES[WIND] = [WIND, 809];
  SKILL_CLASSES[LICHT] = [LICHT, 849];
  SKILL_CLASSES[SCHATTEN] = [SCHATTEN, 889];
  SKILL_CLASSES[CHAOS] = [CHAOS, 969];

  #prevent unintentional editing
  MONSTER_SK_MAX.freeze();
  MONSTER_SK_SCALE_FACTOR.freeze();
  SKILL_CLASS_MEMBERS.freeze();
  SKILL_CLASSES.freeze();
  SKILL_TARGET_FRIENDLY.freeze();

  # need 100xp to level up
  SK_LEVEL = 100;
  #maximum levels a skill can reach
  SK_MAXLEVEL = 99;
  # XP given to player for using a skill once
  SK_XPPOINTS = 2;

  #modifier for skillXP if target is an actor
  SK_ACTOR_MODIFIER = 0.5;
end

#==============================================================================
# ** class for accessing the skills a player can learn
# ** somewhat crappy because its a global variable...
#==============================================================================
class ActorSkillLevelMaps

  attr_accessor(:learnedSkillTypes);
  attr_accessor (:actorSkills);
  attr_accessor (:skillsLearned);
  
  
  AXT = SKILLINFO::AXT
  SCHWERT = SKILLINFO::SCHWERT
  STAB = SKILLINFO::STAB
  ZWEIHAENDER = SKILLINFO::ZWEIHAENDER
  BOGEN = SKILLINFO::BOGEN
  SPEER = SKILLINFO::SPEER
  DOLCH = SKILLINFO::DOLCH
  HAMMER = SKILLINFO::HAMMER
  KLAUE = SKILLINFO::KLAUE
  SCHUSSWAFFE = SKILLINFO::SCHUSSWAFFE
  ARMBRUST = SKILLINFO::ARMBRUST
  PEITSCHE = SKILLINFO::PEITSCHE
  FEUER = SKILLINFO::FEUER
  EIS = SKILLINFO::EIS
  BLITZ = SKILLINFO::BLITZ
  WASSER = SKILLINFO::WASSER
  ERDE = SKILLINFO::ERDE
  WIND = SKILLINFO::WIND
  LICHT = SKILLINFO::LICHT
  SCHATTEN = SKILLINFO::SCHATTEN
  CHAOS = SKILLINFO::CHAOS
  def initialize

    #learnedSkillTypes[actorID] = [Axt, Schwert, Stab, Zweihaender, Bogen, Speer, Dolch, Hammer, Klaue, Schusswaffe, Armbrust, Peitsche, Feuer, Eis, Blitz, Wasser, Erde, Wind, Licht, Schatten, Chaos]
    @learnedSkillTypes = [];
    #empty
    @learnedSkillTypes[0] = [];
    #Falk:
    @learnedSkillTypes[1] = [1,0,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
    #Livia:
    @learnedSkillTypes[2] = [0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    #Shila:
    @learnedSkillTypes[3] = [0,1,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
    #Lazar:
    @learnedSkillTypes[4] = [1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
    #Torben:
    @learnedSkillTypes[5] = [];
    #Barin:
    @learnedSkillTypes[6] = [];

    #actorSkill[Characterindex] = [[SkillID, SkillRequirement 1, SKillLevelRequirement 1,SkillRequirement 2, SKillLevelRequirement 2, ...],[...]]
    @actorSkills = [];
    #empty array:
    @actorSkills[0] = [[]];
    #Falk:
    @actorSkills[1] = [[130,AXT,1], [131,AXT,3], [132,AXT,7], [51,AXT,30,BLITZ, 4], [52,SCHWERT,25], [101,ERDE,14], [33,FEUER,13], [45,EIS,7], [132,AXT,2,LICHT,3]];
    #Livia:
    @actorSkills[2] = [[45,EIS,7], [130,AXT,1], [145,ERDE,14], [130,AXT,4]];
    #Shila:
    @actorSkills[3] = [[132,AXT,3], [51,SCHWERT,7], [77,BLITZ,12,WASSER, 13], [89,CHAOS,9]];
    #Lazar:
    @actorSkills[4] = [[34,SCHWERT,30], [15,SCHWERT,13], [471,ERDE,47], [18,FEUER,11,ERDE, 3], [45,EIS,22]];
    #Torben:
    @actorSkills[5] = [[]];
    #Barin:
    @actorSkills[6] = [[]];

    @actorSkills.freeze();

    @skillsLearned = Array.new(SKILLINFO::SKILL_CLASSES.length){Array.new(SKILLINFO::SK_MAXLEVEL){Array.new()}};
    #generate Array containing every Skilltype and on which level an actor gets a new skill
    @actorSkills.each_with_index{|currActor, index|
      lastValue = nil;
      currActor.each{|currBlock|
        currBlock.each_with_index{|currElement, i|
          if ((i != 0) && (i % 2 == 0)) #last currElement was the Skilltype
            SKILLINFO::SKILL_CLASSES.each_with_index{|actClass, x|
              actClass.each{|actClassElem|
                if (actClassElem == lastValue)
                  @skillsLearned[x][currElement].push(index);
                end
              }
            }
          end
          lastValue = currElement;
        }
      }
    }
  end
end

class Scene_Base
  #initialize Skillsystem somewhere...
  alias startSKSystem start
  def start
    startSKSystem();
    #$setupSkillSystem is defined in DataManager init!
    if ($setupSkillSystem == true)
      $setupSkillSystem = false;
      $skillSystem = ActorSkillLevelMaps.new();
    end
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  #  Aliases setup
  #--------------------------------------------------------------------------
  attr_accessor (:skillTypeLevels);
  attr_accessor(:skillExp);

  alias seu_setup setup
  def setup(actor_id)
    seu_setup(actor_id)
    initSkillLevel = 2; # starting level for every Skill
    initSkillXP = 0.0 # starting XP for every Skill
    @skillTypeLevels = Array.new(SKILLINFO::SKILL_CLASSES.length, initSkillLevel);
    @skillExp = Array.new(SKILLINFO::SKILL_CLASSES.length, initSkillXP);
  end
end

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  #  Aliases item_apply
  #--------------------------------------------------------------------------
  alias seu_item_apply item_apply
  def item_apply(user, item)
    seu_item_apply(user, item)
    if (not $game_party.in_battle)
      if user.is_a?(Game_Actor) and item.is_a?(RPG::Skill)
        calculateSkillPointsInMenu(user, item)
      end
    end
  end

  #--------------------------------------------------------------------------
  # New method
  # basically a copy of the Scene_Battle version...
  #--------------------------------------------------------------------------
  def calculateSkillPointsInMenu(subject, item)

    calcStuff = false;
    #term shown when actor learns a new skill
    learnNewSkillMsg = " lernt ";

    skillTypeList = SKILLINFO::SKILL_CLASS_MEMBERS[item.id];
    skillTypeList.each{|currentSkill|

      #prevents power leveling with friendly skills
      if ((subject.skillTypeLevels[currentSkill] <= subject.level) && (subject.skillTypeLevels[currentSkill] <= SKILLINFO::SK_MAXLEVEL))
        if ($skillSystem.learnedSkillTypes[subject.id][currentSkill] == 1)
          #skillpoint formula for actors
          subject.skillExp[currentSkill] += (SKILLINFO::SK_XPPOINTS * SKILLINFO::SK_ACTOR_MODIFIER);
          calcStuff = true;
        end
      end
      if (calcStuff == true)
        if (subject.skillExp[currentSkill] >= SKILLINFO::SK_LEVEL)
          # Level up!
          subject.skillExp[currentSkill] -= SKILLINFO::SK_LEVEL;
          subject.skillTypeLevels[currentSkill] += 1;
          newLevel = subject.skillTypeLevels[currentSkill];
          # will character learn a new skill?
          if ($skillSystem.skillsLearned[currentSkill][newLevel].include?(subject.id))
            skillString = SKILLINFO::SKILL_CLASSES[currentSkill][0];
            lastValue = nil;
            requirements = nil;
            #search for possible new skills
            $skillSystem.actorSkills[subject.id].each{|elements|
              elements.each_with_index{|elem, i|
                if ((i != 0) && (i % 2 == 0))
                  if (lastValue == skillString)
                    if(newLevel == elem)
                      requirements = elements;
                      skillToLearn = requirements[0]
                      lastReq = nil;
                      learnSkill = false;
                      #does character know the skill already?
                      if (not subject.skill_learn?(skillToLearn))
                        requirements.each_with_index{|x, ix|
                          if ((ix != 0) && (ix % 2 == 0))
                            if(subject.skillTypeLevels[lastReq] == x)
                              learnSkill = true;
                            else
                              learnSkill = false;
                            end
                          end
                          lastReq = x;
                        }
                      end
                      if (learnSkill == true)
                        subject.learn_skill(skillToLearn);
                        #does not work...
                        #$game_message.add(subject.name() + learnNewSkillMsg + $data_skills[skillToLearn].name+"!");
                      end
                    end
                  end
                end
                lastValue = elem;
              }
            }
          end
        end
      end
    }
  end
end

class Scene_Battle < Scene_Base

  #--------------------------------------------------------------------------
  # Alias method
  # check if target is Actor or Enemy and calculate Skillpoints
  #--------------------------------------------------------------------------
  alias skSystem_use_item use_item
  def use_item
    skSystem_use_item();
    item = @subject.current_action.item;
    targets = @subject.current_action.make_targets.compact rescue [];

    if (@subject.is_a?(Game_Actor) && item.is_a?(RPG::Skill))
      targets.each {|target|
        #target is an enemy?
        if (target.is_a?(Game_Enemy))
          # only skills intended for ememies give XP
          if (not SKILLINFO::SKILL_TARGET_FRIENDLY[item.id])
            calculateSkillPoints(@subject, item, target, true)
          end
        else
          # target is an actor?
          if (target.is_a?(Game_Actor))
            #only skills intended for actors give XP
            if (SKILLINFO::SKILL_TARGET_FRIENDLY[item.id])
              calculateSkillPoints(@subject, item, target, false)
            end
          end
        end
      }
    end
  end

  #--------------------------------------------------------------------------
  # New method
  # adds XP for every skill uses (if applicable) and handles skill level ups and learning new skills
  #--------------------------------------------------------------------------
  def calculateSkillPoints(subject, item, target, enemy = true)

    calcStuff = false;
    #term shown when actor learns a new skill
    learnNewSkillMsg = " lernt ";

    skillTypeList = SKILLINFO::SKILL_CLASS_MEMBERS[item.id];
    skillTypeList.each{|currentSkill|      
      if ((currentSkill.is_a? Integer) && (currentSkill >= 1)) # only skills with a defined Skill Type can give XP!
        if (enemy == true)

          #Test if skill level <= Monster maximum Skillpoint level & skill level <= maximum allowed skill level
          if((subject.skillTypeLevels[currentSkill] <= SKILLINFO::MONSTER_SK_MAX[target.enemy_id]) && (subject.skillTypeLevels[currentSkill] <= SKILLINFO::SK_MAXLEVEL))
            if ($skillSystem.learnedSkillTypes[subject.id][currentSkill] == 1)
              #skillpoint formula for enemies
              subject.skillExp[currentSkill] += (SKILLINFO::SK_XPPOINTS * SKILLINFO::MONSTER_SK_SCALE_FACTOR[target.enemy_id]);
              calcStuff = true;
            end
          end
        else

          #prevents power leveling with friendly skills
          if ((subject.skillTypeLevels[currentSkill] <= target.level) && (subject.skillTypeLevels[currentSkill] <= SKILLINFO::SK_MAXLEVEL))
            #skillpoint formula for actors
            if ($skillSystem.learnedSkillTypes[subject.id][currentSkill] == 1)
              subject.skillExp[currentSkill] += (SKILLINFO::SK_XPPOINTS * SKILLINFO::SK_ACTOR_MODIFIER);
              calcStuff = true;
            end
          end
        end
      end
      if (calcStuff == true)
        if (subject.skillExp[currentSkill] >= SKILLINFO::SK_LEVEL)
          # Level up!
          subject.skillExp[currentSkill] -= SKILLINFO::SK_LEVEL;
          subject.skillTypeLevels[currentSkill] += 1;
          newLevel = subject.skillTypeLevels[currentSkill];
          # will character learn a new skill?
          if ($skillSystem.skillsLearned[currentSkill][newLevel].include?(subject.id))
            skillString = SKILLINFO::SKILL_CLASSES[currentSkill][0];
            lastValue = nil;
            requirements = nil;
            #search for possible new skills
            $skillSystem.actorSkills[subject.id].each{|elements|
              elements.each_with_index{|elem, i|
                if ((i != 0) && (i % 2 == 0))
                  if (lastValue == skillString)
                    if(newLevel == elem)
                      requirements = elements;
                      skillToLearn = requirements[0]
                      lastReq = nil;
                      learnSkill = false;
                      #does character know the skill already?
                      if (not subject.skill_learn?(skillToLearn))
                        requirements.each_with_index{|x, ix|
                          if ((ix != 0) && (ix % 2 == 0))
                            if(subject.skillTypeLevels[lastReq] == x)
                              learnSkill = true;
                            else
                              learnSkill = false;
                            end
                          end
                          lastReq = x;
                        }
                      end
                      if (learnSkill == true)
                        subject.learn_skill(skillToLearn);
                        $game_message.add(subject.name() + learnNewSkillMsg + $data_skills[skillToLearn].name+"!");
                      end
                    end
                  end
                end
                lastValue = elem;
              }
            }
          end
        end
      end
    }
  end

end

#--------------------------------------------------------------------------
# New Window
# shows skill progress for the current selected actor
#--------------------------------------------------------------------------
class Window_SkillProgress < Window_Selectable


  

  attr_accessor(:pageNumber);
  attr_accessor(:skillWindowTitle);
  def initialize(actor)
    super(0, 0, Graphics.width, Graphics.height);
    @actor = actor;
    @pageNumber = 1;
    # Text shown on the skill progress page
    @skillWindowTitle = "s Fertigkeiten Fortschritt";
    refresh();
    activate();
  end

  def refresh
    contents.clear
    draw_block1   (line_height * 0)
    draw_horz_line(line_height * 1)
    draw_block2   (line_height * 2)
  end

  def draw_block1(y)
    width = Graphics.width - 50;
    text = @actor.name + @skillWindowTitle;
    x = 4;
    change_color(hp_color(@actor))
    draw_text(x, y, width, line_height, text);
  end

  def draw_block2(y)
    skillName = " ";
    skillIndex = 0;
    skillIcon = 0;
    nextPageIconIndex = 183; # icon for the arrow, indicating more pages
    skillsPerPage = 14 #maximum number of skills+XP bars per page
    blockSize = skillsPerPage - 1; #maximum number of skills+XP bars that can be shown on one page + next button!    
    posX = 0;
    posY = y;
    spacing = 2;
    iconWidth = 24;
    currRate = 0.0;
    columnWidth = Graphics.width / 2;
    colorA = hp_gauge_color1; #color for XP bar
    colorB = hp_gauge_color2;
    numberOfSkillsCurrLearned = 0; 
    numberOfPages = 1.0;       
    numberOfPagesInt = 1;
    drawNextIcon = false;
    i = 0;
    skillListForCurrActor = []; #every skilltype the current actor currently knows


    # calculate number of skills the actor currently knows
    $skillSystem.learnedSkillTypes[@actor.id].each_with_index{|currActorSkill, idx| 
      if (currActorSkill == 1)
        numberOfSkillsCurrLearned += 1;
        skillListForCurrActor.push(idx);
      end
    }
    
    puts "skills the actor currently knows: "+ skillListForCurrActor.to_s()
        
    if (numberOfSkillsCurrLearned > skillsPerPage) #need to create multiple pages
      drawNextIcon = true;
      numberOfPages = numberOfSkillsCurrLearned / (blockSize).to_f();
      numberOfPagesInt = numberOfPages.ceil();
    end    
    
    # calculate which skills should be drawn
    # e.g. first pagecall will draw skills 0-12, second call skills 13-25, third 25-...
    lowerLimit = ((@pageNumber-1) % numberOfPagesInt) * blockSize;
    upperLimit = ((((@pageNumber-1) % numberOfPagesInt)+1)*blockSize)-1;
        
#    if (upperLimit > SKILLINFO::SKILL_CLASSES.length) # make sure the upperLimit does not get higher than the maximum number of available skills
#      upperLimit = SKILLINFO::SKILL_CLASSES.length-1;
#    end
    
    if (upperLimit > skillListForCurrActor.length) # make sure the upperLimit does not get higher than the maximum number of available skills
      upperLimit = skillListForCurrActor.length-1;
    end
    
    
    
    for index in lowerLimit..upperLimit
        skillIndex = SKILLINFO::SKILL_CLASSES[skillListForCurrActor[index]][1];
        skillName = $data_skills[skillIndex].name + " Lvl: " + @actor.skillTypeLevels[index].to_s();
        skillIcon = $data_skills[skillIndex].icon_index;
        currRate = (@actor.skillExp[index] / 100).round(2);
        #draw Icon, Text, XP Gauge
        draw_icon(skillIcon, posX, posY,true);
        draw_text(posX+iconWidth,posY,columnWidth,24,skillName,0);
        draw_gauge(posX, posY+iconWidth-4, columnWidth-50, currRate, colorA, colorB)
        if (i % 2 == 0) # next skill will be on the right side
          posX = columnWidth;
        else
          posY = posY + line_height + line_height;
          posX = 0;
        end
      i += 1;
    end
    if (drawNextIcon == true)
      draw_icon(nextPageIconIndex, Graphics.width-50, Graphics.height-55,true);
    end
  end

  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end

  def line_color
    color = normal_color
    color.alpha = 48
    color
  end

end

class Scene_SkillProgress < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    @skillProgess_window = Window_SkillProgress.new(@actor)
    @skillProgess_window.set_handler(:cancel,   method(:return_scene));
    @skillProgess_window.set_handler(:ok,       method(:change_Page));
  end

  def change_Page
    @skillProgess_window.pageNumber += 1;
    @skillProgess_window.refresh();
    @skillProgess_window.activate();
  end

end

class Scene_Skill < Scene_ItemBase
  alias SKSystem_create_command_window create_command_window
  def create_command_window
    SKSystem_create_command_window();
    @command_window.set_handler(:fortschritt,    method(:command_fortschritt))
  end
  
  def command_fortschritt
    SceneManager.call(Scene_SkillProgress)
  end
end

class Window_SkillCommand < Window_Command
  alias SKSystem_make_command_list make_command_list
  def make_command_list
    name = "Fortschritt"; # name for the skill progress button
    ext = 1; # no idea what this means ?!
    SKSystem_make_command_list();
    add_command(name, :fortschritt, true, ext)

  end

end
