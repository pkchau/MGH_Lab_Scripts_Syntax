#NOTE: display size is 1024 x 768 on old exptl laptop, so this expt is set to 1024 x 768 to match.
#Point size of flankers stimuli for old expt = 56 but can't do bolded New Courier font to match so will do 70.
#Note: monitor's refresh rate is: 60Hz = 60 frames of data per second/1 per 16.7ms --> request desired duration - 16.7/2 = request desired duration - 8 for all durations

#Header
response_matching = simple_matching;

#Font = Courier New in old expt. CANNOT do this b/c in old expt all text was bolded. Bolding text requires HTML tags so < > MUST be used as tags in order to format any text in this expt; incompatible w/ stimuli.
default_font = "Arial"; 

#Keys: 1 = c, 2 = m, 3 = spacebar
#button_codes = 1,2,3;
active_buttons = 3;

#Log file setup
stimulus_properties = subjectID,string, flankers,string, stim_arrows,string, condition,string, targ_buttons,string; 
#End Header
	
#Begin SDL
begin;

#Display ERROR as default if proper stimuli are not retrieved
array {
	text { caption = "ERROR"; description = "ERROR"; font_size = 100;} err;
} error;

#Create 3 separate arrays: 1 with flankers only and 1 with flankers w/ targets per condition (con/inc).
#NOTE: Make sure the order of each row in array 1 corresponds to array 2s and 3 i.e. that the flankers are the same in both.
#There are in total 4 different kinds of target w/ flankers stimuli. 
array {
	text { caption = "< <   < <"; description = "FLANKERS"; font_size = 100;} fl;
   text { caption = "> >   > >"; description = "FLANKERS"; font_size = 100;};
} flankers_set;

array {
	text { caption = "< < < < <"; description = "CON"; font_size = 100;};
   text { caption = "> > > > >"; description = "CON"; font_size = 100;};
} con_target_set;


array {
	text { caption = "< < > < <"; description = "INC"; font_size = 100;};
	text { caption = "> > < > >"; description = "INC"; font_size = 100;};
} inc_target_set;

#Intro 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 150;
			text { 
				caption = "In this task, you will see 5 arrows presented.\n\nWe want you to focus on the direction the CENTER arrow is facing.\n\nPress the spacebar to proceed."; 
				font_size = 18; 
			};
			x = 0; y = 0;
		}; 
} intro_1;

#Intro 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 150;
			text { 
				caption = "You may place your left index finger on the 'c' key, and your right index finger on the 'm' key.\n\nIf the CENTER arrow is facing to the LEFT, press the 'c' key.\n\nIf the CENTER arrow is facing to the RIGHT, press the 'm' key.\n\nPress the spacebar to see some examples."; 
				font_size = 18; 
			};
			x = 0; y = -25;
		}; 
} intro_2;

#Example 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 1"; 
				font_size = 22;
			};
			x = 0; y = 75;
			text { 
				caption = "> > > > >"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
		};  
} example_1;

#Example 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 2"; 
				font_size = 22;
			};
			x = 0; y = 75;
			text { 
				caption = "< < > < <"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
			}; 
} example_2;

#Example 3
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 3"; 
				font_size = 22;
			};
			x = 0; y = 75;		
			text { 
				caption = "< < < < <"; 
				font_size = 70;
			};
			x = 0; y = -25;
			text { 
				caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
		};  
} example_3;

#Example 4
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Practice Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 4"; 
				font_size = 22;
			};
			x = 0; y = 75;
			text { 
				caption = "> > < > >"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
		};  
} example_4;

#Begin Practice
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "We will now begin the practice task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
			font_size = 18; 
		};
		x = 0; y = 0;
		}; 
} begin_practice;

#Get Ready - practice
trial {
	trial_duration = 2992; 
	trial_type = fixed;
		picture {
		text { 
			caption = "Get ready!\n\nThe practice is about to start!"; 
			font_size = 24; 
		};
		x = 0; y = 0;
		}; 
} get_ready_practice;

#Flankers only
trial {
	trial_duration = 92; 
	trial_type = fixed;
	stimulus_event {
		picture {
			text err; 		
			x = 0; y = 0;
		} flankersonly_pic;
	} flankersonly_event;
} flankersonly;

#Flankers w/ target
trial {
	trial_duration = stimuli_length; 
	trial_type = fixed;
	stimulus_event {
		picture {
			text fl;
			x = 0; y = 0;
		} target_pic;
		duration = 42; 
	} target_event;
	stimulus_event {
		picture {
		} ISI_pic;
		time = 42; #Will set to vary based on duration of the stimulus prior to it
		duration = 692; 
	} ISI_event;	
} target;

#ITI
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } ITI_pic;
      time = 0;
      duration = 9999; 	#Duration will be set to vary based on array element (see below)
   } ITI_event;
} ITI;

