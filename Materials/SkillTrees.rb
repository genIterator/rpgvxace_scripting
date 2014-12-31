=begin
#==============================================================================
 ** Skill Tree
 Author: Hime
 Date: Oct 6, 2012
------------------------------------------------------------------------------
 ** Change log
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
 ** Required
 -Skill Levels
 -Core Learning
-------------------------------------------------------------------------------
 Allows you to setup skills to require the user to achieve certain levels of
 mastery for other skills before the skill can be learned.
 
 In the class tab, tag each learning object with
 
    <slv: skill_id level>
    <slv: 3 6>
    
 Which means skill 3 must be at least level 6.
 
#==============================================================================
=end
$imported = {} if $imported.nil?
$imported["Tsuki_SkillTree"] = true
#==============================================================================
# ** Configuration
#==============================================================================
module Tsuki
  module Skill_Tree
    Skill_Level_Regex = /<slv:?\s*(\d+) (\d+)>/i
  end
end
#==============================================================================
# ** Rest of the script
#==============================================================================

module RPG
  class Class::Learning
    def skill_requirements
      return @slv_reqs  unless @slv_reqs.nil?
      load_notetag_skill_tree
      return @slv_reqs
    end
    
    def load_notetag_skill_tree
      @slv_reqs = {}
      res = self.note.scan(Tsuki::Skill_Tree::Skill_Level_Regex)
      res.each {|id, lvl|
        @slv_reqs[id.to_i] = lvl.to_i
      }
    end
  end
end

module Vocab
  
  Skill_Level_Up = "%s's %s level steigt auf %d"
end

class Game_Actor < Game_Battler

  def display_skill_level_up(skill_id)
    $game_message.add(sprintf(Vocab::Skill_Level_Up, @name, $data_skills[skill_id].name, skill_level(skill_id)))
  end
  
  def display_learn_skills(new_skills)
    new_skills.each {|skill|
      $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
    }
  end
  
  # See if we can learn anything new
  def check_new_skills
    last_skills = skills
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if can_learn_skill?(learning)
    end
    display_learn_skills(skills - last_skills)
  end

  alias :th_skill_tree_slevel_up :skill_level_up
  def skill_level_up(skill_id)
    last_level = skill_level(skill_id)
    th_skill_tree_slevel_up(skill_id)
    display_skill_level_up(skill_id) if skill_level(skill_id) != last_level
    check_new_skills
  end
  
  alias :th_skill_tree_can_learn? :can_learn_skill?
  def can_learn_skill?(learning)
    return false unless skill_level_requirements_met?(learning)
    th_skill_tree_can_learn?(learning)
  end
  
  def skill_level_requirements_met?(learning)
    !learning.skill_requirements.any? {|id, lvl|
      skill_level(id) < lvl
    }
  end
end