# update fields within current geoplan network with unit rate estimates

# notes: 
folder_ruby = 'C:\Program Files (x86)\Innovyze Workgroup Client 2025.0\lib\ruby\2.4.0'

## libraries
load folder_ruby + '\date.rb'
load folder_ruby + '\cmath.rb'
load folder_ruby + '\bigdecimal\math.rb'

## connection
db=WSApplication.current_database 
net=WSApplication.current_network

puts ".... connection established"

## parameters
source = 'John Styles, Krzysztof Tchorzewski, Tony Andrews'
curyear = Time.now.strftime('%Y').to_i
flag_calc = 'AS'
flag_unsure = 'XX'

## paremters used for flow calcs
gravity = 9.81
dyn_visc = 0.00000114
deg_rad_convert = 0.0174532925
lining_thickness = 50

## open up network for writing
net.clear_selection
net.transaction_begin

## looping and updating each asset
p = net.row_objects('cams_pipe').each do |p|

	# rigid non-metal pipes
	if 
		p['pipe_material'] == 'AC' || 
		p['pipe_material'] == 'CONC' ||
		p['pipe_material'] == 'EW' ||
		p['pipe_material'] == 'CLSTEEL'
			roughness = 0.6
	# flexible pipes
	elsif 
		p['pipe_material'] == 'UPVCLINE' ||
		p['pipe_material'] == 'UPVC' ||
		p['pipe_material'] == 'U - POLYVINYL CHLORIDE' ||
		p['pipe_material'] == 'STRUCTURAL LINER UPVC' ||
		p['pipe_material'] == 'PVC' ||
		p['pipe_material'] == 'FIBGLASS' ||
		p['pipe_material'] == 'HDPE' ||
		p['pipe_material'] == 'MDPE' ||
		p['pipe_material'] == 'MPVC' ||
		p['pipe_material'] == 'PE' ||
		p['pipe_material'] == 'PE100' ||
		p['pipe_material'] == 'POLYETHYLENE (PE100)' ||
		p['pipe_material'] == 'POLYVINYL CHLORIDE' ||
		p['pipe_material'] == 'ALK' ||
		p['pipe_material'] == 'PP'
			roughness = 0.3
	# steel pipes
	elsif 
		p['pipe_material'] == 'SSTEEL' ||
		p['pipe_material'] == 'STAINLESS STEEL' ||
		p['pipe_material'] == 'STEEL'
			roughness = 0.15
	# other metal pipes
	elsif 
		p['pipe_material'] == 'CI' ||
		p['pipe_material'] == 'DI'
			roughness = 0.15
	else
		roughness = 0.3
	end

	if p['gradient'].nil? || p['ds_width'].nil? || p['gradient'] < 0
		p['capacity'] = ''
		p['capacity_flag'] = flag_unsure
	else
		# redcue internal diameter where 
		# pipe has been slip lined
		if p['lining_type'].nil?
			pipe_size = p['ds_width']/1000
		else
			pipe_size = (p['ds_width']-lining_thickness)/1000
		end
		# sometimes the gradient is flat
		# so provide a slither of a grade
		if p['gradient'] == 0
			gradient = 0.001
		else
			gradient = p['gradient'].to_f
		end		
		# calculations
		pipe_size = p['ds_width']/1000
		
		# full pipe flows - pipe full capacity check
		depth = pipe_size
		theta = 2*(Math.acos((1-((2*depth)/pipe_size))))# *deg_rad_convert # not needed
		wettedP = (pipe_size*theta.to_f)/2
		pipe_area = ((pipe_size**2)/8)*(theta-Math.sin(theta))
		hydrR = pipe_area/wettedP
		SCF = (theta-(Math.sin(theta)))/theta
		velocity = -2*((2*gravity*gradient*SCF*pipe_size)**0.5)*Math::log10((((roughness/1000)/(3.7*SCF*pipe_size))+((2.51*dyn_visc)/((SCF*pipe_size)*((2*gravity*gradient*SCF*pipe_size)**0.5)))))
		flow = ((velocity*SCF*theta*(pipe_size**2))/8)
		#widthB =(pipe_size)*Math.sin(theta/2)
		#HydrMeanD = pipe_area/widthB
		#FroudeNo = velocity/((gravity*HydrMeanD)**0.5)
		
		# half pipe velocities - PDWF self cleansing check
		depth_half = pipe_size
		theta_half = 2*(Math.acos((1-((2*depth_half)/pipe_size))))
		wettedP_half = (pipe_size*theta_half.to_f)/2
		pipe_area_half = ((pipe_size**2)/8)*(theta_half-Math.sin(theta_half))
		hydrR = pipe_area_half/wettedP_half
		SCF_half = (theta_half-(Math.sin(theta_half)))/theta_half
		velocity_half = -2*((2*gravity*gradient*SCF_half*pipe_size)**0.5)*Math::log10((((roughness/1000)/(3.7*SCF_half*pipe_size))+((2.51*dyn_visc)/((SCF_half*pipe_size)*((2*gravity*gradient*SCF_half*pipe_size)**0.5)))))
		
		# pressure pipe capacities
		# to do!
		
		# load into IAM
		p['capacity'] = flow.round(3)
		p['user_number_5'] = velocity_half.round(3)
		
		p['capacity_flag'] = flag_calc
		p['user_number_5_flag'] = flag_calc
		
	end
	
p.write

end

net.transaction_commit