module SpecSupport
  module GameResponseAssertions
    # TODO: Move to shared example
    # Not huge fun of loops in specs. But I will keep them for now
    #
    def assert_game_response
      game = Game.find(payload["id"])
      expect(payload["current_player"]).to eq game.current_player.id
      assert_players_response(game)
      assert_frames_response(game)
    end

    def assert_frames_response(game)
      game.game_frames.size.times do |gf_index|
        frames = payload["players"][gf_index]["frames"]
        expect(frames.size).to eq 10
        0.upto(9) do |f_index|
          persisted_frame = game.game_frames[gf_index].frames[f_index]
          expect(frames[f_index]["score"]).to eq(persisted_frame.score)
          expect(frames[f_index]["rolls"]).to eq(persisted_frame.rolls.map { |r| r.score })
        end
      end
    end

    def assert_players_response(game)
      players = payload["players"]
      expect(players.size).to eq game.game_frames.size
      players.size.times do |player_index|
        user = User.find(players[player_index]["id"])
        expect(players[player_index]["total_score"]).to eq game.score(user)
      end
    end
  end
end
