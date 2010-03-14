module Pork
  class Log
    attr_accessor :log, :researcher, :project, :output
  
    def initialize(output, options = {})
      @log = Logger.new(output)
      @log.level = Logger::INFO
      @researcher =  options[:researcher]? options[:researcher] : nil
      @project = options[:project]? options[:project] : nil
    end
  
    def write(message)
      @log.info("#{@project ? @project + ', ' : ''}#{@researcher ? @researcher + ', ' : ''}#{Time.now.to_s} -- " + message)
    end
  end
end