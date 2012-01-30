class String
  def titlecase
    self.downcase.gsub(/\b('?[a-z])/) { $1.capitalize }
  end
end
