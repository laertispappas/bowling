RSpec.shared_examples "game response" do
  it "has the correct hame response payload" do
    game = Game.find(payload["id"])

    expect(payload["current_player"]).to eq game.current_player.id unless game.completed?
    expect(payload["current_player"]).to eq nil if game.completed?

    expect(payload["current_frame"]).to eq game.current_active_frame.id unless game.completed?
    expect(payload["current_frame"]).to eq nil if game.completed?
    expect(payload["completed"]).to eq game.completed?
    expect(payload["winner"]).to eq game.winner

    players = payload["players"]
    expect(players.size).to eq game.players.size
    players.size.times do |player_index|
      user = User.find(players[player_index]["id"])
      expect(players[player_index]["total_score"]).to eq game.score(user)
      expect(players[player_index]["name"]).to eq user.name
    end

    game.players.size.times do |player_index|
      frames = payload["players"][player_index]["frames"]
      expect(frames.size).to eq 10
      0.upto(9) do |f_index|
        persisted_frame = game.players[player_index].frames[f_index]
        expect(frames[f_index]["score"]).to eq(persisted_frame.score)
        expect(frames[f_index]["rolls"]).to eq(persisted_frame.rolls.map { |r| r.score })
      end
    end
  end
end
