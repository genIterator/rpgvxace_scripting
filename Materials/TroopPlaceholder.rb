=begin

#===============================================================================

 Title: Troop Placeholders

 Author: Hime

 Date: Sep 2, 2013

--------------------------------------------------------------------------------

 ** Change log

 Sep 5, 2013

   - added "max" option 

 Sep 2, 2013

   - fixed bug where members were permanently modified

 Sep 1, 2013

   - fixed bug where multiple value arguments aren't parsed correctly

 Jul 18, 2013

   - Initial release

--------------------------------------------------------------------------------   

 ** Terms of Use

 * Free to use in commercial/non-commercial projects

 * No real support. The script is provided as-is

 * Will do bug fixes, but no compatibility patches

 * Features may be requested but no guarantees, especially if it is non-trivial

 * Credits to Hime Works in your project

 * Preserve this header

--------------------------------------------------------------------------------

 ** Description

 - 0 Battlers auf allen Positionen müssen verhindert werden, 
    ansonsten Zero Divison Error!
 

 This script allows you to create troop "placeholders". These are special

 types of enemies that will be replaced with an actual enemy when they are

 encountered, allowing you to create random troops while managing them using

 the troop editor.

 

 Each troop contains a set of "placeholder rules". These rules are used to

 determine how the placeholders can be populated. The rules come with a number

 of options, and more options can be added to it if necessary.

 

 By creating a set of placeholder rules, along with the use of placeholders,

 you can effectively produce random encounters.

 

 A placeholder enemy consists of a sprite, which is used as a visual reference

 in the troop editor, and its name, which represents the "placeholder name".

 

 Each enemy is then note-tagged with one or more "placeholder tags". The tags

 determine which placeholder the enemy can be drawn in. For example, if you 

 have three placeholders whose names (randomly chosen) are

 

   -Small

   -Medium

   -Large

   

 And you tag an enemy with "Large", then that enemy can only replace a "Large"

 placeholder. If there are no available "Large" placeholders in the troop, then

 the enemy will not be present in battle.

 

--------------------------------------------------------------------------------

 ** Installation

 

 Place this script below Materials and above Main



--------------------------------------------------------------------------------

 ** Usage 

 

 -- Create placeholders --

 

 To create a placeholder enemy, notetag it with

 

   <placeholder: name>

   

 The name can be anything you want. You should avoid using very long names

 

 -- Setup placeholder rules --

 

 In the troop editor, create a comment of the form

 

   <placeholder rule: id>

     weight: 50; tags: small, medium

   </placeholder rule>

 

 Where `id` is the ID of the enemy this rule applies to.

 You can set the ID to 0 if you want a chance to replace the placeholder with

 no enemy.

 

 Notice that the rule options come in pairs of the form

 

   option: value

   option: value1, value2

   

 And are separated by semi-colons.

 See the reference section for information on each option



--------------------------------------------------------------------------------

 ** Reference

 

 This is the list of options available and what they mean.

 

   -- Weight --

   

 Probability that this enemy will be selected. This weight is compared

 against weights of all other rules

               

   -- Tags --

     

 Which placeholders this enemy can be placed in. The enemy can only be

 placed in placeholders whose name matches one of these tags

 

   -- Max --

   

 Determines the maximum number of times the rule can be selected. For example,

 if a rule has a max count of 2, then after the rule has replaced two

 placeholders, it won't be selected again.

     

#===============================================================================

=end

$imported = {} if $imported.nil?

$imported["TH_Troop_Placeholders"] = true

#===============================================================================

# ** Configuration

#===============================================================================

module TH

  module Troop_Placeholders

    

    Regex = /<placeholder: (\w+)>/i

    Rule_Regex = /<placeholder[-_ ]rule: (\d+)>(.*?)<\/placeholder[-_ ]rule>/im

    

    # Symbol to separate options in your placeholder rule

    Delimiter = ";"

  end

end

#===============================================================================

# ** Rest of script

#===============================================================================



#-------------------------------------------------------------------------------

# The placeholder generator is the service that handles all of a troop's

# placeholder. It requires two pieces of information:

# 

#   1. placeholder rules

#   2. troop members

#

# The generator takes the list of members and uses that to return a new,

# processed list of members. Any placeholder members will be replaced according

# to a set of rules defined

#-------------------------------------------------------------------------------

