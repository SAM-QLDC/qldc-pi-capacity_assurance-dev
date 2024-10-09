# update fields within current geoplan network with unit rate estimates and design capacity

# notes: 
folder_ruby = 'C:\Program Files (x86)\Innovyze Workgroup Client 2025.0\lib\ruby\2.4.0'

## libraries
load folder_ruby + '\date.rb'
load folder_ruby + '\cmath.rb'
load folder_ruby + '\bigdecimal\math.rb'

## parameters
curyear = Time.now.strftime('%Y').to_i
flag_calc = 'CAP'
flag_unsure = 'XX'

## script
net=WSApplication.current_network
net.transaction_begin

## pipe capacity calcs
cap = net.row_objects('cams_pipe').each do |cap|
	
	gravity = 9.81
	dyn_visc = 0.00000114
	deg_rad_convert = 0.0174532925
	lining_thickness = 50

	# rigid non-metal pipes
	if 
		cap['pipe_material'] == 'AC' || 
		cap['pipe_material'] == 'CONC' ||
		cap['pipe_material'] == 'EW' ||
		cap['pipe_material'] == 'CLSTEEL'
			roughness = 0.6
	# flexible pipes
	elsif 
		cap['pipe_material'] == 'UPVCLINE' ||
		cap['pipe_material'] == 'UPVC' ||
		cap['pipe_material'] == 'U - POLYVINYL CHLORIDE' ||
		cap['pipe_material'] == 'STRUCTURAL LINER UPVC' ||
		cap['pipe_material'] == 'PVC' ||
		cap['pipe_material'] == 'FIBGLASS' ||
		cap['pipe_material'] == 'HDPE' ||
		cap['pipe_material'] == 'MDPE' ||
		cap['pipe_material'] == 'MPVC' ||
		cap['pipe_material'] == 'PE' ||
		cap['pipe_material'] == 'PE100' ||
		cap['pipe_material'] == 'POLYETHYLENE (PE100)' ||
		cap['pipe_material'] == 'POLYVINYL CHLORIDE' ||
		cap['pipe_material'] == 'ALK' ||
		cap['pipe_material'] == 'PP'
			roughness = 0.3
	# steel pipes
	elsif 
		cap['pipe_material'] == 'SSTEEL' ||
		cap['pipe_material'] == 'STAINLESS STEEL' ||
		cap['pipe_material'] == 'STEEL'
			roughness = 0.15
	# other metal pipes
	elsif 
		cap['pipe_material'] == 'CI' ||
		cap['pipe_material'] == 'DI'
			roughness = 0.15
	else
		roughness = 0.3
	end

	if cap['gradient'].nil? || cap['ds_width'].nil? || cap['gradient'] < 0
		cap['capacity'] = 0 # chaneg this in time
		cap['capacity_flag'] = flag_unsure
	else
		# redcue internal diameter where 
		# pipe has been slip lined
		if cap['lining_type'].nil?
			pipe_size = cap['ds_width']/1000
		else
			pipe_size = (cap['ds_width']-lining_thickness)/1000
		end
		# sometimes the gradient is flat
		# so provide a slither of a grade
		if cap['gradient'] == 0
			gradient = 0.001
		else
			gradient = cap['gradient'].to_f
		end		
		# calculations
		pipe_size = cap['ds_width']/1000
		
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
		cap['capacity'] = flow.round(3)
		cap['user_number_5'] = velocity_half.round(3) # self celansing velocities
		
		cap['capacity_flag'] = flag_calc
		cap['user_number_5_flag'] = flag_calc
	end
cap.write
end

# dry weather flow variables used to estimated static design flows
net.row_objects('cams_pipe').each do |pipe|
	properties = pipe.navigate('properties')
	
	count=0
	area=0.0
	occupancy=0
	contributing_area=0.0
	
	properties.each do |p|
		if p.property_type.upcase=='RESIDENTIAL' || p.property_type.upcase=='GREENFIELD'
			if p.occupancy.nil?
				oc = 0
			else
				oc = p.occupancy
			end	
			
			if p.user_number_1.nil?
				ca = 0
			else
				ca = p.user_number_1 
			end
			
			count+=1 							# basic count to test script
			occupancy+=oc 						# occupancy taken from property layer
			area+=p.area/10000 					# buidling footprint in Ha					
			contributing_area+=ca/10000 		# 10m buffer area in Ha
			
		end
	end
	pipe.user_number_6 = occupancy 				# occupancy at each pipe
	pipe.user_number_7 = 0.0  					# cumulative occupancy
	#pipe.user_number_8 = area  				# building footprint area
	#pipe.user_number_9 =  0.0 					# cumulative area
	#pipe.user_number_10 = contributing_area  	# site area limited to parcel area
	#pipe.user_number_11 = 0.0 					# cumulative contributing_area
	
	pipe.user_number_6_flag = flag_calc
	pipe.user_number_7_flag = flag_calc
	#pipe.user_number_8_flag = flag_calc
	#pipe.user_number_9_flag = flag_calc
	#pipe.user_number_10_flag = flag_calc
	#pipe.user_number_11_flag = flag_calc
	
	pipe.write
end

# initialise arrays and find all nodes with no upstream pipes
workingNodes = Array.new
net.row_objects('cams_manhole').each do |m|
	m._seen = false
	m._occ = 0
	m._are = 0
	m._caa = 0
	m._lth = 0.0
	found = 0
	m.us_links.each do |l|
		if l.table=='cams_pipe'
			found+=1
		end
	end
	m._unprocessed = found
	if found==0
		workingNodes << m
	end
end
net.row_objects('cams_pipe').each do |p|
	p._seen=false
end

# downstream tracing to accumulate dwf numbers
while true
	somethingProcessed=false
	(0...workingNodes.size).each do |i|
		m=workingNodes[i]
		if m._unprocessed==0
			m.ds_links.each do |dsl|
				if dsl.table=='cams_pipe'
					dsl.user_number_7 = m._occ + dsl.user_number_6
					dsl.user_number_7_flag = flag_calc
					#dsl.user_number_9 = m._are + dsl.user_number_8
					#dsl.user_number_9_flag = flag_calc
					#dsl.user_number_11 = m._caa + dsl.user_number_10
					#dsl.user_number_11_flag = flag_calc			
					dsl.write
					newNode = dsl.ds_node
					if newNode 
						if !newNode._seen
							newNode._occ = dsl.user_number_7
							#newNode._are = dsl.user_number_9
							#newNode._caa = dsl.user_number_11
							newNode._seen = true
							workingNodes << newNode
						else
							newNode._occ+= dsl.user_number_7
							#newNode._are+= dsl.user_number_9
							#newNode._caa+= dsl.user_number_11
						end
						newNode._unprocessed-=1
					end				
				end			
			end			
			somethingProcessed=true
			workingNodes.delete_at(i)
			break			
		end		
	end
	if !somethingProcessed
		break
	end
end

## design flow calcultions

des = net.row_objects('cams_pipe').each do |des|
	
	dwf = 250 # 250 litres per day for each person
	dwf_pf = 2.5 # peaking factor for dry weather flows
	wwf_pf = 2 # wet weather flow peaking factor
	#people = 3 # number of people per residential dwelling

	design_flow = (des['user_number_7']*(dwf*dwf_pf*wwf_pf))/86400/1000 # in m3/s
		
	# load into IAM
	des['user_number_8'] = design_flow
	des['user_number_8_flag'] = flag_calc
	
des.write

end

net.transaction_commit