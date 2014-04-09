module Rinzler
  MISSING_PARTS = 35
  NOT_A_MARK    = 90

  def to_s
    'rinzler'
  end

  def move
    (fight_or_flight?) ? 
      disc_war : 
      recharge
  end

  private
  def fight_or_flight?
    (shiny? || tis_but_a_scratch? || i_fight_for_the_users?)
  end

  def shiny?
    stats[:health] > NOT_A_MARK
  end

  def tis_but_a_scratch?
    stats[:health] < MISSING_PARTS && voices_made_me?
  end

  def voices_made_me?
    (stats[:health] % 6 == 0) &&            # 6
    (rand(5..7) == 6 || rand(0..2) == 1) && # 6 || 1
    Time.now.to_s.include?("6")             # 6
  end

  def i_fight_for_the_users?
    Game.world[:players].sample.kind_of? program.class
  end

  def disc_war
    derezzed_program = programs.select { |p| one_hit_left? p }
    derezzed_program.any? ? [:attack, derezzed_program.first] : [:attack, program]
  end

  def recharge
    [:rest]
  end

  def derezzed? player
    !player.alive
  end

  def programs
    Game.world[:players].reject do |player|
      player.eql?(self) || player.to_s.eql?("Minion") || derezzed?(player)
    end
  end

  def program
    programs.sample
  end

  def one_hit_left? player
   player.stats[:health] < (stats[:strength] - player.stats[:defense] / 2)
  end
end
