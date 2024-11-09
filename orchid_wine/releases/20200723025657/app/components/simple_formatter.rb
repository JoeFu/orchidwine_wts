# Simple formatter which only displays the message.
class SimpleFormatter < ::Logger::Formatter
  # This method is invoked when a log event occurs
  def call(severity, timestamp, progname, msg)
    "#{String === msg ? msg : msg.inspect}\n"
  end

  #Format = "%s, [%s#%d] %5s -- %s: %s\n"
  # def call(severity, time, progname, msg)
  #   Format % [severity[0..0], format_datetime(time), $$, severity, progname,
  #             msg2str(msg)]
  # end

  # def msg2str(msg)
  #   case msg
  #   when ::String
  #     msg
  #   when ::Exception
  #     "#{ msg.message } (#{ msg.class })\n" <<
  #       (msg.backtrace || []).join("\n")
  #   else
  #     msg.inspect
  #   end
  # end
end
