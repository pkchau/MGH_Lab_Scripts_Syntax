#NOTE: display size is 1024 x 768 on old exptl laptop, so this expt is set to 1024 x 768 to match.

#Header
response_matching = simple_matching;
active_buttons = 3;
#Keys: 1 = c, 2 = m, 3 = spacebar
button_codes = 1,2,3;
#Name of stimulus_property, type(string/number)
stimulus_properties = emotion,string,condition,string;
event_code_delimiter = ",";
#End Header
	
#Begin SDL
begin;

#Display ERROR as default if proper stimuli are not retrieved
array {
	text { caption = "ERROR"; description = "ERROR"; font_size = 300;} err;
} error;

#Create 3 separate arrays: 1 with flankers only and 1 with flankers w/ targets per condition (con/inc).
#NOTE: Make sure the order of each row in array 1 corresponds to array 2s and 3 i.e. that the flankers are the same in both.
#There are in total 4 different kinds of target w/ flankers stimuli. 
array {
	text { caption = "< <   < <"; description = "FLANKERS"; font_size = 200;};
   text { caption = "> >   > >"; description = "FLANKERS"; font_size = 200;};
} flankers_set;

array {
	text { caption = "< < < < <"; description = "CON"; font_size = 200;};
   text { caption = "> > > > >"; description = "CON"; font_size = 200;};
} con_target_set;


array {
	text { caption = "< < > < <"; description = "INC"; font_size = 200;};
	text { caption = "> > < > >"; description = "INC"; font_size = 200;};
} inc_target_set;

#Intro 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
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
				caption = "You may place your left index finger on the 'c' key, and your right index finger on the 'm' key.\n\nIf the CENTER arrow is facing to the LEFT, press the 'c' key.\n\nIf the CENTER arrow is facing to the RIGHT, press the 'm' key.\n\nPress the spacebar to see some examples."; 
				font_size = 18; 
			};
			x = 0; y = 0;
		}; 
} intro_2;

#Example 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
			text {
				caption = "Example 1"; 
				font_size = 18;
			};
			x = 0; y = 250;
			text { 
				caption = "> > > > >"; 
				font_size = 48; 
			};
			x = 0; y = 100;
			text { 
				caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -100;
		};  
} example_1;

#Example 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
		text {
			caption = "Example 2"; 
			font_size = 18;
		};
		x = 0; y = 250;
		text { 
			caption = "< < > < <"; 
			font_size = 48; 
		};
		x = 0; y = 100;
		text { 
			caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
			font_size = 18; 
		};
		x = 0; y = -100;
		}; 
} example_2;

#Example 3
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Example 3"; 
				font_size = 18;
			};
			x = 0; y = 250;		
			text { 
				caption = "< < < < <"; 
				font_size = 48;
			};
			x = 0; y = 100;
			text { 
				caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -100;
		};  
} example_3;

#Example 4
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Example 4"; 
				font_size = 18;
			};
			x = 0; y = 250;
			text { 
				caption = "> > < > >"; 
				font_size = 48; 
			};
			x = 0; y = 100;
			text { 
				caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -100;
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
	trial_duration = 2992; #Note: monitor's refresh rate is: 60Hz = 60 frames of data per second/1 per 16.7ms --> request 3000 - 16.7/2 = request 2992ms trial duration
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Get ready!\n\nThe practice is about to start!"; 
			font_size = 18; 
		};
		x = 0; y = 0;
		}; 
} get_ready_practice;

#Flanker practice
trial {
	trial_duration = 92; #Request 100 - 8 = 92ms duration
	stimulus_event {
		picture {
			text err; 		
			x = 0; y = 0;
		} flankersonly_pic;
	} flankersonly_event;
} flankersonly_trial;

#Flanker practice
trial {
	trial_duration = 600; #600ms = response window for subject, so keep that the same
	trial_type = first_response;
	clear_active_stimuli = true;
	stimulus_event {
		picture {
			text err;
			x = 0; y = 0;
		} target_pic;
	duration = 42; #Request 42 instead of 50ms
	response_active = true;
	} target_event;
} target_trial;
		
#ISI
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } pic_ISI;
      time = 0;
      duration = 1392; #Request 1400 - 8 = 1392
   } ISI_event;
} ISI;

#ITI
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } pic_ITI;
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

#SET # of stimuli/# trials for Practice task.
int num_inc_stimuli = 16;
int num_con_stimuli = num_inc_stimuli; 
int num_all_stimuli = num_inc_stimuli + num_con_stimuli;

#Make arrays of ALL stimuli in task
array<text> flankers_only[0];
loop int i = 1 until i > num_all_stimuli/flankers_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin
	loop int x = 1 until x > flankers_set.count()
	begin
		if (flankers_only.count() == num_all_stimuli) then
			break;
		end;
		flankers_only.add(flankers_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

array<text> flankers_target[0];
loop int i = 1 until i > num_con_stimuli/con_target_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > con_target_set.count()
	begin
		if (flankers_target.count() == num_con_stimuli) then
			break;
		end;
		flankers_target.add(con_target_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

loop int i = 1 until i > num_inc_stimuli/inc_target_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > inc_target_set.count()
	begin
		if (flankers_target.count() == num_all_stimuli) then
			break;
		end;
	flankers_target.add(inc_target_set[x]);
	x = x + 1;
	end;
	i = i + 1;
end;

array<int> ITIs[0];
loop int i = 1 until i > num_all_stimuli/ITI_set.count()	+ 1 #Add 1 b/c 32/3 doesn't divide evenly and will round down
begin;
	loop int x = 1 until x > ITI_set.count()
	begin
		if (ITI_set.count() == num_all_stimuli) then
			break;
		end;
		ITIs.add(ITI_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

#Create a randomizer array 
array<int> randomizer[0];
loop int i = 1 until i > num_all_stimuli
begin;
	randomizer.add(i);
	i = i + 1;
end;
#Randomize the order of the stimuli while maintaining the flanker x flanker w/ target pairs
randomizer.shuffle();

#Present all the intro slides
intro_1.present();
intro_2.present();
example_1.present();
example_2.present();
example_3.present();
example_4.present();
begin_practice.present();
get_ready_practice.present();

#Show Flanker Trials
loop int i = 1 until i > num_all_stimuli
begin
	text target = flankers_target[randomizer[i]];
	flankersonly_pic.set_part(1, flankers_only[randomizer[i]]); #Set the randomized Flankers only stimulus
	target_pic.set_part(1, target); #Set the randomized Flankers w/ target stimulus
	#Set the correct response depending on the stimulus displayed
	if (target.caption() == "< < < < <" || target.caption() == "> > < > >") then
		target_event.set_target_button(1);
	elseif (target.caption() == "> > > > >" || target.caption() == "> > < > >") then
		target_event.set_target_button(2);
	end;
	flankersonly_trial.present();
	flankersonly_event.set_event_code(flankers_only[randomizer[i]].description());
	target_trial.present();
	target_event.set_event_code(target.description());
	ISI.present();
	ITI_event.set_duration(ITIs[randomizer[i]]);
	ITI.present();
	i = i + 1;
end;

conclusion.present();