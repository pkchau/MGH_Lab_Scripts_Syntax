#NOTE: display size is 640 x 480 on old exptl laptop, so this expt is set to 640 x 480 to match.
#Stim font size = 36 in old expt

#Header
response_matching = simple_matching;
default_font = "Arial"; #Closest Font to old expt font which is Courier New bolded + keep consistent w/ Flanker
default_font_size = 36;  
active_buttons = 13;
button_codes = 1,2,3,4,5,6,7,8,9,10,11,12,13;
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

array {
	text {font_size = 14; caption="'2-back: Practice'\n\nPress '1' if the letter matches TWO letters before it i.e. A B A.\n\nWe will now practice the 2-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; description = "2back";} n_in;
	text {font_size = 14; caption="'3-back: Practice'\n\nPress '1' if the letter matches THREE letters before it i.e. A B C A\n\nWe will now practice the 3-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; description = "3back";};
	text {font_size = 14; caption="'4-back: Practice'\n\nPress '1' if the letter matches FOUR letters before it i.e. A B C D A\n\nWe will now practice the 4-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; description = "4back";};
	text {font_size = 14; caption="'5-back: Practice'\n\nPress '1' if the letter matches FIVE letters before it i.e. A B C D E A\n\nWe will now practice the 5-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; description = "5back";};
} nback_intro_set;

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
				caption = "In this task, random letters appear one at a time in the center of the screen.\n\nThere will be 5 different levels of difficulty.\n\nPress the spacebar to proceed."; 
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
				caption = "For ALL 5 levels of the task, you use the '1' key on the keyboard.\n\nYou may use the '1' key on the numberpad OR\n\nYou may use the '1' key above the QWERTY letters.\n\nPlease choose whichever would be preferable for you.\n\nPress the spacebar to proceed."; 
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
				caption = "'1-back: Practice'\n\nPress '1' if the letter you see is the same as the one before it i.e. 'A' 'A'\n\nWe will now practice the 1-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
				font_size = 14; 
			};
			x = 0; y = -25;
		}; 
} begin_1back;

#Begin 2-5 back
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
			text n_in;
			x = 0; y = -25;
		} begin_nback_pic; 
} begin_nback;

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
   trial_duration = stimuli_length;
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
	stimulus_event {
		picture {
		} blank_pic;
		time = 492;  
		duration = 1492; 
	} blank_event;	
} n_back_trial;

#Next level
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text { 
				caption = "Great job! You have completed this level.\n\nPress the spacebar to continue to the next level instructions."; 
				font_size = 14; 
			};
			x = 0; y = 0;
		}; 
} next_level;

#Conclusion: end task
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text { 
				caption = "Great job! You have completed all 5 levels of the task.\n\nPlease let the experimenter know."; 
				font_size = 14;
			};
			x = 0; y = 0;
		}; 
} conclusion;

begin_pcl;

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

#SET total # of n-back levels here
int num_levels = 5;
#SET total # trials here
int stim_count = 30;

#SET 30% of stimuli as targets
array<int> is_target[stim_count];
loop int i = 1 until i > stim_count / 3 
begin
   is_target[i] = 1;
   i = i + 1
end;

#Randomize where the targets are in the array
is_target.shuffle();

#For 1-back: Keep randomizing array until you have one where the first stimulus displayed cannot be a correct response
loop until is_target[1] == 0  
begin
	is_target.shuffle()
end;

#Present intro slides
intro_1.present();
intro_2.present();
begin_1back.present();
get_ready_practice.present();

#Present n-back trials
loop int x = 1 until x > num_levels
begin
	loop
		int i = 1;
		array<int> holders[5] = {0,0,0,0,0}; 
	until
		i > stim_count
	begin
		int index;
		string target_string = "no"; #Write to the log file that letter is not a target.
		#If this next stimulus is a target then set it to the same letter as the n letters before it.
		if (is_target[i] == 1) then
			index = holders[x];
			target_string = "yes"; #Writes to the log file that letter is a target. 
			n_back_event.set_target_button({1,2}); #Set the correct response button
		#Otherwise randomly select any number in the Letters array EXCLUDING the previous letter
		else
			index = random_exclude( 1, letters_set.count(), holders[x] )
		end;
		pic.set_part( 1, letters_set[index] );
		n_back_event.set_event_code(logfile.subject() + "," + string(x) + "," + letters_set[index].description() + "," + target_string);
		if (x > 1) then
			loop int z = 0 until z == x - 1
			begin
				holders[x-z] = holders[x-z-1];
				z = z + 1;
			end;
		end;
		holders[1] = index; #same for all n-backs
		n_back_trial.present();
		i = i + 1;
	end;
	if (x == num_levels) then 
		break;
	end;
	next_level.present();
	begin_nback_pic.set_part(2, nback_intro_set[x] );
	begin_nback.present();	
	get_ready_practice.present();
	x = x + 1;
	is_target.shuffle();
	#Keep shuffling until 1 up to n letters being presented are NOT targets (since that would be impossible for the task) 
	bool acc = false;
	loop int k = 1 until k > x
	begin
		loop until acc
		begin
			acc = is_target[k] == 0;
			if acc == false then
				is_target.shuffle();
				k = 1;
			end;
		end;
		k = k + 1;
		acc = false;
	end;
end;

conclusion.present();