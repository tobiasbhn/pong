class String
  # colorization
  def red
    "\e[41mProcess Log Warning:\e[0m\e[31m #{self}\e[0m"
  end

  def green
    "\e[42mProcess Log Message:\e[0m\e[32m #{self}\e[0m"
  end

  def socket
    "\e[43mProcess Log Websocket:\e[0m\e[33m #{self}\e[0m"
  end

  def tb
    "\e[45mProcess Log Trailblazer:\e[0m\e[35m #{self}\e[0m"
  end

  def cookie
    "\e[46mProcess Log Cookie:\e[0m\e[36m #{self}\e[0m"
  end
end