class Player

  @started_to_rest = false
  @use_turn = false
  $shoot_limit = 3
  $health_min_live = 10
  $health_max_live = 15
  
  def play_turn(warrior)
    # add your code here
    @use_turn = false
    
    # Rescue first
    rescue_captive(warrior)
    
    # Rest for full charge
    rest_safe_to_full(warrior)
    
    # Determine if need to turn around, then turn
    turn_around(warrior)
      
    # Determine need to walk
    walk(warrior)
    
    # Determine to shoot
    shoot_enamy(warrior)
    
    # Determine if need to rest
    rest(warrior)
    
    # Determine to attack
    attack_enamy(warrior)
  end
  
  def turn_around(warrior)
    if warrior.feel.wall?
      warrior.pivot!
    end
  end
  
  def attack_enamy(warrior)
    # Determine to attack
    if is_enamy(warrior) && !@use_turn
      warrior.attack!
      @use_turn = true
    end
  end
  
  def shoot_enamy(warrior)
    if (warrior.look.length > 0) && !@use_turn && ($shoot_limit > 0)
      warrior.shoot!
      $shoot_limit = $shoot_limit-1
      @use_turn = true
    end
  end
  
  def walk(warrior)
    if warrior.feel.empty? && !is_need_rest(warrior) && !(@started_to_rest) && !@use_turn
      warrior.walk!
      @use_turn = true
    end
  end
  
  def rest(warrior)
    if warrior.feel.empty? && is_need_rest(warrior) && !is_feel_captive(warrior) && !(@started_to_rest) 
      rest_start(warrior)
    end
  end

  def rescue_captive(warrior) 
    if warrior.feel.captive? && !@use_turn
      warrior.rescue!
      @use_turn = true
    elsif warrior.feel(:backward).captive? && !@use_turn
      warrior.rescue!(:backward)
      @use_turn = true
    end
  end
  
  def is_enamy(warrior)
    return !(warrior.feel.empty?) && !warrior.feel.captive? && !warrior.feel.wall?
  end

  def rest_start(warrior)
    if !(warrior.feel(:backward).wall?) && !@use_turn
      warrior.walk!(:backward)
      @use_turn = true
    elsif warrior.feel(:backward).wall? && !@use_turn
      warrior.rest!
      @started_to_rest = true
      @use_turn = true
    end
  end

  def is_need_rest(warrior)
    return warrior.health < $health_min_live
  end
  
  def is_feel_captive(warrior)
    return warrior.feel.captive? || warrior.feel(:backward).captive?
  end

  # is the health is full charge
  def is_full_health(warrior)
    return warrior.health == $health_max_live
  end
  
  # rest until full
  def rest_safe_to_full(warrior)
    if (@started_to_rest) && !is_full_health(warrior) && !@use_turn
      warrior.rest!
      @use_turn = true
    elsif is_full_health(warrior) 
      @started_to_rest = false
    end
  end
end
