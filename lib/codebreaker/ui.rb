# frozen_string_literal: true

module Codebreaker
  class UI
    def initialize
      @game = Game.new
    end

    def run
      puts 'Welcome to the Codebreaker game!'

      loop do
        puts "\n" \
             "If you want we can start... [yes/no]?    \n" \
             "or \n" \
             "You can watch high scores [watch]?\n" \
             "\n"
        print '-> '

        case gets.chomp
        when 'yes' then play
        when 'watch' then puts high_scores
        when 'no'
          puts 'See ya'
          break
        else puts 'Wrong choice!'
        end
      end
    end

    private

    def play
      @game.start
      puts "\n" \
           "New game was started... \n" \
           "\n" \
           "Hint? [y/n]? \n" \
           "secret code... \n" \

      until @game.finished?
        print "maybe -> "
        input = gets.chomp

        case input
        when 'y' then hint(@game.hint, @game.hints)
        when 'n' then return
        else check_it(input)
        end
      end

      if @game.result
        won(@game.answer)
        save_score
      else
        lose(@game.answer)
      end
    end


    def high_scores
      scores = @game.high_scores

      return 'No scores' if scores.empty?

      scores.map
            .with_index { |user, i| format("%2i #{user.formatted}", i + 1) }
            .unshift(format('%2s %5s %2s', '#', 'Name', 'Points'))

    end

    def hint(hint, hints)
        if hint
          puts "Hint #{hint}.", "hints #{hints}."
        else
          puts 'No hints left.', "\n"
        end
      end

    def check_it(input)
      puts @game.check_it(input)
      tries(@game.tries)
    rescue ArgumentError => ex
      puts ex.message, "\n"
    end

    def won(answer)
      puts 'You won!'
    end

    def lose(answer)
      puts 'Game Over'
    end

    def tries(tries)
      puts "tries left #{tries}", "\n"
    end

    def save_score
      print 'Do you want to save your score? y/n: '

      return unless gets.chomp.casecmp('y').zero?

      begin
        print 'Write your name: '
        @game.save_score(gets.chomp)
        puts 'Your score was saved.'
      rescue ArgumentError => ex
        puts ex.message, "\n"
        retry
      end
    end
  end
end
