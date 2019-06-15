# frozen_string_literal: true

RSpec.describe PathSliderSolver::Main do
  let(:map) do
    [
      [nil, :target, :nil],
      [nil, nil, nil],
      [nil, :mover, nil]
    ]
  end

  let(:solver) { described_class.new(map) }

  it 'solves' do
    solver.solve

    expect(solver.solution).to eq [1, [[2, 1], [1, 1]]]
  end

  context 'more complex map' do
    let(:map) do
      [
        [nil,    :target, nil],
        [nil,    nil,     :block],
        [:block, nil,     nil],
        [:block, nil,     :mover]
      ]
    end

    it 'solves' do
      solver.solve
      expect(solver.solution).to eq [2, [[3, 2], [3, 1], [1, 1]]]
    end
  end

  context 'Easy 1-4' do
    let(:map) do
      a = Array.new(8) { Array.new(7) }

      a[0][1] = :block
      a[1][5] = :mover
      a[1][6] = :block
      a[2][4] = :target
      a[5][0] = :block
      a[6][5] = :block
      a[7][1] = :block

      a
    end

    it 'solves' do
      solver.solve
      expect(solver.solution).to eq [5, [[1, 5], [5, 5], [5, 1], [6, 1], [6, 4], [3, 4]]]
    end
  end
end
