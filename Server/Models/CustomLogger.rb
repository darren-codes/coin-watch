require 'logger'

class CustomLogger < Logger
  def log(str)
    info(str)
  end

  # other methods available info, warn, error
end
