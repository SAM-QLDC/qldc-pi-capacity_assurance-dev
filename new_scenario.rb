## parameters
source = 'John Styles, Krzysztof Tchorzewski, Tony Andrews'
curyear = Time.now.strftime('%Y').to_i

# Access the current network from the WSApplication
net=WSApplication.current_network

# Create an array and scenarios
scenarios=Array.new
scenarios=[curyear+'_testing']

# delete all scenarios
net.scenarios do |scenario|
    if scenario != 'Base'
        net.delete_scenario(scenario)
    end
end
puts 'All scenarios deleted'

# create new scenarios based on above array
scenarios.each do |scenario|
	net.add_scenario(scenario,nil,'')
end