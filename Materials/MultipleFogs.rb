#===============================================================
# ● [VX ACE] ◦ Multiple Fogs ◦ □
# * Use unlimited layers of fog *
#--------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 13/05/2008
# ◦ Version: 1.0
# ◦ ported to VX Ace by Necromus 17/03/2012
#--------------------------------------------------------------

#==================================================================
# ** HOW TO USE **
# * use event command 'Script...' for the any script line below~
#-----------------------------------------------------------------
#
#---------------------------------------------------------------
# ** SETUP FOG PROPERTIES & SHOW FOG **
# * You have to setup fog properties, before show fog~
#-------------------------------------------------------------
# * There are 3 ways to setup fog properties:
# >> Setup Fog [Custom]:
# $fog.name = 'image_name' # Image file name, must be in fog image path (setup path below).
# $fog.hue = (integer) # Fog's hue. 0 - 360, 0 for no hue.
# $fog.tone = [red, green, blue, gray] # Fog's tone color.
# $fog.opacity = (integer) # Fog's opacity. 0 - 255, you will not see fog in 0.
# $fog.blend = (0, 1, or 2) # Fog's blend type. 0 for Normal, 1 for Add, 2 for Subtract.
# $fog.zoom = (integer) # Fog's size (in %). 100 for normal size.
# $fog.sx = (+ or - integer) # Fog's horizontal move speed.
# $fog.sy = (+ or - integer) # Fog's vertical move speed.
#
# >> Setup Fog [From Preset]:
# (You can setup fog presets, in part FOG PRESET SETUP below)
# $fog.load_preset(preset_id)
#
# >> Setup Fog [From Fog that showing]:
# $fog.load_fog(fog_id)
#
#--------------------------------------------------------------
# ** SHOW FOG **
#-------------------------------------------------------------
# After setup the fog, show fog by call script:
# $fog.show(fog_id)
#
# In case you want to show new fog on same ox, oy, tone as old fog. Call Script:
# $fog.show(old_fog_id, false)
#
# * fog_id: the ID number you want to put this fog in.
# (It can be any positive number or zero)
#
# After you show fog, the fog properties you've set will replace with default setting.
# (You can setup default setting, in part FOG DEFAULT SETTING below)
#
#--------------------------------------------------------------
# ** DELETE FOG **
#-------------------------------------------------------------
# You can delete 1 or more fog(s) at a time by call script:
# $fog.delete(fog_id, fog_id, fog_id, ...)
#
#---------------------------------------------------------------
# ** OLD FOG CONTROL EVENT COMMANDS **
#-------------------------------------------------------------
# Change Fog Tone:
# $game_map.fogtone(fog_id, [red, green, blue, gray], duration)
# e.g. $game_map.fogtone(1, [100,200,-100,0], 10)

# Change Fog Opacity:
# $game_map.fogopac(fog_id, new_opacity, duration)
# e.g. $game_map.fogopac(2, 200, 10)
#
#---------------------------------------------------------------
# ** ADDITIONAL SETTINGS **
#-------------------------------------------------------------
# Change Fog Image's Path:
# $game_map.fog_path = 'image_path'
# e.g. $game_map.fog_path = 'Graphics/Pictures/'

# Turn ON/OFF [Automatically clear all fogs when transfer player]:
# $game_map.fog_reset = (true / false)
#
#===============================================================

#==================================================================
# START ** MULTIPLE FOG SETUP **
#==================================================================
class Game_Map
  alias wora_mulfog_gammap_ini initialize
  def initialize
        wora_mulfog_gammap_ini
        
        #==================================================================
        # ** MULTIPLE FOG SETUP ** SETTINGS
        #--------------------------------------------------------------
        @fog_path = 'Graphics/Pictures/'
        # Fog image's path
        @fog_reset = true # (true or false)
        # Automatically clear all multiple fogs when transfer player
        #==================================================================
        
        @mulfog_name = []
        @mulfog_hue = []
        @mulfog_opacity = []
        @mulfog_blend_type = []
        @mulfog_zoom = []
        @mulfog_sx = []
        @mulfog_sy = []
        @mulfog_ox = []
        @mulfog_oy = []
        @mulfog_tone = []
        @mulfog_tone_target = []
        @mulfog_tone_duration = []
        @mulfog_opacity_duration = []
        @mulfog_opacity_target = []
  end
