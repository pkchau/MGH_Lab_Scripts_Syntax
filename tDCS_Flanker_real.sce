#NOTE: display size is 1024 x 768 on old exptl laptop, so this expt is set to 1024 x 768 to match.
#Point size of flankers stimuli for old expt = 56

#Header
response_matching = simple_matching;
#default_font = "Courier New"; #Font = Courier New in old expt. CANNOT do this b/c in old expt all text was bolded. Bolding text requires HTML tags so < > MUST be used as tags in order to format any text in this expt; incompatible w/ stimuli.
#default_formatted_text = true;5
active_buttons = 3;
#keys: 1 = c, 2 = m, 3 = spacebar
button_codes = 1,2,3;
stimulus_properties = subjectID,string, condition,string;
event_code_delimiter = ",";
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
	text { caption = "< <   < <"; description = "FLANKERS"; font_size = 70;};
   text { caption = "> >   > >"; description = "FLANKERS"; font_size = 70;};
} flankers_set;

array {
	text { caption = "< < < < <"; description = "CON"; font_size = 70;};
   text { caption = "> > > > >"; description = "CON"; font_size = 70;};
} con_target_set;


array {
	text { caption = "< < > < <"; description = "INC"; font_size = 70;};
	text { caption = "> > < > >"; description = "INC"; font_size = 70;};
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
				caption = "You may place your left index finger on the 'c' key, and your right index finger on the 'm' key.\n\nIf you see the CENTER arrow is facing to the LEFT, you will press the 'c' key.\n\nIf the CENTER arrow is facing to the RIGHT, you will press the 'm' key.\n\nPress the spacebar to continue."; 
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
				font_size = 22;
			};
			x = 0; y = 250;
			text { 
				caption = "> > > > >"; 
				font_size = 70; 
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
			font_size = 22;
		};
		x = 0; y = 250;
		text { 
			caption = "< < > < <"; 
			font_size = 70; 
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
			font_size = 22;
		};
		x = 0; y = 250;		
		text { 
			caption = "< < < < <"; 
			font_size = 70;
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
			font_size = 22;
		};
		x = 0; y = 250;
		text { 
			caption = "> > < > >"; 
			font_size = 70; 
		};
		x = 0; y = 100;
		text { 
			caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
			font_size = 18; 
		};
		x = 0; y = -100;
		};  
} example_4;

#Begin Real Flanker
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "We will now begin the real version of the task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
			font_size = 18; 
		};
		x = 0; y = 0;
		}; 
} begin_real;

#Get Ready - Real Task
trial {
	trial_duration = 2992; #Note: monitor's refresh rate is: 60Hz = 60 frames of data per second/1 per 16.7ms --> request 3000 - 16.7/2 = request 2992ms trial duration
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Get ready!\n\nThe task is about to start!"; 
			font_size = 24; 
		};
		x = 0; y = 0;
		}; 
} get_ready_real;

#Flanker task
trial {
	trial_duration = 92; # request 100 instead of 92
	stimulus_event {
		picture {
			text err; 		
			x = 0; y = 0;
		} flankersonly_pic;
	} flankersonly_event;
} flankersonly_trial;

#Flanker task: target
trial {
	trial_duration = 600; #600ms = response window for subject so keep this the same
	trial_type = fixed;
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
      duration = 1392; #Request 1392 instead of 1400
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
      duration = 9999; #Durations will vary based on randomized array element (see below)
   } ITI_event;
} ITI;

#Feedback: Blank
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } pic_blank;
      time = 0;
      duration = 292; #Request 292 instead of 300
   } feedback_blank_event;
} feedback_blank;

#Feedback: TOO SLOW
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
         text {
				caption = "TOO SLOW!"; font_size = 48;
			};
         x = 0; y = 0;
      } pic_tooslow;
      time = 0;
      duration = 292; #Request 292 instead of 300
   } feedback_tooslow_event;
} feedback_tooslow;

#End of block
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
	picture {
	text { 
		caption = "You have completed 1 block of the task.\n\nPlease take a moment to relax before starting the next block.\n\nWhen you are ready to continue, press the SPACEBAR."; 
		font_size = 24; 
	};
	x = 0; y = 0;
	} end_block_pic;	
} end_block; 

#Conclusion
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
	picture {
	text { 
		caption = "Great job!\n\nYou have completed the real task.\n\nPlease let the experimenter know."; 
		font_size = 24; 
	};
	x = 0; y = 0;
	} conclusion_pic;	
} conclusion; 

begin_pcl;

#Set array of varying ITIs (200, 300, 400)
#Request 192, 292, 392 instead.
array<int> ITI_set[3] = {192, 292, 392};

#set # of stimuli for 1 block here.
#Note that we will have a stimuli ratio of 2 Congruent: 1 Incongruent to "build a tendency towards congruent responses" (based on Dr. Avram Holmes' programmed E-prime Flanker)
int num_inc_stimuli = 24;
int num_con_stimuli = num_inc_stimuli*2 - 2; 
int num_all_stimuli = 70;

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

#Add 1 to max counter b/c dividing by odd #
loop int i = 1 until i > num_con_stimuli/ITI_set.count() + 1
begin;
	ITIs.append(ITI_set);
	i = i + 1;
end;

#Create the randomizer array here
array<int> randomizer[0];
loop int i = 1 until i > num_all_stimuli
begin;
	randomizer.add(i);
	i = i + 1;
end;

#Randomize the order of the stimuli while maintaining the flanker x flanker w/ target pairs
randomizer.shuffle();

#Present intro slides
intro_1.present();
intro_2.present();
example_1.present();
example_2.present();
example_3.present();
example_4.present();
begin_real.present();
get_ready_real.present();

#SET # blocks here
int num_blocks = 2;
#Present Flanker trials
loop int b = 1 until b > num_blocks
	begin
	loop int i = 1 until i > num_all_stimuli
	begin
		text target = flankers_target[randomizer[i]];
		flankersonly_pic.set_part(1, flankers_only[randomizer[i]]);
		target_pic.set_part(1, target);
		#Set the correct response depending on the stimulus displayed
		if (target.caption() == "< < < < <" || target.caption() == "> > < > >") then
			target_event.set_target_button(1);
		elseif (target.caption() == "> > > > >" || target.caption() == "> > < > >") then
			target_event.set_target_button(2);
		end;
		flankersonly_trial.present();
		flankersonly_event.set_event_code(flankers_only[randomizer[i]].description());
		target_trial.present();
		target_event.set_event_code(logfile.subject() + "," + target.description());
		#If response too slow, display too slow
		stimulus_data last = stimulus_manager.last_stimulus_data();
		if last.reaction_time() > 600 || last.reaction_time() == 0 then
			ISI.present();
			feedback_tooslow.present();
		else
			ISI.present();
			feedback_blank.present();
		end;
		ITI_event.set_duration(ITIs[randomizer[i]]);
		ITI.present();
		i = i + 1;
	end;	
	#If there are more blocks to present, then present end of block message and randomize the stimuli again
	if b < num_blocks then
		end_block.present();
		randomizer.shuffle();
		get_ready_real.present();
	end;
	b = b + 1
end;

conclusion.present();