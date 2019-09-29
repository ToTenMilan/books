require 'socket'

exceptions = []
tree = {}
ObjectSpace.each_object(Class) do |cls|
  next unless cls.ancestors.include? TCPSocket # try variuos class
  next if exceptions.include? cls
  # Ograniczamy wyniki
  next if cls.superclass == SystemCallError 
  exceptions << cls
  cls.ancestors.delete_if { |e| 
  	[Object, Kernel].include? e 
  }.reverse.inject(tree) { |memo,cls| 
  	memo[cls] ||= {}
  }
end

indent = 0
tree_printer = Proc.new do |t|
  t.keys.sort { |c1, c2|
    c1.name <=> c2.name
  }.each do |k|
    space = (' ' * indent); space ||= ''
    puts space + k.to_s
    indent += 2
    tree_printer.call t[k]
    indent -= 2
  end
end

tree_printer.call tree
