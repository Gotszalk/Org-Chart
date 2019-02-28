require 'csv'
require 'erb'

class Array

 def to_cleararr
  cleararr = []
  self.each do |row|
   cleararr << row[0].split(',')
  end
 
  return cleararr
 
 end

end

#loads structure file csv, returns structure as array
def loadStructure(file)
 csv_text = File.read(file)
 return CSV.parse(csv_text, :headers => true)
 
end

# returns array of children
def findChildren (parent, structure)
 #search for items in structure where item.manager = parent
 children = []
 
 #puts parent
 
 structure.each do |employee|
 
  #puts '> ' + employee.join(', ')
  
  if employee[2].eql? parent
   
   #puts 'got it!'
   
   children << employee
  end
 end
 
 return children

end

# returns content 
def generateLevel (parents, structure, level)
 content = ''
 
 #define level per node
 hindex = level +1
 
 parents.each do |parent|
  parent[3] = hindex
 end
 
 parents.each do |parent|
  children = findChildren(parent[0], structure)
  
  puts 'parent: '+ parent.join(',').to_s + '- ' + children.size.to_s + ' children'
  #puts '>' + parent
  
  #adjust content for current parent
  
  content += '<li>
                <div>
                    <h' + parent[3].to_s + '>' + parent[0].to_s + '<br />' + parent[1].to_s + '</'+ parent[3].to_s + '>
                </div>
                '
  
  if children.size > 0
  #recurence if there are children
   
   level += 1
   content += '<ol>
   ' + generateLevel(children, structure, level) + '
   </ol>
   '
  
  end
 end

return content

end

structure = loadStructure('structure.csv').to_cleararr
uberfather = findChildren('1', structure)

#puts structure[2][0]
#puts 'uberfather' + uberfather.to_s

content = generateLevel(uberfather, structure, 0)

#puts content

 template = 'template.html'
  
renderer = ERB.new(File.read(template))
content = renderer.result()

#below writes file

File.open('result.html', 'w+:UTF-8') do |f|
 f.write(content)
end


#puts findChildren('1',loadStructure('structure.csv').to_cleararr)

#puts loadStructure('structure.csv').to_cleararr[2][2]