end
class Wora_Multiple_Fog
  def set_default
        #==================================================================
        # ** MULTIPLE FOG SETUP ** FOG DEFAULT SETTING
        #--------------------------------------------------------------
        @name = ''
        @hue = 0
        @opacity = 64
        @blend = 0
        @zoom = 200
        @sx = 0
        @sy = 0
        @tone = [0,0,0,0]
        #==================================================================
  end

  def load_preset(preset_id)
        case preset_id
        #==================================================================
        # ** MULTIPLE FOG SETUP ** FOG PRESET SETUP
        #--------------------------------------------------------------
        when 1 # Preset ID 1
          @name = 'Fog'
          @hue = 0
          @tone = [100,-255,20,0]
          @opacity = 60
          @blend = 0
          @zoom = 200
          @sx = 10
          @sy = 0
        when 2 # Preset ID 2
          @name = 'Cloud2'
          @hue = 0
          @tone = [0,0,0,0]
          @opacity = 60
          @blend = 0
          @zoom = 200
          @sx = 10
          @sy = 0
        when 3 # Preset ID 3
          @name = 'Cloud3'
          @hue = 0
          @tone = [0,0,0,-100]
          @opacity = 150
          @blend = 0
          @zoom = 140
          @sx = 2
          @sy = 1
        #==================================================================
        end
  end
#==================================================================
# END ** MULTIPLE FOG SETUP **
# * Don't change anything below unless you know what you're doing.
#==================================================================

  attr_accessor :name, :hue, :opacity, :blend, :zoom, :sx, :sy, :tone
  def initialize
        set_default
  end

  def load_fog(id)
        @name = $game_map.mulfog_name[id].sub($game_map.fog_path, '')
        @hue = $game_map.mulfog_hue[id]
        @opacity = $game_map.mulfog_opacity[id]
        @blend = $game_map.mulfog_blend_type[id]
        @zoom = $game_map.mulfog_zoom[id]
        @sx = $game_map.mulfog_sx[id]
        @sy = $game_map.mulfog_sy[id]
        tn = $game_map.mulfog_tone[id]
        @tone = [tn.red, tn.blue, tn.green, tn.gray]
  end

  def show(id, reset_all = true)
        $game_map.mulfog_name[id] = $game_map.fog_path + @name
        $game_map.mulfog_hue[id] = @hue
        $game_map.mulfog_opacity[id] = @opacity
        $game_map.mulfog_blend_type[id] = @blend
        $game_map.mulfog_zoom[id] = @zoom
        $game_map.mulfog_sx[id] = @sx
        $game_map.mulfog_sy[id] = @sy
        $game_map.mulfog_tone[id] = Tone.new(@tone[0], @tone[1], @tone[2], @tone[3])
        if $game_map.mulfog_ox[id].nil? or reset_all
          $game_map.mulfog_ox[id] = 0
          $game_map.mulfog_oy[id] = 0
          $game_map.mulfog_tone_target[id] = Tone.new(0, 0, 0, 0)
          $game_map.mulfog_tone_duration[id] = 0
          $game_map.mulfog_opacity_duration[id] = 0
          $game_map.mulfog_opacity_target[id] = 0
        end
        set_default
  end

  def delete(*args)
        args.each do |id|
          $game_map.mulfog_name[id] = ''
        end
  end
end

class Game_Interpreter
  alias wora_mulfog_interpret_com201 command_201
  #--------------------------------------------------------------------------
  # * Transfer Player
  #--------------------------------------------------------------------------
  def command_201
        if $game_map.fog_reset
          if @params[0] == 0; id_map = @params[1]
          else; id_map = $game_variables[@params[1]]
          end
          $game_map.clear_mulfog if id_map != @map_id
        end
        wora_mulfog_interpret_com201
  end
end

