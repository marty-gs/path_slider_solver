# frozen_string_literal: true

module PathSliderSolver
  class Main
    HOP  = 0
    PATH = 1

    attr_reader :map, :visited

    def initialize(matrix)
      @map = Map.new(matrix)

      @visited = {
        @map.mover_position => [0, [@map.mover_position]]
      }
    end

    def solve
      positions = [@map.mover_position]

      until positions.empty?
        positions = positions.inject([]) do |new_positions, position|
          new_positions + mark_next_hop_positions(position)
        end
      end

      # The solution
      @visited.select do |pos, _|
        @map.solution_positions.include?(pos)
      end.values.max
    end

    private

    def mark_next_hop_positions(start)
      next_hops = @map.next_hops(start) || []

      # Weed out the already visited positions since they will not be
      # reached again in fewer hops

      next_hops = next_hops.reject { |position| @visited.key?(position) }

      # Mark the new positions as visited
      next_hops.each do |position|
        @visited[position] = [
          @visited[start][HOP] + 1,
          @visited[start][PATH] + [position]
        ]
      end

      # Return the new position to continue marking
      next_hops
    end
  end
end
