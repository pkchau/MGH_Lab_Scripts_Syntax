#NOTE: display size is 640 x 480 on old exptl laptop, so this expt is set to 640 x 480 to match.

#Header
response_matching = simple_matching;
active_buttons = 7;
#2,5 = number 1; 3,6 = number 2; 4,7 = number 7
button_codes = 1,2,3,4,5,6,7;
stimulus_properties = condition,string, emotion,string,;
event_code_delimiter = ",";
#End Header	

#Begin SDL
begin;

#Create a 1D array with all the pictures and with the corresponding valence categories in the picure description
#We have 72 unique images that are shown 2x (i.e. the same image is repeated) in the expt.
#1-72 in the array will be all the unique images listed 1x. 
#73-144 will be the images repeated again in the same order.
#We want to separate the entire list of repeated images in 'halves' b/c we want the the first display of the unique image to be Int/NonInt and the 2nd display to be of the other condition.

array {
	bitmap { filename = "3053.bmp"; description = "Neg"; } p;
	bitmap { filename = "1120.bmp"; description = "Neg"; };
	bitmap { filename = "3230.bmp"; description = "Neg"; };
	bitmap { filename = "3266.bmp"; description = "Neg"; };
	bitmap { filename = "3071.bmp"; description = "Neg"; };
	bitmap { filename = "9253.bmp"; description = "Neg"; };
	bitmap { filename = "6550.bmp"; description = "Neg"; };
	bitmap { filename = "3030.bmp"; description = "Neg"; };
	bitmap { filename = "9440.bmp"; description = "Neg"; };
	bitmap { filename = "3180.bmp"; description = "Neg"; };
	bitmap { filename = "2800.bmp"; description = "Neg"; };
	bitmap { filename = "9571.bmp"; description = "Neg"; };
	bitmap { filename = "2120.bmp"; description = "Neg"; };
	bitmap { filename = "6260.bmp"; description = "Neg"; };
	bitmap { filename = "9000.bmp"; description = "Neg"; };
	bitmap { filename = "3301.bmp"; description = "Neg"; };
	bitmap { filename = "3350.bmp"; description = "Neg"; };
	bitmap { filename = "9600.bmp"; description = "Neg"; };
	bitmap { filename = "6370.bmp"; description = "Neg"; };
	bitmap { filename = "3160.bmp"; description = "Neg"; };
	bitmap { filename = "6570.bmp"; description = "Neg"; };
	bitmap { filename = "2750.bmp"; description = "Neg"; };
	bitmap { filename = "9570.bmp"; description = "Neg"; };
	bitmap { filename = "9220.bmp"; description = "Neg"; };
	bitmap { filename = "2620.bmp"; description = "Neu"; };
	bitmap { filename = "7004.bmp"; description = "Neu"; };
	bitmap { filename = "7025.bmp"; description = "Neu"; };
	bitmap { filename = "7140.bmp"; description = "Neu"; };
	bitmap { filename = "2890.bmp"; description = "Neu"; };
	bitmap { filename = "7002.bmp"; description = "Neu"; };
	bitmap { filename = "1121.bmp"; description = "Neu"; };
	bitmap { filename = "2383.bmp"; description = "Neu"; };
	bitmap { filename = "2520.bmp"; description = "Neu"; };
	bitmap { filename = "2480.bmp"; description = "Neu"; };
	bitmap { filename = "6000.bmp"; description = "Neu"; };
	bitmap { filename = "2515.bmp"; description = "Neu"; };
	bitmap { filename = "2221.bmp"; description = "Neu"; };
	bitmap { filename = "2440.bmp"; description = "Neu"; };
	bitmap { filename = "2516.bmp"; description = "Neu"; };
	bitmap { filename = "7100.bmp"; description = "Neu"; };
	bitmap { filename = "2880.bmp"; description = "Neu"; };
	bitmap { filename = "2870.bmp"; description = "Neu"; };
	bitmap { filename = "2850.bmp"; description = "Neu"; };
	bitmap { filename = "1670.bmp"; description = "Neu"; };
	bitmap { filename = "2600.bmp"; description = "Neu"; };
	bitmap { filename = "2570.bmp"; description = "Neu"; };
	bitmap { filename = "7150.bmp"; description = "Neu"; };
	bitmap { filename = "2210.bmp"; description = "Neu"; };
	bitmap { filename = "7501.bmp"; description = "Pos"; };
	bitmap { filename = "8502.bmp"; description = "Pos"; };
	bitmap { filename = "5470.bmp"; description = "Pos"; };
	bitmap { filename = "2303.bmp"; description = "Pos"; };
	bitmap { filename = "4608.bmp"; description = "Pos"; };
	bitmap { filename = "5621.bmp"; description = "Pos"; };
	bitmap { filename = "5001.bmp"; description = "Pos"; };
	bitmap { filename = "5831.bmp"; description = "Pos"; };
	bitmap { filename = "8500.bmp"; description = "Pos"; };
	bitmap { filename = "2550.bmp"; description = "Pos"; };
	bitmap { filename = "8185.bmp"; description = "Pos"; };
	bitmap { filename = "5480.bmp"; description = "Pos"; };
	bitmap { filename = "5622.bmp"; description = "Pos"; };
	bitmap { filename = "8200.bmp"; description = "Pos"; };
	bitmap { filename = "1440.bmp"; description = "Pos"; };
	bitmap { filename = "2080.bmp"; description = "Pos"; };
	bitmap { filename = "5626.bmp"; description = "Pos"; };
	bitmap { filename = "7502.bmp"; description = "Pos"; };
	bitmap { filename = "2352.bmp"; description = "Pos"; };
	bitmap { filename = "1811.bmp"; description = "Pos"; };
	bitmap { filename = "5629.bmp"; description = "Pos"; };
	bitmap { filename = "4689.bmp"; description = "Pos"; };
	bitmap { filename = "8496.bmp"; description = "Pos"; };
	bitmap { filename = "2341.bmp"; description = "Pos"; };
} pics_set;

