class Race
  class Entrant
    attr_reader :name, :state, :is_turn, :track_position

    def initialize(name)
      @name = name
      @state = :pre_start
      @is_turn = false
      @track_position = nil
    end

    def on_track?
      !track_position.nil?
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

  attr_reader :track, :colors_entrants, :entrants

  def initialize(track, colors)
    @track = track

    @colors_entrants = Hash[colors.map { |color| [color, Entrant.new(color)] }]
    @entrants = colors_entrants.values

    @current_idx = 0
    entrants.first.start_turn
  end

  def update(dirty_colors)
    dirty_colors.each do |color, track_position|
      entrant = colors_entrants[color]
      turn_finished = entrant.update track_position
      if turn_finished
        @current_idx = (@current_idx + 1) % entrants.size
        entrants[@current_idx].start_turn
      end
    end

    ranking
  end

  def ranking
    return unless entrants.all? { |entrant| entrant.state == :racing }

    entrants.sort_by do |entrant|
      entrant.track_position.first
    end.reverse.each_with_index do |entrant, idx|
      puts "#{idx + 1} #{entrant.name} #{ entrant.track_position.first }"
    end
  end
end
