require 'optparse'
require 'rubycritic/browser'

module Rubycritic
  module Cli
    class Options
      def initialize(argv)
        @argv = argv
        @parser = OptionParser.new
      end

      # rubocop:disable Metrics/MethodLength
      def parse
        @parser.new do |opts|
          opts.banner = 'Usage: rubycritic [options] [paths]'

          opts.on('-p', '--path [PATH]', 'Set path where report will be saved (tmp/rubycritic by default)') do |path|
            @root = path
          end

          opts.on(
            '-f', '--format [FORMAT]',
            [:html, :json, :console],
            'Report smells in the given format:',
            '  html (default)',
            '  json',
            '  console'
          ) do |format|
            @format = format
          end

          opts.on('-s', '--minimum-score [MIN_SCORE]', 'Set a minimum score') do |min_score|
            @minimum_score = Integer(min_score)
          end

          opts.on('-m', '--mode-ci', 'Use CI mode (faster, but only analyses last commit)') do
            @mode = :ci
          end

          opts.on('--deduplicate-symlinks', 'De-duplicate symlinks based on their final target') do
            @deduplicate_symlinks = true
          end

          opts.on('--suppress-ratings', 'Suppress letter ratings') do
            @suppress_ratings = true
          end

          opts.on('-O ', '--open',
                  Rubycritic::Browser::SUPPORTS,
                  "Open html report with browser: #{Rubycritic::Browser::SUPPORTS}"
                 ) do |open_with|
            @open_with = open_with
          end

          opts.on_tail('-v', '--version', "Show gem's version") do
            @mode = :version
          end

          opts.on_tail('-h', '--help', 'Show this message') do
            @mode = :help
          end
        end.parse!(@argv)
        self
      end

      def to_h
        {
          mode: @mode,
          root: @root,
          format: @format,
          deduplicate_symlinks: @deduplicate_symlinks,
          paths: paths,
          suppress_ratings: @suppress_ratings,
          help_text: @parser.help,
          minimum_score: @minimum_score || 0,
          open_with: @open_with
        }
      end

      private

      def paths
        if @argv.empty?
          ['.']
        else
          @argv
        end
      end
    end
  end
end
