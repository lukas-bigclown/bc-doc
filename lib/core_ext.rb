class String
  # Strips indentation in heredocs.
  def unindent
    gsub(/^#{scan(/^[ \t]*(?=\S)/).min}/, ''.freeze)
  end
end
