require 'yaml'

# Builds a yaml file from user input
class YamlBuilder
  def initialize
    @file = './rooms.yml'
    @room_list = load_list 
  end

  def load_list
    loaded_data = YAML.load_file(@file)
  end

  
  def run
  end
end

app = YamlBuilder.new
app.run
