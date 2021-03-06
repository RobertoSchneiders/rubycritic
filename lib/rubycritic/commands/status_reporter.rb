module Rubycritic
  module Command
    class StatusReporter
      attr_reader :status, :status_message
      SUCCESS = 0
      SCORE_BELOW_MINIMUM = 1

      def initialize(options)
        @options = options
        @status = SUCCESS
      end

      def score=(score)
        @score = score
        update_status
      end

      private

      def update_status
        @status = current_status
        update_status_message
      end

      def current_status
        satisfy_minimum_score_rule ? SUCCESS : SCORE_BELOW_MINIMUM
      end

      def satisfy_minimum_score_rule
        @score >= @options[:minimum_score]
      end

      def update_status_message
        case @status
        when SUCCESS
          @status_message = "Score: #{@score}"
        when SCORE_BELOW_MINIMUM
          @status_message = "Score (#{@score}) is below the minimum #{@options[:minimum_score]}"
        end
      end
    end
  end
end
