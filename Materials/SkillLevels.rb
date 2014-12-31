=begin
#==============================================================================
 ** Skill Levels
 Author: Hime
 Date: Oct 23, 2012
------------------------------------------------------------------------------
 ** Change log
 Oct 23
   - added method "slv" for damage formulas
 Oct 22
   - added default max skill level
 Oct 6
   - initial release
------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Preserve this header
-------------------------------------------------------------------------------
 This script adds actor skill levels. This represents the actor's proficiency
 with a particular skill.
 
 This script does not provide a way to increase skill levels and serves as
 a basis for all skill level related scripts.
 
 Tag your actor with
    <init_slv: skill_id level>
    
 To set the initial level of some skill
 
    <max_slv: skill_id level>
    
 To set the max level that skill can go up to
 
 To increase/decrease the skill level, use the calls

    skill_level_up(skill_id)
    skill_level_down(skill_id)
    
 You can access this through script call as well as such
 
    $game_actors[1].skill_level_up(3)
    
 To reference skill levels in a damage formula, you can use the short-hand
 
    a.slv(id)
 
 Which will return the skill level of the specified ID for the attacker or
 defender.
#==============================================================================
=end
$imported = {} if $imported.nil?
$imported["Tsuki_SkillLevel"] = true
#==============================================================================
# ** Configuration
#==============================================================================
module Tsuki
  module Skill_Levels
    
    # Default max level for all skills, for each actor
    #   format: actor_id -> max skill level
    Default_Max_Levels = {
      1 => 5,
      2 => 3
    }
    
    # Actor-scope regex. Applies to specific actor
    Actor_Init_SLevel_Regex = /<init_slv:?\s*(\d+) (\d+)/i
    Actor_Max_SLevel_Regex = /<max_slv:?\s*(\d+) (\d+)/i
    
    # Skill-scope regex. Applies to all actors
    Skill_Init_Level_Regex = /<init_slv:?\s*(\d+)/i
    Skill_Max_Level_Regex = /<max_slv:?\s*(\d+)/i
  end
end
#==============================================================================
# ** Rest of the script
#==============================================================================

module RPG
  class Actor
    
    def skill_levels
      return @skill_levels unless @skill_levels.nil?
      load_notetag_skill_levels
      return @skill_levels
    end
    
    def max_skill_levels
      return @max_skill_levels unless @max_skill_levels.nil?
      load_notetag_max_skill_levels
      return @max_skill_levels
    end
        
    def load_notetag_skill_levels
      @skill_levels = {}
      res = self.note.scan(Tsuki::Skill_Levels::Actor_Init_SLevel_Regex)
      res.each {|id, lvl| @skill_levels[id.to_i] = lvl.to_i }
    end
    
    def load_notetag_max_skill_levels
      @max_skill_levels = {}
      res = self.note.scan(Tsuki::Skill_Levels::Actor_Max_SLevel_Regex)
      res.each{|id, lvl| @max_skill_levels[id.to_i] = lvl.to_i} 
    end
  end
end

class Game_Battler < Game_BattlerBase 
  
  def init_skill_levels
    @skill_levels = {}
  end
  
  # Return the level of the specified skill
  def skill_level(skill_id)
    @skill_levels[skill_id] || 0
  end
  
  alias :slv :skill_level 
  
  def skill_levels
    @skill_levels
  end
end

class Game_Actor < Game_Battler
  
  alias :th_skill_levels_init :initialize
  def initialize(actor_id)
    @skill_levels = {}
    th_skill_levels_init(actor_id)
    init_skill_levels
  end
  
  def init_skill_levels
    super
    skills.each {|skill|
      init_skill_level(skill.id)
    }
  end
  
  def init_skill_level(id)
    @skill_levels[id] = actor.skill_levels[id] || 1
  end
  
  alias :th_skill_levels_learn_skill :learn_skill
  
  def learn_skill(skill_id)
    unless skill_learn?($data_skills[skill_id])
      skill_levels[skill_id] = 1
    end
    th_skill_levels_learn_skill(skill_id)
  end
  
  def max_skill_level(skill_id)
    actor.max_skill_levels[skill_id] || Tsuki::Skill_Levels::Default_Max_Levels[@actor_id]
  end
  
  def min_skill_level(skill_id)
    1
  end
  
  # for other scripts. 
  def skill_level_up(skill_id)
    return unless @skill_levels.include?(skill_id)
    @skill_levels[skill_id] = [skill_levels[skill_id] + 1, max_skill_level(skill_id)].min
  end
  
  # for other scripts
  def skill_level_down(skill_id)
    return unless @skill_levels.include?(skill_id)
    @skill_levels[skill_id] = [skill_levels[skill_id] - 1, min_skill_level(skill_id)].max
  end
end

# Just add the level display somewhere
class Window_SkillList
  
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item_name(item))
  end
  
  def item_name(item)
    sprintf("%s LV %s" %[item.name, @actor.skill_level(item.id)])
  end
end