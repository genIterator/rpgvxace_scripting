

#==============================================================================
# ** TDS Followers Control
#    Ver: 1.0
#------------------------------------------------------------------------------
#  * Description:
#  This script allows you to use event commands on the Player's followers.
#------------------------------------------------------------------------------
#  * Features: 
#  Use Event Commands on Followers like "Set Move Route", "Show Animation", etc.
#------------------------------------------------------------------------------
#  * Instructions:
#  To use an event command on a follower use this in a script call above the
#  event command:
#
#    control_follower(index)
#
#    index = Follower index. (0 first follower the 1 etc)
#
#    Example:
#
#    control_follower(0)
#
#  To gather all followers at the coordinates of the player use this in a
#  script call:
#
#    gather_followers(instant) 
#
#    instant = If true then all followers are moved instantly. (Optional)
#
#    Example:
#
#    gather_followers(true) or gather_followers
#------------------------------------------------------------------------------
#  * Notes:
#  None.
#------------------------------------------------------------------------------
# WARNING:
#
# Do not release, distribute or change my work without my expressed written 
# consent, doing so violates the terms of use of this work.
#
# If you really want to share my work please just post a link to the original
# site.
#
# * Not Knowing English or understanding these terms will not excuse you in any
#   way from the consequenses.
#==============================================================================
# * Import to Global Hash *
#==============================================================================
($imported ||= {})[:TDS_Followers_Control] = true

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------  
  alias tds_followers_control_game_interpreter_clear            clear
  alias tds_followers_control_game_interpreter_get_character    get_character
  #--------------------------------------------------------------------------
  # * Meta Alias & Methods
  #--------------------------------------------------------------------------    
  # Go Through Event Commands
  [111, 203, 205, 212, 213].each_with_index {|code|
    # Get Method Name
    name = "command_#{code}"
    # Alias Method
    alias_method :"tds_followers_control_game_interpreter_#{name}", name    
    # Define Method
    define_method (name) {|*args, &block|
      # Run Original Method
      self.send "tds_followers_control_game_interpreter_#{name}", *args, &block
      # Clear Follower Index
      @follower_index = nil
     }
  }  
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear(*args, &block)
    # Run Original Method
    tds_followers_control_game_interpreter_clear(*args, &block)
    # Follower Index
    @follower_index = nil
  end
  #--------------------------------------------------------------------------
  # * Get Character
  #     param : If -1, player. If 0, this event. Otherwise, event ID.
  #--------------------------------------------------------------------------
  def get_character(*args, &block)
    # Return Follower Character
    return $game_player.followers[@follower_index] if !$game_party.in_battle and !@follower_index.nil?
    # Run Original Method
    tds_followers_control_game_interpreter_get_character(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Set Character Control to follower
  #--------------------------------------------------------------------------
  def control_follower(index) ; @follower_index = index end  
  #--------------------------------------------------------------------------
  # * Set Character Control to follower
  #--------------------------------------------------------------------------
  def gather_followers(instant = false) 
    # Instantly Synchronize 
    return $game_player.followers.synchronize($game_player.x, $game_player.y, $game_player.direction) if instant
    # Gather Followers
    $game_player.followers.gather 
  end
end
