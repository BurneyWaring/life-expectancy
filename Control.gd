extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#

#fractions dead up to 120 years old
#male
var fracdeadoriginal = [0.0063, 0.0004, 0.0003, 0.0002, 0.0002, 0.0002, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0002, 0.0003, 0.0004, 0.0005, 0.0006, 0.0007, 0.0009, 0.001, 0.0012, 0.0013, 0.0013, 0.0013, 0.0013, 0.0014, 0.0014, 0.0014, 0.0015, 0.0015, 0.0015, 0.0016, 0.0016, 0.0017, 0.0017, 0.0018, 0.0019, 0.0019, 0.002, 0.0021, 0.0023, 0.0024, 0.0026, 0.0028, 0.0031, 0.0034, 0.0037, 0.0041, 0.0045, 0.005, 0.0055, 0.006, 0.0066, 0.0072, 0.0078, 0.0085, 0.0092, 0.0099, 0.0106, 0.0114, 0.0122, 0.0131, 0.0139, 0.0148, 0.0158, 0.017, 0.0183, 0.0198, 0.0214, 0.0234, 0.0255, 0.0279, 0.0304, 0.0331, 0.0363, 0.0399, 0.0439, 0.0483, 0.0531, 0.0587, 0.0651, 0.0721, 0.0799, 0.0885, 0.0981, 0.1089, 0.1209, 0.1341, 0.1487, 0.1645, 0.1816, 0.1999, 0.2193, 0.2399, 0.2603, 0.2801, 0.299, 0.3166, 0.3324, 0.349, 0.3665, 0.3848, 0.404, 0.4242, 0.4455, 0.4677, 0.4911, 0.5157, 0.5415, 0.5685, 0.597, 0.6268, 0.6581, 0.691, 0.7256, 0.7619, 0.8, 0.84, 0.882]
#female
#var fracdeadoriginal = [0.005313, 0.000346, 0.000221, 0.000162, 0.000131, 0.000116, 0.000106, 0.000098, 0.000091, 0.000086, 0.000084, 0.000087, 0.0001, 0.000124, 0.000157, 0.000194, 0.000232, 0.000269, 0.000304, 0.000338, 0.000373, 0.000409, 0.000442, 0.000471, 0.000497, 0.000524, 0.000553, 0.000582, 0.000611, 0.000641, 0.000673, 0.00071, 0.000753, 0.000805, 0.000864, 0.000932, 0.001005, 0.001082, 0.00116, 0.001243, 0.001336, 0.001442, 0.001562, 0.001698, 0.001849, 0.002014, 0.002195, 0.002402, 0.002639, 0.002903, 0.003189, 0.003488, 0.003795, 0.004105, 0.004423, 0.004775, 0.005153, 0.005528, 0.005893, 0.006266, 0.006688, 0.007176, 0.007724, 0.008339, 0.009034, 0.009832, 0.01074, 0.011754, 0.012881, 0.014141, 0.015612, 0.017275, 0.019047, 0.020909, 0.022939, 0.025297, 0.028045, 0.031131, 0.034582, 0.038467, 0.043008, 0.048175, 0.053772, 0.05977, 0.066367, 0.073828, 0.082382, 0.092183, 0.103305, 0.115746, 0.129475, 0.144443, 0.16059, 0.177853, 0.196165, 0.214677, 0.233091, 0.251082, 0.268304, 0.284403, 0.301467, 0.319555, 0.338728, 0.359052, 0.380595, 0.403431, 0.427637, 0.453295, 0.480492, 0.509322, 0.539881, 0.572274, 0.606611, 0.643007, 0.681588, 0.722483, 0.761882, 0.799976, 0.839975, 0.881973]

var freqdata = []
var startingage
var rf
var population

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	randomize()
	$background.z_index = -1 #MUST DO THIS. moves background down a layer so the drawing stuff can be on top
	startingage=0
	rf = 1.0
	population = 100000
	$startingage.text = str(startingage)
	$rf.text = str(rf)
	$population.text = str(population)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func calc():
	#For returning one value
#	startingage=0
#	rf = 1.0
	#avg, median, mode, freqdata = calclifeexpectancy(rf, startingage)
	var leoutput = []
	$waiting.visible = true
	yield(get_tree().create_timer(0.1), "timeout") #in order to allow waiting icon to appear
	leoutput = calclifeexpectancy(rf, startingage)
	var avg = leoutput[0]
	var median = int(leoutput[1]) #int is to remove the half year added to age to match SSA
	var mode = leoutput[2]
	freqdata = leoutput[3]
	
	prints("rf", rf)
	prints("average" , avg)
	prints("median", median)
	prints("mode", mode)
	prints(freqdata)
	
	$average.text = str(stepify(avg, 0.01))
	$median.text = str(median)
	$mode.text = str(mode)
	$waiting.visible = false
	update()


