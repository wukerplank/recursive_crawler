require "recursive_crawler/version"

require "shellwords"

module RecursiveCrawler

  class Crawler
    attr_accessor :match_filename, :matched_file_block, :match_directory, :matched_directory_block

    def initialize
      @match_filename = /\A.*\z/i
      @matched_file_block = ->(path){}
      @match_directory = /\A.*\z/i
      @matched_directory_block = ->(path){}
    end

    def run(path)
      Dir.glob(File.join(Shellwords.shellescape(path), '*')).each do |e|
        if File.directory?(e)
          @matched_directory_block.call(e) if e.match(@match_directory)
          run(e)
        else
          @matched_file_block.call(e) if File.basename(e).match(@match_filename)
        end
      end
    end
  end
end
