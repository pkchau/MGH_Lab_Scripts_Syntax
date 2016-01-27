#NOTE: display size is 640 x 480 on old exptl laptop, so this expt is set to 640 x 480 to match.

#Header
response_matching = simple_matching;
default_font_size = 36; #Stim font size = 36 in old expt
active_buttons = 3;
button_codes = 1,2,3;
stimulus_properties = letter, string, is_target, string;
event_code_delimiter = ",";
#End Header

#Begin SDL
begin;

#List of letters used in expt
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
			caption = "We will now move on to the real versions of the 1-back and 2-back tasks\n\nThere will be 2 rounds of the 1-back task and 2 rounds of the 2-back task.\n\nPress the spacebar to proceed."; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} intro_1;

#Begin Real 1-back Round 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "'1-back'\n\nFor the 1-back task, press '1' if the letter you see is the same as the one before it.\n\nWe will now begin the real 1-back task.\n\nRemember to be as QUICK and ACCURATE as you can\n\nPress the spacebar when you are ready to start the task!"; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} begin_1back;

#Begin Real 2-back round 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "'2-back'\n\nFor the 2-back task, press '1' if the letter you see is the same as TWO letters before it.\n\nWe will now begin the real 2-back task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} begin_2back;

#Get ready - real task
trial {
	trial_duration = 2992; #Set as 2992 instead of 3000 to take intoa ccount refresh rate
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Get ready!\n\nThe task is about to start!"; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} get_ready_real;

#1-back task
trial {
   trial_duration = 2492;
   all_responses = false;
   stimulus_event {
      picture {
         text letters;
         x = 0; y = 0;
      } pic;
      time = 0;
      duration = 492;
   } event1;
} n_back_trial;

#Conclusion: 1 back
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Great job! You have completed the 1-back task.\n\nPress the spacebar to continue to the 2 back instructions."; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} end_1back;

#Conclusion: 2 back
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Great job! You have completed the 2-back task.\n\nPress the spacebar to continue."; 
			font_size = 14; 
		};
		x = 0; y = 0;
		}; 
} end_2back;

#Conclusion: end of task
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "Great job! You have completed the all runs of the 1-back and 2-back tasks.\n\nPlease let the experimenter know."; 
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

#SET num trials here  
int stim_count = 30;

#Have 30% of stimuli be targets
array<int> is_target[stim_count];
loop int i = 1 until i > stim_count / 3 begin
   is_target[i] = 1;
   i = i + 1
end;

#Set variable to detect if 1back or 2back
bool oneback = true;

#Randomize where the targets are in the array
is_target.shuffle();
#If 1-back: keep randomizing array until you have one where the first stimulus displayed cannot be a correct response.
#If 2-back: Keep randomizing array until you have one where the first TWO stimuli displayed cannot be correct responses
if (oneback == true) then
	loop until is_target[1] == 0 
	begin
		is_target.shuffle()
	end;
else
	loop until is_target[1] == 0 && is_target[2] == 0 
	begin
		is_target.shuffle()
   end;
end;

#Present Intro Slides
intro_1.present();
begin_1back.present();
get_ready_real.present();

#SET total # of 1 and 2 back runs here
int num_runs = 4;

#Present n-back trials
loop int x = 1 until x > num_runs
begin
	loop
		int i = 1;
		int previous = 0;
		int two_back = 0;
	until
		i > stim_count
	begin
		int index;
		string target_string = "no"; #Write to the log file that letter is not a target.
		#If this next stimulus is a target then set it to the same letter as the one before it.
		if (is_target[i] == 1) then
			if (oneback == true) then
				index = previous;
			else
				index = two_back
			end;
			target_string = "yes" #Writes to the log file that letter is a target. 
		#Otherwise randomly select any number in the Letters array EXCLUDING the previous letter
		else
			if (oneback == true) then
				index = random_exclude( 1, letters_set.count(), previous )
			else
				index = random_exclude( 1, letters_set.count(), two_back )
			end;
		end;
		pic.set_part( 1, letters_set[index] );
		event1.set_event_code( letters_set[index].description() + "," + target_string );
		if (oneback == true) then
			previous = index;
		else
			two_back = previous;
			previous = index;
		end;
		n_back_trial.present();
		i = i + 1;
	end;
	x = x + 1;
	if (oneback == true) then
		end_1back.present();
		begin_2back.present();
	else
		end_2back.present();
		begin_1back.present();
	end;
	get_ready_real.present();
	oneback = !oneback;
end;

conclusion.present();