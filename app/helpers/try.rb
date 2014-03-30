class Try
  attr_accessor :error, :success

  #shortcuts
  def self.error(error)
    self.new({error: error})
  end

  def self.success(success)
    self.new({success: success})
  end
  
  def initialize(options)
    if options[:error] && options[:success]
      raise "Try can only be initialized with error or success not both"
    elsif options[:error]
      @error = options[:error]
    elsif options[:success]
      @success = options[:success]
    else
      raise "Try must be initialized with either error or success"
    end
  end

  def error?
    !!@error
  end

  def success?
    !!@success
  end
end
