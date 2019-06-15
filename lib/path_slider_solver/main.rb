# frozen_string_literal: true

module PathSliderSolver
  class Main

    HOP = 0
    PATH = 1

    attr_reader :map, :visited

    def initialize(map)
      @map = map
      @row_size = @map.size
      @column_size = @map[0].size

      @mover_position = locate(:mover)
      @map[@mover_position[0]][@mover_position[1]] = nil

      @target_position = locate(:target)

      @solution_positions = possible_solution_positions

      @visited = {
        @mover_position => [0, [@mover_position]]
      }
    end

    def solve
      positions = [@mover_position]

      until positions.empty?
        positions = positions.inject([]) do |new_positions, position|
          new_positions + mark_next_hop_positions(position)
        end
      end
    end

    def solutions
      @solutions ||= @visited.select do |pos, _|
        @solution_positions.include?(pos)
      end
    end

    def solution
      solutions.values.max
    end

    private

    def mark_next_hop_positions(start)
      next_hops = find_next_hops_from(start) || []

      # Weed out the already visited positions since they will not be
      # reached again in fewer hops

      next_hops = next_hops.reject { |position| @visited.key?(position) }

      next_hops.each do |position|
        @visited[position] = [
          @visited[start][HOP] + 1,
          @visited[start][PATH] + [position]
        ]
      end

      next_hops
    end

    def possible_solution_positions
      row, column = @target_position

      positions = []

      positions << [row + 1, column] if (row + 1) < @row_size
      positions << [row - 1, column] if (row - 1).positive?

      positions << [row, column + 1] if (column + 1) < @column_size
      positions << [row, column - 1] if (column - 1).positive?

      positions.select do |r, c|
        @map[r][c].nil? && ([r, c] != @mover_position)
      end
    end

    def locate(piece)
      @row_size.times.each do |row|
        @column_size.times.each do |column|
          return [row, column].freeze if @map[row][column] == piece
        end
      end
    end

    def find_next_hops_from(position)
      movable_positions = []
      mover_row, mover_column = position

      # Left
      column = (0...mover_column).reverse_each.find do |next_column|
        blocked?(mover_row, next_column)
      end
      movable_positions << [mover_row, column + 1] unless column.nil?

      # Right
      column = ((mover_column + 1)...@column_size).find do |next_column|
        blocked?(mover_row, next_column)
      end
      movable_positions << [mover_row, column - 1] unless column.nil?

      # Up
      row = (0...mover_row).reverse_each.find do |next_row|
        blocked?(next_row, mover_column)
      end

      movable_positions << [row + 1, mover_column] unless row.nil?

      # Down
      row = ((mover_row + 1)...@row_size).find do |next_row|
        blocked?(next_row, mover_column)
      end
      movable_positions << [row - 1, mover_column] unless row.nil?

      movable_positions
    end

    def blocked?(row, column)
      !@map[row][column].nil?
    end
  end
end
