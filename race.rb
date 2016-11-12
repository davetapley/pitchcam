class Race
  class Entrant
    attr_reader :name, :state, :is_turn, :track_position

    def initialize(name)
      @name = name
      @state = :pre_start
      @is_turn = false
      @track_position = [0, 0]
    end

    def start_turn
      @is_turn = true
      case state
      when :pre_start
        puts "#{name} please take the grid"
      else
        puts "#{name} it is your turn"
      end
    end

    def update(track_position)
      @track_position = track_position

      if is_turn
        case state
        when :pre_start
          progress = track_position.first
          if progress < 1
            @state = :start
            puts "#{name} start when ready"
          end
          false
        when :start
          @is_turn = false
          @state = :racing
          puts "#{name} is off!"
          true
        else
          @is_turn = false
          puts "#{name} took their turn"
          true
        end
      else
        puts "#{name} moved out of turn"
        false
      end
    end
  end

  attr_reader :track, :entrants

  def initialize(track, cars)
    @track = track
    @entrants = Hash[cars.map { |car| [car, Entrant.new(car.name)] }]
    @current_idx = 0
    entrants.first.last.start_turn
  end

  def update(dirty_cars)
    dirty_cars.each do |car|
      track_position = track.position_from_world car.latest_world_position

      entrant = entrants[car]
      puts "#{entrant.name} #{track_position}"

      turn_finished = entrant.update track_position
      if turn_finished
        @current_idx = (@current_idx + 1) % entrants.size
        entrants.to_a[@current_idx].last.start_turn
      end
    end

    ranking
  end

  def ranking
    return unless entrants.all? { |_, entrant| entrant.state == :racing }

    entrants.to_a.sort_by do |car, entrant|
      entrant.track_position.first
    end.reverse.each_with_index do |car_entrant, idx|
      _car, entrant = car_entrant
      puts "#{idx + 1} #{entrant.name} #{ entrant.track_position.first }"
    end
  end
end
