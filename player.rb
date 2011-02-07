class Player

  @started_to_rest = false
  @user_turn = false
  $health_min_live = 10
  $health_max_live = 15
  
  def play_turn(warrior)
    # add your code here
    @user_turn = false
    
    # Rescue first
    rescue_captive(warrior)
    
    # Rest for full charge
    rest_safe_to_full(warrior)

    # Determine to attack
    attack_enemy(warrior)
    
    # Determine to shoot
    shoot_enemy(warrior)
    
    # Determine if need to rest
    rest(warrior)  
    
    # Determine need to walk
    walk(warrior)
    
    # Determine if need to turn around, then turn
    turn_around(warrior)
    
    $last_warrior_health = warrior.health
  end
  
  def turn_around(warrior)
    if warrior.feel.wall? or is_shooting_target(warrior.look(:backward)) and not @user_turn
      warrior.pivot!
      @user_turn = true
    end
  end
  
  def attack_enemy(warrior)
    # Determine to attack
    if is_enamy(warrior) and !@user_turn
      warrior.attack!
      @user_turn = true
    end
  end
  
  def shoot_enemy(warrior)
    if !@user_turn and is_shooting_target(warrior.look)
      warrior.shoot!
      @user_turn = true
    end
  end
  
  def walk(warrior)
    if warrior.feel.empty? and !is_shooting_target(warrior.look) and !(@started_to_rest) and !@user_turn
      warrior.walk!
      @user_turn = true
    end
  end
  
  # Determine is there any target need to fire
  def is_shooting_target(look)
    @target = false
    @captive_infront = false
    look.each do |element|
      if element.to_s == "Wizard" or element.to_s == "Archer"
        # puts "We found a target to shoot for..."
        @target = true
        break
      elsif element.to_s == "Captive"
        @captive_infront = true
        break
      end
    end
    return @target && !@captive_infront
  end
  
  def rest(warrior)
    rest_start(warrior) if is_need_rest(warrior) and not is_under_attack(warrior) and not (@started_to_rest) 
  end

  def rescue_captive(warrior) 
    if warrior.feel.captive? and not@user_turn
      warrior.rescue!
      @user_turn = true
    elsif warrior.feel(:backward).captive? and not@user_turn
      warrior.rescue!(:backward)
      @user_turn = true
    end
  end
  
  def is_enamy(warrior)
    return !(warrior.feel.empty?) && !(warrior.feel.captive?) && !(warrior.feel.wall?)
  end

  def rest_start(warrior)
    if not @user_turn
      warrior.rest!
      @started_to_rest = true
      @user_turn = true
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
    return warrior.health >= $health_max_live
  end
  
  def is_under_attack(warrior)
    return warrior.health < $last_warrior_health
  end
  
  # rest until full
  def rest_safe_to_full(warrior)
    if (@started_to_rest) and not is_full_health(warrior) and not @user_turn
      warrior.rest!
      @user_turn = true
    elsif is_full_health(warrior) 
      @started_to_rest = false
    end
  end
end