#calculates life expectancy values given risk factor and starting age
func calclifeexpectancy(rf, startingage):
	var fracdead = []
	for i in range(len(fracdeadoriginal)):
		fracdead.append(fracdeadoriginal[i]*rf)
	
	#create a list of 120 ages to store frequency data
	var freqdata = []
	for i in range(120):
		freqdata.append(0)
	
	var agedead = []
	var age = 0.0
	for people in range (population): # a population of X
		#start a test for one person to find when they die
		for agei in range(startingage,120):#i = age up to age 120 only per death data set
			#see if they die
			var r = randf() #r is random from 0-1
			#print(r, float(fracdead[age]))
			if r<(fracdead[agei]):#fracdead(age) is fraction that die at age.
				age = agei+0.5 #added the 0.5 because it matches the SSA table and I guess they are assuming an average death occurs mid-year
				break
			
		#print("Died age ", age)
		agedead.append(age) #the whole list of when died
		#print(age)
		freqdata[age]+=1 #the frequency list
	
	freqdata = splitarray(freqdata, startingage)
	
	agedead.sort() 
	prints("maxage", agedead.max())   
	#print(freqdata) #to get frequency data table for histogram   
	
	var m = int(len(agedead)/2+0.5)
	var median = agedead[m]
	#var fm = maxinarray(freqdata)
	var fm = freqdata.max()
	var mode = freqdata.find(fm,0) + startingage
	var avg = sum(agedead)/len(agedead)
	var leoutput = []
	leoutput.append(avg)
	leoutput.append(median)
	leoutput.append(mode)
	leoutput.append(freqdata)
	return leoutput

#returns the part of the array starting with the val
func splitarray(array,val):
	var temp = []
	for i in range(len(array)):
		if i>=val:
			temp.append(array[i])
	return temp

#adds the contents of an array of numbers
func sum(array):
	pass
	var sumamount = 0.0
	for i in range(len(array)):
		pass
		sumamount += array[i]
	return sumamount

func _draw(): #use this to draw the graph
	if freqdata == []:
		return
	var h
	var x
	#var col = Color("81FFA5") #rgb
	var col
	var rect1
	var scalex
	var scaley
	var returnvalues = freqdata
	var minx = 0
	var maxx = 120
	var maxy = freqdata.max()

	var numbins = 120
	
	scalex = (maxx-minx)/750.0
	scaley = 600.0/float(maxy)
	#draw the bars
	#col = Color("54E3CD") #rgb
	col = Color("000000")
	for i in range(numbins-startingage):
		h=freqdata[i]*scaley
		#breakpoint
		x = 850 + ((startingage+i)/scalex) #i*50 +950
		rect1 = Rect2(Vector2(x, 710-h), Vector2(7, h))
		draw_rect(rect1, col)

#This lets Esc key exit the program
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()


func _on_infobutton_pressed():
	pass # Replace with function body.
	OS.shell_open("Life Expectancy Estimator.pdf")




func _on_startbutton_pressed():
	pass # Replace with function body.
	print("pressed")
	calc()


func _on_startingage_text_changed(new_text):
	pass # Replace with function body.
	startingage = int($startingage.text)
	


func _on_rf_text_changed(new_text):
	pass # Replace with function body.
	rf = float($rf.text)


func _on_population_text_changed(new_text):
	pass # Replace with function body.
	population = int($population.text)


func _on_malebutton_pressed():
	pass # Replace with function body.
	$selectionfemale.visible = false
	$selectionmale.visible = true
	fracdeadoriginal = [0.0063, 0.0004, 0.0003, 0.0002, 0.0002, 0.0002, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0002, 0.0003, 0.0004, 0.0005, 0.0006, 0.0007, 0.0009, 0.001, 0.0012, 0.0013, 0.0013, 0.0013, 0.0013, 0.0014, 0.0014, 0.0014, 0.0015, 0.0015, 0.0015, 0.0016, 0.0016, 0.0017, 0.0017, 0.0018, 0.0019, 0.0019, 0.002, 0.0021, 0.0023, 0.0024, 0.0026, 0.0028, 0.0031, 0.0034, 0.0037, 0.0041, 0.0045, 0.005, 0.0055, 0.006, 0.0066, 0.0072, 0.0078, 0.0085, 0.0092, 0.0099, 0.0106, 0.0114, 0.0122, 0.0131, 0.0139, 0.0148, 0.0158, 0.017, 0.0183, 0.0198, 0.0214, 0.0234, 0.0255, 0.0279, 0.0304, 0.0331, 0.0363, 0.0399, 0.0439, 0.0483, 0.0531, 0.0587, 0.0651, 0.0721, 0.0799, 0.0885, 0.0981, 0.1089, 0.1209, 0.1341, 0.1487, 0.1645, 0.1816, 0.1999, 0.2193, 0.2399, 0.2603, 0.2801, 0.299, 0.3166, 0.3324, 0.349, 0.3665, 0.3848, 0.404, 0.4242, 0.4455, 0.4677, 0.4911, 0.5157, 0.5415, 0.5685, 0.597, 0.6268, 0.6581, 0.691, 0.7256, 0.7619, 0.8, 0.84, 0.882]