module Placeholder_Generator

  

  #-----------------------------------------------------------------------------

  # Clears away any previous data

  #-----------------------------------------------------------------------------

  def self.init(ruleSet, members)

    @rules = ruleSet.rules.clone

    @members = members

    @new_members = []

    initialize_rule_count

  end

  

  def self.members

    @new_members

  end

  

  #-----------------------------------------------------------------------------

  # Keeps track of how many times a rule has been selected

  #-----------------------------------------------------------------------------

  def self.initialize_rule_count

    @rule_count = {}

    @rules.each do |rule|

      @rule_count[rule] = 0

    end

  end

  

  #-----------------------------------------------------------------------------

  # Generate troop members based on rules

  #-----------------------------------------------------------------------------

  def self.run

    @new_members = []

    @members.each do |member|

      new_member = member.clone

      if new_member.placeholder?

        new_member.enemy_id = replace_placeholder(member)

        @new_members.push(new_member)

      else

        @new_members.push(new_member)

      end

    end

  end

  

  def self.replace_placeholder(member)

    valid_rules = get_valid_rules(member)

    p valid_rules.collect{|rule|rule.enemy_id}

    # No rules available for this placeholder

    return 0 if valid_rules.empty?

    

    weight_sum = valid_rules.inject(0) {|r, rule| r += rule.weight}

    return 0 if weight_sum <= 0

      

    value = rand(weight_sum)

    valid_rules.each do |rule|

      if value < rule.weight

        @rule_count[rule] += 1

        return rule.enemy_id 

      end

      value -= rule.weight

    end

  end

  

  def self.get_valid_rules(member)

    @rules.select {|rule|

      rule.tags.include?(member.placeholder_name) && @rule_count[rule] < rule.max_count

    }

  end

end



#-------------------------------------------------------------------------------

# Takes a set of pages and builds the placeholder rules

#-------------------------------------------------------------------------------

module Placeholder_Parser

  

  def self.parse_rules(pages)

    rules = Placeholder_Rules.new

    pages.each do |page|

      parse_page(rules, page)

    end

    return rules

  end

  

  def self.parse_page(rules, page)

    comments = ""

    page.list.each do |cmd|

      comments << cmd.parameters[0] if cmd.code == 108 || cmd.code == 408

    end

    res = comments.scan(TH::Troop_Placeholders::Rule_Regex)

    res.each do |data|

      enemy_id = data[0].to_i

      rule = Placeholder_Rule.new(enemy_id)

      options = data[1].strip.split(TH::Troop_Placeholders::Delimiter)

      parse_options(rule, options)

      rules.add_rule(rule)

    end

  end

  

  def self.parse_options(rule, options)

    options.each do |option|

      name, value = option.split(":")

      name = name.strip.to_sym

      case name

      when :weight

        rule.weight = value.to_i

      when :tags

        rule.tags.concat(value.split(",").collect {|val| val.strip.downcase})

      when :max

        rule.max_count = value.to_i

      end

    end

  end

end



#-------------------------------------------------------------------------------

# The placeholder rule object defines various conditions for setting up a

# placeholder member. It contains an enemy ID and a weight, which determines

# the chance that this rule will be picked. It also holds various conditions

# and chance modifiers depending on the current troop and the previously

# selected members

#-------------------------------------------------------------------------------

class Placeholder_Rule

  

  attr_reader   :enemy_id

  attr_accessor :tags

  attr_accessor :weight

  attr_accessor :max_count

  

  def initialize(enemy_id)

    @enemy_id = enemy_id  

    @tags = []

    @weight = 10

    @max_count = 999

  end

end



#-------------------------------------------------------------------------------

# Wrapper object that manages rules.

#-------------------------------------------------------------------------------

class Placeholder_Rules

  

  attr_reader :rules

  

  def initialize

    @rules = []

  end

  

  def add_rule(rule)

    @rules << rule

  end

end



#-------------------------------------------------------------------------------

# 

#-------------------------------------------------------------------------------

module RPG  

  class Enemy < BaseItem

    

    #---------------------------------------------------------------------------

    # New.

    #---------------------------------------------------------------------------

    def placeholder_name

      load_notetag_placeholder_name if @placeholder_name.nil?

      return @placeholder_name

    end

    

    #---------------------------------------------------------------------------

    # New. Returns true if this is a placeholder enemy

    #---------------------------------------------------------------------------

    def placeholder?

      !(self.placeholder_name.empty?)

    end

    

    #---------------------------------------------------------------------------

    # New.

    #---------------------------------------------------------------------------

    def load_notetag_placeholder_name

      @placeholder_name = ""

      if self.note =~ TH::Troop_Placeholders::Regex

        @placeholder_name = $1.downcase

      end

    end

  end

  

  class Troop::Member

    def placeholder?

      $data_enemies[@enemy_id].placeholder?

    end

    

    def placeholder_name

      $data_enemies[@enemy_id].placeholder_name

    end

  end

  

  class Troop

    #---------------------------------------------------------------------------

    # New. Parse the rules and cache it in the troop data so we don't have

    # to parse it every time

    #---------------------------------------------------------------------------

    def placeholder_rules

      parse_placeholder_rules if @placeholder_rules.nil?

      return @placeholder_rules

    end

    

    #---------------------------------------------------------------------------

    # New.

    #---------------------------------------------------------------------------

    def parse_placeholder_rules

      @placeholder_rules = Placeholder_Parser.parse_rules(@pages)

    end

    

    #---------------------------------------------------------------------------

    # Replaced. Returns an array of members...but since we have some

    # placeholders, we'll return a modified version based on the placeholder

    # data.

    #---------------------------------------------------------------------------

    def members

      Placeholder_Generator.init(self.placeholder_rules, @members)

      Placeholder_Generator.run

      return Placeholder_Generator.members

    end

  end

end