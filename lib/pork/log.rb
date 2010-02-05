module Pork
  class Log
    attr_accessor :log, :researcher, :project, :output
  
    def initialize(output, options = {})
      @log = Logger.new(output)
      @log.level = "info"
      @researcher = options[:researcher] if options[:researcher]
      @project = options[:project] if options[:project]
    end
  
    def write(message)
      @log.info("#{@project}, #{@researcher}, #{Time.now}: " + message)
    end
  end
end