#Now we create a 1D array of the 3 digit Numbers stimuli w/ Interference
#This is b/c we want the 3-digit #s to be randomly matched to each picture.
#We're separating the Int and NonInt Stimuli to more easily match them up with the first presented set of pictures and then the repeated pictures.
array {
	text { caption = "212"; font_size = 36; description = "INT"; };
	text { caption = "332"; font_size = 36; description = "INT"; };
	text { caption = "311"; font_size = 36; description = "INT"; };
	text { caption = "112"; font_size = 36; description = "INT"; };
	text { caption = "232"; font_size = 36; description = "INT"; };
	text { caption = "313"; font_size = 36; description = "INT"; };
	text { caption = "211"; font_size = 36; description = "INT"; };
	text { caption = "322"; font_size = 36; description = "INT"; };
	text { caption = "221"; font_size = 36; description = "INT"; };
	text { caption = "131"; font_size = 36; description = "INT"; };
	text { caption = "331"; font_size = 36; description = "INT"; };
	text { caption = "233"; font_size = 36; description = "INT"; };
} int_num_set;

#Create 1D array of 3 digit Numbers w/o Interference (i.e. noninterference)
array {
	text { caption = "020"; font_size = 36; description = "NON"; };
	text { caption = "003"; font_size = 36; description = "NON"; };
	text { caption = "100"; font_size = 36; description = "NON"; };
} nonint_num_set;

#Intro 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
		text { 
			caption = "In this task, you will see 3 digit numbers in the middle of different pictures.\n\nSome of these pictures may be upsetting to you.\n\nIf they are too upsetting at any point, let the experimenter know to end the task.\n\nPress the spacebar to proceed."; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} intro_1;

#Intro 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text { 
				caption = "You may place your pointer, middle and ring fingers on the 1, 2 and 3 keys.\n\nYou may use either the numeric keypad on your right OR\n\nYou may use the numeric keys above the QWERTY letters on your left.\n\nPress the spacebar to continue."; 
				font_size = 14; 
			};
		x = 0; y = 0;
		}; 
} intro_2;

#Intro 3
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text { 
				caption = "Your task is to identify the number that is different.\n\nFor example, if you see the number '100', press the '1' key.\n\nIf you see the number '232', press the '3' key.\n\nWe are now going to practice the task.\n\nPress the spacebar to continue."; 
				font_size = 14; 
			};
		x = 0; y = 0;
		}; 
} intro_3;

#Begin practice
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
		text { 
			caption = "We will now practice the task.\n\nTry to be as QUICK and ACCURATE as possible.\n\nPress the spacebar when you are ready to start!"; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} begin_practice;

