class Player

  @started_to_rest = false
  
  def play_turn(warrior)
    # add your code here
    
    # Rescue first
    rescue_captive(warrior)
    
    # Rest for full charge
    rest_safe_to_full(warrior)
    
    # Determine if need to turn around, then turn
    turn_around(warrior)
      
    # Determine need to walk
    walk(warrior)
    
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
    if is_enamy(warrior)
      warrior.attack!
    end
  end
  
  def walk(warrior)
    if warrior.feel.empty? && !is_need_rest(warrior) && !(@started_to_rest)
      warrior.walk!
    end
  end
  
  def rest(warrior)
    if warrior.feel.empty? && is_need_rest(warrior) && !is_feel_captive(warrior) && !(@started_to_rest)
      rest_start(warrior)
    end
  end

  def rescue_captive(warrior)
    if warrior.feel.captive?
      warrior.rescue!
    elsif warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
    end
  end
  
  def is_enamy(warrior)
    return !(warrior.feel.empty?) && !warrior.feel.captive? && !warrior.feel.wall?
  end

  def rest_start(warrior)
    if !(warrior.feel(:backward).wall?)
      warrior.walk!(:backward)
    elsif warrior.feel(:backward).wall?
      warrior.rest!
      @started_to_rest = true
    end
  end

  def is_need_rest(warrior)
    return warrior.health < 8
  end
  
  def is_feel_captive(warrior)
    return warrior.feel.captive? || warrior.feel(:backward).captive?
  end

  # is the health is full charge
  def is_full_health(warrior)
    return warrior.health == 20
  end
  
  # rest until full
  def rest_safe_to_full(warrior)
    if (@started_to_rest) && !is_full_health(warrior)
      warrior.rest!
    elsif is_full_health(warrior)
      @started_to_rest = false
    end
  end
end