class Game_Map
  attr_accessor :mulfog_name, :mulfog_hue, :mulfog_opacity, :mulfog_blend_type,
  :mulfog_zoom, :mulfog_sx, :mulfog_sy, :mulfog_ox, :mulfog_oy, :mulfog_tone,
  :mulfog_tone_target, :mulfog_tone_duration, :mulfog_opacity_duration,
  :mulfog_opacity_target, :fog_reset, :fog_path
  alias wora_mulfog_gammap_upd update
  def update(main)  
        wora_mulfog_gammap_upd(main)
        @mulfog_name.each_index do |i|
          next if @mulfog_name[i].nil? or @mulfog_name[i] == ''
          # Manage fog scrolling
          @mulfog_ox[i] -= @mulfog_sx[i] / 8.0
          @mulfog_oy[i] -= @mulfog_sy[i] / 8.0
          # Manage change in fog color tone
          if @mulfog_tone_duration[i] >= 1
                d = @mulfog_tone_duration[i]
                target = @mulfog_tone_target[i]
                @mulfog_tone[i].red = (@mulfog_tone[i].red * (d - 1) + target.red) / d
                @mulfog_tone[i].green = (@mulfog_tone[i].green * (d - 1) + target.green) / d
                @mulfog_tone[i].blue = (@mulfog_tone[i].blue * (d - 1) + target.blue) / d
                @mulfog_tone[i].gray = (@mulfog_tone[i].gray * (d - 1) + target.gray) / d
                @mulfog_tone_duration[i] -= 1
          end
          # Manage change in fog opacity level
          if @mulfog_opacity_duration[i] >= 1
                d = @mulfog_opacity_duration[i]
                @mulfog_opacity[i] = (@mulfog_opacity[i] * (d - 1) + @mulfog_opacity_target[i]) / d
                @mulfog_opacity_duration[i] -= 1
          end
        end
  end
  #--------------------------------------------------------------------------
  # * Start Changing Fog Color Tone
  #--------------------------------------------------------------------------
  def fogtone(i, tone, duration)
        duration = duration * 2
        tone = Tone.new(tone[0], tone[1], tone[2], tone[3])
        @mulfog_tone_target[i] = tone.clone
        @mulfog_tone_duration[i] = duration
        if @mulfog_tone_duration[i] == 0
          @mulfog_tone[i] = @mulfog_tone_target[i].clone
        end
  end
  #--------------------------------------------------------------------------
  # * Start Changing Fog Opacity Level
  #--------------------------------------------------------------------------
  def fogopac(i, opacity, duration)
        duration = duration * 2
        @mulfog_opacity_target[i] = opacity * 1.0
        @mulfog_opacity_duration[i] = duration
        if @mulfog_opacity_duration[i] == 0
          @mulfog_opacity[i] = @mulfog_opacity_target[i]
        end
  end

  def clear_mulfog
        @mulfog_name.each_index {|i| @mulfog_name[i] = '' }
  end
end
$worale = {} if !$worale
$worale['MutipleFog'] = true
$fog = Wora_Multiple_Fog.new

class Spriteset_Map
  alias wora_mulfog_sprmap_crepal create_parallax
  alias wora_mulfog_sprmap_updpal update_parallax
  alias wora_mulfog_sprmap_dispal dispose_parallax

  def create_parallax
        @mulfog = []
        @mulfog_name = []
        @mulfog_hue = []
        wora_mulfog_sprmap_crepal
  end

  def update_parallax
#~       wora_mulfog_sprmap_updpal  
        $game_map.mulfog_name.each_index do |i|
          next if $game_map.mulfog_name[i].nil?
          # If fog is different than current fog
          if @mulfog_name[i] != $game_map.mulfog_name[i] or @mulfog_hue[i] != $game_map.mulfog_hue[i]
                @mulfog_name[i] = $game_map.mulfog_name[i]
                @mulfog_hue[i] = $game_map.mulfog_hue[i]
                if @mulfog[i].nil?
                  @mulfog[i] = Plane.new(@viewport3)
                  @mulfog[i].z = 3000
                end
                if @mulfog[i].bitmap != nil
                  @mulfog[i].bitmap.dispose
                  @mulfog[i].bitmap = nil
                end
                if @mulfog_name[i] != ''
                  @mulfog[i].bitmap = Cache.load_bitmap('', @mulfog_name[i], @mulfog_hue[i])
                end
                Graphics.frame_reset
          end
          next if @mulfog[i].bitmap.nil?
          # Update fog plane
          @mulfog[i].zoom_x = ($game_map.mulfog_zoom[i] / 100.0) if @mulfog[i].zoom_x != ($game_map.mulfog_zoom[i] / 100.0)
          @mulfog[i].zoom_y = ($game_map.mulfog_zoom[i] / 100.0) if @mulfog[i].zoom_y != ($game_map.mulfog_zoom[i] / 100.0)
          @mulfog[i].opacity = $game_map.mulfog_opacity[i] if @mulfog[i].opacity != $game_map.mulfog_opacity[i]
          @mulfog[i].blend_type = $game_map.mulfog_blend_type[i] if @mulfog[i].blend_type != $game_map.mulfog_blend_type[i]
          @mulfog[i].ox = $game_map.mulfog_ox[i] + $game_map.display_x  * 32 if @mulfog[i].ox != $game_map.mulfog_ox[i] + $game_map.display_x  * 32  
          @mulfog[i].oy = $game_map.mulfog_oy[i] + $game_map.display_y  * 32 if @mulfog[i].oy != $game_map.mulfog_oy[i] + $game_map.display_y  * 32
          @mulfog[i].tone = $game_map.mulfog_tone[i] if @mulfog[i].tone != $game_map.mulfog_tone[i]
        end
  end

  def dispose_parallax
        @mulfog.each_index do |i|
          next if @mulfog[i].nil?
          @mulfog[i].bitmap.dispose if !@mulfog[i].bitmap.nil?
          @mulfog[i].dispose
        end
        wora_mulfog_sprmap_dispal
  end
end
#==================================================================
# [END] VX Multiple Fog by Woratana [woratana@hotmail.com]
#==================================================================