class YARD::Handlers::Ruby::PlaceholderMatchHandler < YARD::Handlers::Ruby::Base
  handles method_call(:match)

  process do
    if owner.is_a?(YARD::CodeObjects::Placeholder)
      regex = "(?:#{statement.parameters[0].source.gsub(/^(["\/]|%r[{])|([}]|["\/])$/,'')})"
      if owner.value
        owner.value = "#{owner.value}|#{regex}"
      else
        owner.value = regex
      end
    end
  rescue StandardError => e
    log.warn(e.backtrace)
    log.warn(e)
  end
end