func _on_femalebutton_pressed():
	pass # Replace with function body.
	$selectionfemale.visible = true
	$selectionmale.visible = false
	fracdeadoriginal = [0.005313, 0.000346, 0.000221, 0.000162, 0.000131, 0.000116, 0.000106, 0.000098, 0.000091, 0.000086, 0.000084, 0.000087, 0.0001, 0.000124, 0.000157, 0.000194, 0.000232, 0.000269, 0.000304, 0.000338, 0.000373, 0.000409, 0.000442, 0.000471, 0.000497, 0.000524, 0.000553, 0.000582, 0.000611, 0.000641, 0.000673, 0.00071, 0.000753, 0.000805, 0.000864, 0.000932, 0.001005, 0.001082, 0.00116, 0.001243, 0.001336, 0.001442, 0.001562, 0.001698, 0.001849, 0.002014, 0.002195, 0.002402, 0.002639, 0.002903, 0.003189, 0.003488, 0.003795, 0.004105, 0.004423, 0.004775, 0.005153, 0.005528, 0.005893, 0.006266, 0.006688, 0.007176, 0.007724, 0.008339, 0.009034, 0.009832, 0.01074, 0.011754, 0.012881, 0.014141, 0.015612, 0.017275, 0.019047, 0.020909, 0.022939, 0.025297, 0.028045, 0.031131, 0.034582, 0.038467, 0.043008, 0.048175, 0.053772, 0.05977, 0.066367, 0.073828, 0.082382, 0.092183, 0.103305, 0.115746, 0.129475, 0.144443, 0.16059, 0.177853, 0.196165, 0.214677, 0.233091, 0.251082, 0.268304, 0.284403, 0.301467, 0.319555, 0.338728, 0.359052, 0.380595, 0.403431, 0.427637, 0.453295, 0.480492, 0.509322, 0.539881, 0.572274, 0.606611, 0.643007, 0.681588, 0.722483, 0.761882, 0.799976, 0.839975, 0.881973]


func _on_resetbutton_pressed():
	pass # Replace with function body.
	startingage=0
	rf = 1.0
	population = 100000
	$startingage.text = str(startingage)
	$rf.text = str(rf)
	$population.text = str(population)
	$selectionfemale.visible = false
	$selectionmale.visible = true
	fracdeadoriginal = [0.0063, 0.0004, 0.0003, 0.0002, 0.0002, 0.0002, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0002, 0.0003, 0.0004, 0.0005, 0.0006, 0.0007, 0.0009, 0.001, 0.0012, 0.0013, 0.0013, 0.0013, 0.0013, 0.0014, 0.0014, 0.0014, 0.0015, 0.0015, 0.0015, 0.0016, 0.0016, 0.0017, 0.0017, 0.0018, 0.0019, 0.0019, 0.002, 0.0021, 0.0023, 0.0024, 0.0026, 0.0028, 0.0031, 0.0034, 0.0037, 0.0041, 0.0045, 0.005, 0.0055, 0.006, 0.0066, 0.0072, 0.0078, 0.0085, 0.0092, 0.0099, 0.0106, 0.0114, 0.0122, 0.0131, 0.0139, 0.0148, 0.0158, 0.017, 0.0183, 0.0198, 0.0214, 0.0234, 0.0255, 0.0279, 0.0304, 0.0331, 0.0363, 0.0399, 0.0439, 0.0483, 0.0531, 0.0587, 0.0651, 0.0721, 0.0799, 0.0885, 0.0981, 0.1089, 0.1209, 0.1341, 0.1487, 0.1645, 0.1816, 0.1999, 0.2193, 0.2399, 0.2603, 0.2801, 0.299, 0.3166, 0.3324, 0.349, 0.3665, 0.3848, 0.404, 0.4242, 0.4455, 0.4677, 0.4911, 0.5157, 0.5415, 0.5685, 0.597, 0.6268, 0.6581, 0.691, 0.7256, 0.7619, 0.8, 0.84, 0.882]
