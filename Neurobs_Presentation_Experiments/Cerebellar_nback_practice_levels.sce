#NOTE: display size is 640 x 480 on old exptl laptop, so this expt is set to 640 x 480 to match.
#Stim font size = 36 in old expt

#Header
response_matching = simple_matching;
default_font = "Arial"; #Closest Font to old expt font which is Courier New bolded + keep consistent w/ Flanker
default_font_size = 36;  
active_buttons = 5;
button_codes = 1,2,3,4,5;
stimulus_properties = subjectID,string, nback,string, letter,string, is_target,string;
event_code_delimiter = ",";
#End Header

#Begin SDL
begin;

#Set of letters used in expt
array {
   text { caption = "H"; description = "H"; } letters;
   text { caption = "D"; description = "D"; };
   text { caption = "C"; description = "C"; };
   text { caption = "G"; description = "G"; };
   text { caption = "M"; description = "M"; };
   text { caption = "W"; description = "W"; };
   text { caption = "T"; description = "T"; };
   text { caption = "N"; description = "N"; };
   text { caption = "R"; description = "R"; };
   text { caption = "V"; description = "V"; };
   text { caption = "P"; description = "P"; };
   text { caption = "K"; description = "K"; };
   text { caption = "J"; description = "J"; };
   text { caption = "L"; description = "L"; };
   text { caption = "Q"; description = "Q"; };
   text { caption = "Z"; description = "Z"; };
   text { caption = "S"; description = "S"; };
   text { caption = "B"; description = "B"; };	
} letters_set;

#Intro 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Practice nback"; 
				font_size = 18;
			};
			x = 0; y = 120;
			text { 
				caption = "In this task, random letters appear one at a time in the center of the screen.\n\nThere will be 2 different kinds of tasks: the 1-back and the 2-back.\n\nPress the spacebar to proceed."; 
				font_size = 14; 
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
				caption = "Practice nback"; 
				font_size = 18;
			};
			x = 0; y = 120;
			text { 
				caption = "For BOTH the 1-back and 2-back tasks, you use the '1' key on the keyboard.\n\nYou may use the '1' key on the numberpad OR\n\nYou may use the '1' key above the QWERTY letters.\n\nPlease choose whichever would be preferable for you.\n\nPress the spacebar to proceed."; 
				font_size = 14; 
			};
			x = 0; y = -25;
		}; 
} intro_2;

#Begin 1back
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Practice nback"; 
				font_size = 18;
			};
			x = 0; y = 120;
			text { 
				caption = "'1-back: Practice'\n\nPress '1' if the letter you see is the same as the one before it.\n\nWe will now practice the 1-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
				font_size = 14; 
			};
			x = 0; y = -25;
		}; 
} begin_1back;

#Begin 2 back
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Practice nback"; 
				font_size = 18;
			};
			x = 0; y = 120;
			text { 
				caption = "'2-back: Practice'\n\nPress '1' if the letter you see is the same as TWO letters before it.\n\nWe will now practice the 2-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
				font_size = 14; 
			};
			x = 0; y = -25;
		}; 
} begin_2back;

#Get ready - practice
trial {
	trial_duration = 2992;
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

#1-back/2-back task
trial {
   trial_duration = 2492;
	trial_type = fixed;
   all_responses = false;
   stimulus_event {
      picture {
         text letters;
         x = 0; y = 0;
      } pic;
      time = 0;
      duration = 492;
   } n_back_event;
} n_back_trial;

#Conclusion: 1 back
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text { 
				caption = "Great job! You have completed the 1-back practice.\n\nPress the spacebar to continue to the 2-back practice instructions."; 
				font_size = 14; 
			};
			x = 0; y = 0;
		}; 
} end_1back;

#Conclusion: end task
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text { 
				caption = "Great job! You have completed the practice 2-back task.\n\nPlease let the experimenter know."; 
				font_size = 14;
			};
			x = 0; y = 0;
		}; 
} conclusion;

begin_pcl;

preset int lvl_round1; #user enters in which level (stim dur) we should set the task to based on performance on practice task
preset int lvl_round2; #user enters in which level (stim dur) we should set the task to based on performance on practice task

#Subscript that randomly selects a letter EXCEPT for the previous letter displayed (because this letter is NOT a target)
sub
   int random_exclude( int first, int last, int exclude )
begin
   int rval = random( first, last - 1 );
   if (rval >= exclude) then
      rval = rval + 1
   end;
   return rval
end;

#SET total # trials here
int stim_count = 15;

#SET 30% of stimuli as targets
array<int> is_target[stim_count];
loop int i = 1 until i > stim_count / 3 begin
   is_target[i] = 1;
   i = i + 1
end;

#Randomize where the targets are in the array
is_target.shuffle();

#For 1-back: Keep randomizing array until you have one where the first stimulus displayed cannot be correct responses
if lvl_round1 == 1 then
	loop until is_target[1] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 2 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 3 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 4 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 5 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0 && is_target[5] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 6 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0 && is_target[5] == 0 && is_target[6] == 0
	begin
		is_target.shuffle()
	end;
end;

#Present intro slides
intro_1.present();
intro_2.present();
begin_1back.present();
get_ready_practice.present();

#SET total # of combined 1 and 2 back runs here
int num_runs = 6;

#Present n-back trials
loop int x = 1 until x > num_runs
begin
	loop
		int i = 1;
		array<int> nbacks[6] = {1,2,3,4,5,6}; 
		array<int> holders[6] = {0,0,0,0,0,0}; 
	until
		i > stim_count
	begin
		int index;
		string target_string = "no"; #Write to the log file that letter is not a target.
		#If this next stimulus is a target then set it to the same letter as the one before it.
		if (is_target[i] == 1) then
				index = holders[x];
			target_string = "yes"; #Writes to the log file that letter is a target. 
			n_back_event.set_target_button({1,2,4,5}); #Set the correct response button
		#Otherwise randomly select any number in the Letters array EXCLUDING the previous letter
		else
				index = random_exclude( 1, letters_set.count(), holders[x] )
		end;
		pic.set_part( 1, letters_set[index] );
		n_back_event.set_event_code(logfile.subject() + "," + string(x) + "," + letters_set[index].description() + "," + target_string );
		holders[1] = index; #same for all n-backs
		if (x > 1) then
			loop int z = 0 until z == x - 1
			begin
				holders[x-z] = holders[x-z-1];
				z = z + 1;
			end;
		end;
		n_back_trial.present();
		i = i + 1;
	end;
	x = x + 1;
	if (x > num_runs) then 
		break;
	end;
	end_1back.present();
	#Randomize stimuli order for n-back
if lvl_round1 == 1 then
	loop until is_target[1] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 2 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 3 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 4 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 5 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0 && is_target[5] == 0  
	begin
		is_target.shuffle()
	end;
else if lvl_round1 == 6 then 	
	loop until is_target[1] == 0 && is_target[2] == 0 && is_target[3] == 0 && is_target[4] == 0 && is_target[5] == 0 && is_target[6] == 0
	begin
		is_target.shuffle()
	end;
end;	begin_2back.present();
	get_ready_practice.present();
end;

conclusion.present();