#Get ready - practice
trial {
	trial_duration = 2992;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
		text { 
			caption = "Get ready!\n\nThe practice is about to start!"; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} get_ready_practice;

#IAPS picture only 
trial {
	trial_duration = 392; #400 - 8 = request 392ms due to 60Hz refresh rate
	trial_type = fixed;
	clear_active_stimuli = true;
	stimulus_event {
		picture {
			bitmap p;
			x = 0; y = 0;	
		} iaps_pic_only;
	} iaps_pre_event;
} iaps_pre_trial;

#MSIT IAPS task
trial {
	trial_duration = 1292; #Request 1292 instead of 1300ms
	trial_type = fixed;
	clear_active_stimuli = true;
	stimulus_event {
		picture {
			bitmap p;
			x = 0; y = 0;	
		} iaps_pic;
	} msit_iaps_event;
} msit_iaps_trial;

#Conclusion
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
		text { 
			caption = "Great job! You have completed the practice task.\n\nPlease let the experimenter know."; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} conclusion;
		
begin_pcl;

#SET number of trials here
int num_trials = 48;

#Create int and nonint number arrays that repeat the sets of int and nonint #s until they match the # of trials.
#Have 23 Int #s: Int num array has 12 in set > each Int # should be displayed 1-2 times
array<text> int_num_array[0];
loop int i = 1 until i > num_trials/2/int_num_set.count() + 1
begin
	int_num_array.append(int_num_set);
	i = i + 1;
end;
#Have 22 NonInt Stimuli: NonInt set has 3 in set > each NonInt # should be displayed 7-8 times 
array<text> nonint_num_array[0];
loop int i = 1 until i > num_trials/2/nonint_num_set.count() + 1
begin
	nonint_num_array.append(nonint_num_set);
	i = i + 1;
end;

#Now that we have our 2 arrays, we randomize the order of the IntNumbers and NonIntNumbers arrays
int_num_array.shuffle();
nonint_num_array.shuffle();

#We now combine the 2 arrays into 1 by adding the non_int_stimuli_array array to the end of the int_stimuli_array. 
#We kept the arrays separate so each pic is displayed 1x with the int # and 1x with the nonint #. 
array<text>combined_num_array[1];
combined_num_array.assign(int_num_array);
combined_num_array.append(nonint_num_array);

#Randomly choose picture stimuli to be used keeping a 1:1:1 ratio of Pos:Neg:Neu 
array<int>randomize_pics_array[0];
loop int i = 1 until i > 24
begin
	randomize_pics_array.add(i);
	i = i + 1;
end;
randomize_pics_array.shuffle();

#Make pictures array from pics set array
int num_emo = 3;
int num_emo_divider = pics_set.count()/num_emo;
array<bitmap> pics_array[0];
loop int i = 0 until i > num_emo - 1
	begin
	loop int x = 1 until x > num_trials/3
	begin
		pics_array.add(pics_set[randomize_pics_array[x] + i*num_emo_divider]);
		x = x + 1;
	end;
	i = i + 1;
end;
#We now create a randomizer array containing #s 1-48 (1 up to # of total stimuli) to randomize the stimuli while keeping everything counterbalanced and in the correct corresponding order across the separate arrays
array<int> randomizer_array[0];
loop int i = 1 until i > num_trials
begin
	randomizer_array.add(i);
	i = i + 1;
end; 
randomizer_array.shuffle();


#Begin the experiment
intro_1.present();
intro_2.present();
intro_3.present();
begin_practice.present();
get_ready_practice.present();

#Show MSIT trials 
loop int x = 1 until x > num_trials
begin
	text num = combined_num_array[randomizer_array[x]];
	iaps_pic.set_part(1, pics_array[randomizer_array[x]]);
	iaps_pic_only.set_part(1, pics_array[randomizer_array[x]]);
	iaps_pic.add_part(num,0,0);
	#Set the correct response depending on the stimulus displayed
	string c = num.caption();
	if (c == "212" || c == "313" || c == "221" || c == "100" || c == "331") then
		msit_iaps_event.set_target_button({2,5});
	elseif (c == "332" || c == "112" || c == "211" || c == "233" || c == "020") then
		msit_iaps_event.set_target_button({3,6});
	elseif (c == "311" || c == "232" || c == "322" || c == "131" || c == "003" ) then
		msit_iaps_event.set_target_button({4,7});
	end;
	iaps_pre_trial.present();
	msit_iaps_event.set_event_code(num.description() + "," + pics_array[randomizer_array[x]].description());
	msit_iaps_trial.present();
	x = x + 1;
end;

conclusion.present();
