# frozen_string_literal: true

module PathSliderSolver
  class Map
    attr_reader :mover_position, :solution_positions

    def initialize(map)
      @map = map
      @row_size = @map.size
      @column_size = @map[0].size

      @mover_position = locate(:mover)
      @map[@mover_position[0]][@mover_position[1]] = nil

      @target_position = locate(:target)
      @solution_positions = possible_solution_positions
    end

    def place(row, column, block)
      validate_position!(row, column)
      @map[row][column] = block
    end

    def blocked?(row, column)
      validate_position!(row, column)
      !@map[row][column].nil?
    end

    def next_hops(from_position)
      movable_positions = []
      mover_row, mover_column = from_position

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

    def validate_position!(row, column)
      if row.negative? || row >= @row_size
        raise "row #{row} out of bound"
      end

      if column.negative? || column >= @column_size
        raise "column #{column} out of bound"
      end
    end
  end
end
