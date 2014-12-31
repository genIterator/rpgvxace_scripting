#==============================================================================
# NeoFace System v.2.0 [RMVXA Script] -- modified
#------------------------------------------------------------------------------
# by Woratana [woratana@hotmail.com]
# Thaiware RPG Maker Community
# Special Thanks: Rabu
# Simple (and still beta) conversion to RMVXA by Vladitor
#------------------------------------------------------------------------------
# Released on: 22/01/2008
# - Put face graphics in folder "face" of your project.
# [New Features in Version 2.0]
# - Auto arrange face position (You can use any size of face file)
# - Call Script "$game_message.side = (number)" to switch show face mode.
# $game_message.side = 0 << switch to normal face system (default face system of RMVX)
# $game_message.side = 1 << switch to NeoFace system (show face in left side)
# $game_message.side = 2 << switch to NeoFace system (show face in right side)
# $game_message.side = 3 << show face in right side, like default system!
# Default system when you first setup this script is 0
# THESE NUMBERS & RESULTS ARE DIFFERENT FROM VERSION 1.0 #
# Fixed bug in Show Choice command.
#==============================================================================
#==============================================================================
# Window_Base
#------------------------------------------------------------------------------
#==============================================================================
class Window_Base
  def draw_face2_neo_face(face_name, x, y)
    @face.z = 201
    @face.bitmap = Cache.face(face_name)
    if $game_message.side == 1
      @face.mirror = false
      @face.x = x + 6
    else
      @face.mirror = true
      @face.x = x + (538 - @face.width)
    end
    @face.y = y - (@face.height - 120)
    @face.opacity = 0 # Change 0 to 255 to turn off face's fade in effect.
  end

  def draw_face3_neo_face(face_name, face_index, x, y)
    @face.z = 201
    @face.bitmap = Cache.face(face_name)
    @face.src_rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    @face.mirror = true
    @face.x = x + (532 - @face.width)  #change value if screen res is different!
    @face.y = y - (@face.height - 108) #change value if screen res is different!
    @face.opacity = 0
  end

end

#==============================================================================
# Window_Message
#------------------------------------------------------------------------------
#==============================================================================
class Window_Message < Window_Base

  alias msg_ini initialize
  def initialize
    msg_ini
    @face = Sprite_Base.new
    $game_message.side = 0 # Default face's side when game start~ (default: 1)
    @default_conx = 0
    @previous = ""
    get_x_face
    # Move text left (-) or right (+) when there's face in right side or no face (default: 0)
  end

  def no_face?
    $game_message.face_name.empty?
  end

  def clear_face_neo_face
    if @face.bitmap
      @face.dispose
      @face = Sprite_Base.new
    end
  end
  
  def new_page(text, pos)
    contents.clear
    clear_face_neo_face
    if no_face?
      @contents_x = @default_conx
      @previous = ""
    else
      name = $game_message.face_name
      index = $game_message.face_index
      if $game_message.side == 0 ##
        draw_face(name, index, 0, 0)
      else
        if $game_message.side == 3              
          draw_face3_neo_face(name, index, self.x, self.y) #draw face on right side, but with small face graphics                
        else
          draw_face2_neo_face(name, self.x, self.y)
        end               
      end
      @face.opacity = 255 if name==@previous
      @previous = name
      get_x_face
      @contents_x = @fx
    end
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end

  def new_line_x
    no_face? ? 0 : @fx
  end
  
  alias update_neo_face update
  def update
    update_neo_face
    if @face.opacity < 255 and @face.bitmap
      @face.opacity += 20 # Speed up face's fade in by increase this number
    end
  end

  alias dispose_neo_face dispose
  def dispose
    clear_face_neo_face
    dispose_neo_face
  end

  alias close_neo_face close
  def close
    clear_face_neo_face
    close_neo_face
  end
  
  def get_x_face
    case $game_message.side
    when 0
      @fx = 112
    when 1
      @fx = @face.width
    when 2
      @fx = @default_conx
    else
      @fx = @default_conx
    end
  end
  
end # Class

#==============================================================================
# Window_ChoiceList: prevent choices from being obscured by face
#------------------------------------------------------------------------------
#==============================================================================
class Window_ChoiceList < Window_Command
  
  alias update_placement_neo_face update_placement
  def update_placement
    update_placement_neo_face
    if $game_message.side == 2 and not @message_window.no_face?
      self.x = 0
    else
      self.x = Graphics.width - width
    end
  end

end
#==============================================================================
# Game_Message: + store side variable
#------------------------------------------------------------------------------
#==============================================================================
class Game_Message
  attr_accessor :side
end
#==============================================================================
# END NeoFace System
# by Woratana (woratana@hotmail)
#==============================================================================