class Message < Sequel::Model
  def ignore?
    @@rules ||= self.db[:ignore_rules]
    @@rules.any? do |rule_hash|
      rule = Regexp.new(rule_hash[:rule])
      !rule.match(self.from).nil?
    end
  end
end