#Conclusion
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
	picture {
		text { 
			caption = "Great job! You have completed the practice task.\n\nPlease let the experimenter know."; 
			font_size = 18; 
		};
		x = 0; y = 0;
	} conclusion_pic;	
} conclusion; 

begin_pcl;

#SET array of varying ITIs (200, 300, 400). Request 192, 292, 392 instead.
array<int> ITI_set[3] = {192, 292, 392};

#SET # trials per level here
int num_trials = 15;
#SET # difficulty levels (# different durations) here
int num_levels = 5;
int num_all_trials = num_trials*num_levels;
#SET proportion/# of inc and con #s here
int num_inc = num_trials/2 + 1;
int num_con = num_trials/2 + 1;
int num_all_inc = num_all_trials/2 + 1; 
int num_all_con = num_all_trials/2 + 1;

#Make arrays of all flankers stimuli in task
array<text> flankers_only[0];
loop int i = 1 until i > num_all_trials/flankers_set.count() + 1 #Note: may need to add 1 if #s don't divide out evenly
begin
	loop int x = 1 until x > flankers_set.count()
	begin
		if (flankers_only.count() == num_all_trials/2 + 1) then
			break;
		end;
		flankers_only.add(flankers_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

#Make array with all flankers w/ target stimuli: 1st add con stimuli
array<text> flankers_target[0];
loop int i = 1 until i > num_all_con/con_target_set.count() #Note: may need to add 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > con_target_set.count()
	begin
		if (flankers_target.count() == num_all_con) then
			break;
		end;
		flankers_target.add(con_target_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;
#Add inc stimuli
loop int i = 1 until i > num_all_inc/inc_target_set.count() #Note: may need to add 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > inc_target_set.count()
	begin
		if (flankers_target.count() == num_all_trials) then
			break;
		end;
	flankers_target.add(inc_target_set[x]);
	x = x + 1;
	end;
	i = i + 1;
end;

array<int> ITIs[0];
loop int i = 1 until i > num_all_trials/ITI_set.count()	+ 1 #Note: may need to add 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > ITI_set.count()
	begin
		if (ITI_set.count() == num_all_trials) then
			break;
		end;
		ITIs.add(ITI_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

#Create a randomizer array to randomize the order of the stimuli while maintaining the flanker x flanker w/ target pairs
array<int> randomizer[0];
loop int i = 1 until i > num_all_trials
begin;
	randomizer.add(i);
	i = i + 1;
end;
randomizer.shuffle();

#Set array of varying Stim durations  
array<int> flankerdur_set[5] = {136,114,92,70,48}; #Set to 400(original)/1300(original) x durations
array<int> targetdur_set[5] = {62,52,42,32,22};

#Make the randomized stim durations array
array<int> flankerdur_array[0];
loop int i = 1 until i > num_all_trials/flankerdur_set.count()
begin
	loop int j = 1 until j > flankerdur_set.count()
	begin
		if (flankerdur_array.count() == num_all_trials) then
			break;
		end;
		flankerdur_array.add(flankerdur_set[j]);
		j = j + 1;
	end;
	i = i + 1;
end;

array<int> targetdur_array[0];
loop int i = 1 until i > num_all_trials
begin
	loop int j = 1 until j > targetdur_set.count()
	begin
		if (targetdur_array.count() == num_all_trials) then
			break;
		end;
		targetdur_array.add(targetdur_set[j]);
		j = j + 1;
	end;
	i = i + 1;
end;

#Present all the Intro Slides
intro_1.present();
intro_2.present();
example_1.present();
example_2.present();
example_3.present();
example_4.present();
begin_practice.present();
get_ready_practice.present();

array<int> targ_buttons[0]; #Array to contain target buttons/correct responses

#Show Flanker Trials
loop int i = 1 until i > num_all_trials
begin
	text t = flankers_target[randomizer[i]];
	flankersonly_pic.set_part(1, flankers_only[randomizer[i]]);  
	target_pic.set_part(1, t);  
	flankersonly.set_duration(flankerdur_array[randomizer[i]]);
	target.set_duration(targetdur_array[randomizer[i]]);
	#Set the correct response depending on the stimulus displayed
	if (t.caption() == "< < < < <" || t.caption() == "> > < > >") then
		target_event.set_target_button(1);
	elseif (t.caption() == "> > > > >" || t.caption() == "< < > < <") then
		target_event.set_target_button(2);
	end;
	target_event.get_target_buttons(targ_buttons);
	target_event.set_event_code(logfile.subject() + "," + flankers_only[randomizer[i]].caption() + "," + t.caption() + "," + t.description()+ "," + string(targ_buttons[1]));
	flankersonly.present();
	target.present();
	stimulus_data last = stimulus_manager.last_stimulus_data();
	ITI_event.set_duration(ITIs[randomizer[i]]);
	ITI.present();
	i = i + 1;
end;

conclusion.present();