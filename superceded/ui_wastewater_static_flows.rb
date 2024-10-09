## libraries

## parameters
cap_flag='CAP'

## script
net=WSApplication.current_network
WSApplication.use_user_units=false
net.transaction_begin

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
	pipe.user_number_8 = area  					# building footprint area
	pipe.user_number_9 =  0.0 					# cumulative area
	pipe.user_number_10 = contributing_area  	# site area limited to parcel area
	pipe.user_number_11 = 0.0 					# cumulative contributing_area
	
	pipe.user_number_6_flag = cap_flag
	pipe.user_number_7_flag = cap_flag
	pipe.user_number_8_flag = cap_flag
	pipe.user_number_9_flag = cap_flag
	pipe.user_number_10_flag = cap_flag
	pipe.user_number_11_flag = cap_flag
	
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
					dsl.user_number_7_flag = cap_flag
					dsl.user_number_9 = m._are + dsl.user_number_8
					dsl.user_number_9_flag = cap_flag
					dsl.user_number_11 = m._caa + dsl.user_number_10
					dsl.user_number_11_flag = cap_flag			
					dsl.write
					newNode = dsl.ds_node
					if newNode 
						if !newNode._seen
							newNode._occ = dsl.user_number_7
							newNode._are = dsl.user_number_9
							newNode._caa = dsl.user_number_11
							newNode._seen = true
							workingNodes << newNode
						else
							newNode._occ+= dsl.user_number_7
							newNode._are+= dsl.user_number_9
							newNode._caa+= dsl.user_number_11
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

net.transaction_commit