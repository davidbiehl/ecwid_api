class String
  def camel_case
    split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end unless method_defined?(:camel_case)
end